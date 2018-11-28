//
//  NewsViewController.swift
//  ClassR
//
//  Created by Evan Shrestha on 11/8/18.
//  Copyright © 2018 Evan Shrestha. All rights reserved.
//

import UIKit
import Firebase

class NewsViewController: UITableViewController {
    
    @IBOutlet weak var newsTableView: NewsTableView!
    
    @IBOutlet weak var newsNavigationItem: UINavigationItem!
    var postNumber = 0
    
    static var selectedStatus : Status?
    
    private let pulldownRefreshControl = UIRefreshControl()
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let emptyLabel = UILabel()
        emptyLabel.text = "Nothing seems to be here yet"
        emptyLabel.textColor = UIColor.white
        emptyLabel.font = UIFont(name: "Open Sans", size: CGFloat(17))
        emptyLabel.textAlignment = NSTextAlignment.center
        if Status.statuses.count == 0 {
            self.tableView.backgroundView = emptyLabel
        } else {
            self.tableView.backgroundView = nil
        }
        return Status.statuses.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let statusDatabaseID = Status.statuses[Status.statuses.count - indexPath.row - 1]?.keys.first {
            let status = Status.statuses[Status.statuses.count - indexPath.row - 1]![statusDatabaseID]!
            
            
            if (!status.imageReferencePath.isEmpty) {
                
                // If status contains an image
                let cell = tableView.dequeueReusableCell(withIdentifier: "newsImageCell") as! NewsImageTableViewCell
                let statusText = status.statusText
                let courseDatabaseID = status.courseReferenceID
                if let course = Course.courses[courseDatabaseID] {
                    cell.courseNameLabel.text = course.courseName
                } else {
                    cell.courseNameLabel.text = ""
                }
                cell.statusTextLabel.text = statusText
                
                cell.status = status
                
                if status.uuid == UIDevice.current.identifierForVendor!.uuidString {
                    let n = Int.random(in: 0..<16*16*16*16*16*16)
                    var st = String(format:"%06X", n)
                    cell.ribbonView.isHidden = false
                } else {
                    let n = Int.random(in: 0..<16*16*16*16*16*16)
                    var st = String(format:"%06X", n)
                    
                    cell.ribbonView.isHidden = true
                }
                
                if (status.liked) {
                    cell.likeButton.setTitle("Liked", for: .normal)
                    cell.likeButton.setTitleColor(UIColor(hexString: "#00A8E8"), for: .normal)
                } else {
                    cell.likeButton.setTitle("Like", for: .normal)
                    cell.likeButton.setTitleColor(UIColor(hexString: "#6F7179"), for: .normal)
                }
                
                // Initialize with empty image
                cell.statusImageView.image = nil
                
                // Load image
                let imageRef = Storage.storage().reference(withPath: "images/" + School.selectedSchoolDatabaseID + "/" + status.imageReferencePath)
                
                // Max size is 10MB
                imageRef.getData(maxSize: 10 * 1024 * 1024) { data, error in
                    if error != nil {
                        print("ERROR WITH DOWNLOADING IMAGE")
                    } else {
                        let image = UIImage(data: data!)
                        let ratio = image!.size.width / image!.size.height
                        let newHeight = cell.statusImageView.frame.width / ratio
                        cell.statusImageView.image = image
                        cell.imageHeightConstraint.constant = newHeight
                    }
                }
                
                return cell
            } else {
                // If status does not contain an image
                let cell = tableView.dequeueReusableCell(withIdentifier: "newsCell") as! NewsTableViewCell
                let statusText = status.statusText
                let courseDatabaseID = status.courseReferenceID
                if let course = Course.courses[courseDatabaseID] {
                    cell.classNameLabel.text = course.courseName
                } else {
                    cell.classNameLabel.text = ""
                }
                cell.newsTextLabel.text = statusText
                
                cell.status = status
                
                if status.uuid == UIDevice.current.identifierForVendor!.uuidString {
                    let n = Int.random(in: 0..<16*16*16*16*16*16)
                    var st = String(format:"%06X", n)
                    cell.ribbonView.isHidden = false
                    cell.circleView.isHidden = true
                } else {
                    let n = Int.random(in: 0..<16*16*16*16*16*16)
                    var st = String(format:"%06X", n)
                    
                    cell.ribbonView.isHidden = true
                    cell.circleView.isHidden = true
                }
                
                if (status.liked) {
                    cell.likeButton.setTitle("Liked", for: .normal)
                    cell.likeButton.setTitleColor(UIColor(hexString: "#00A8E8"), for: .normal)
                } else {
                    cell.likeButton.setTitle("Like", for: .normal)
                    cell.likeButton.setTitleColor(UIColor(hexString: "#6F7179"), for: .normal)
                }
                return cell
            }
        }
        return tableView.dequeueReusableCell(withIdentifier: "newsCell") as! NewsTableViewCell
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        newsTableView.rowHeight = UITableView.automaticDimension
        newsTableView.estimatedRowHeight = 200
        
        newsTableView.showsVerticalScrollIndicator = false
        
        pulldownRefreshControl.tintColor = UIColor.white
        if #available(iOS 10.0, *) {
            newsTableView.refreshControl = pulldownRefreshControl
        } else {
            newsTableView.addSubview(pulldownRefreshControl)
        }
        newsTableView.refreshControl!.addTarget(self, action: #selector(reloadStatuses), for: .valueChanged)
        reloadStatuses()
        
        newsNavigationItem.title = School.selectedSchool?.nickname
        
    }
    
    @objc func reloadStatuses() {
    
        Course.loadCourses(schoolDatabaseID: School.selectedSchoolDatabaseID, completion: {
            self.newsTableView.reloadData()
        })
        
        Status.loadStatuses(schoolDatabaseID: School.selectedSchoolDatabaseID, onLoadedStatus: {
            self.newsTableView.reloadData()
        })
        
        DispatchQueue.main.async {
            self.pulldownRefreshControl.endRefreshing()
        }
        
    }
    
    

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showAddPost") {
            if let destination = segue.destination as? PostViewController {
                destination.newsViewController = self
            }
        } else if (segue.identifier == "statusToCommentsSegue") {
            if let destination = segue.destination as? CommentViewController {
                let status = NewsViewController.selectedStatus
                destination.status = status
                destination.course = Course.courses[(status?.courseReferenceID)!]
            }
        } else if (segue.identifier == "statusImageToCommentsSegue") {
            if let destination = segue.destination as? CommentViewController {
                let status = NewsViewController.selectedStatus
                destination.status = status
                destination.course = Course.courses[(status?.courseReferenceID)!]
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
}

