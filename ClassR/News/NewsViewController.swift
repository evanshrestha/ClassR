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
    
    var postNumber = 0
    
    static var selectedStatus : Status?
    
    private let pulldownRefreshControl = UIRefreshControl()
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if Status.statuses.count == 0 {
            var emptyLabel = UILabel()
            emptyLabel.text = "Nothing seems to be here yet"
            emptyLabel.textColor = UIColor.white
            emptyLabel.font = UIFont(name: "Open Sans", size: CGFloat(17))
            emptyLabel.textAlignment = NSTextAlignment.center
            self.tableView.backgroundView = emptyLabel
        }
        return Status.statuses.count
    }
    
    @IBAction func onRefreshButtonClick(_ sender: Any) {
        reloadStatuses()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsCell") as! NewsTableViewCell
        let statusDatabaseID = Status.statuses[Status.statuses.count - indexPath.row - 1]!.keys.first!
        let status = Status.statuses[Status.statuses.count - indexPath.row - 1]![statusDatabaseID]!
        
        let statusText = status.statusText
        let courseDatabaseID = status.courseReferenceID
        if let course = Course.courses[courseDatabaseID] {
            cell.classNameLabel.text = course.courseName
        } else {
            cell.classNameLabel.text = ""
        }
        
        
        cell.newsTextLabel.text = statusText
        
        cell.status = status
        
        return cell
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        newsTableView.rowHeight = UITableView.automaticDimension
        newsTableView.estimatedRowHeight = 200
        
        pulldownRefreshControl.tintColor = UIColor.white
        if #available(iOS 10.0, *) {
            newsTableView.refreshControl = pulldownRefreshControl
        } else {
            newsTableView.addSubview(pulldownRefreshControl)
        }
        newsTableView.refreshControl!.addTarget(self, action: #selector(reloadStatuses), for: .valueChanged)
        reloadStatuses()
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
        }
        
        if (segue.identifier == "statusToCommentsSegue") {
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
