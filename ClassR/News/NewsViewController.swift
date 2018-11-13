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
    
    var testCourse : Course?
    var testStatus : Status?
    
    var postNumber = 0
    
    static var selectedStatus : Status?
    
    var selectedStatusNSDictionary : NSDictionary = NSDictionary()
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
    
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return CGFloat(200);
//    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        newsTableView.rowHeight = UITableView.automaticDimension
        newsTableView.estimatedRowHeight = 200
        
//        testCourse = Course(courseName: "Jazz Appreciation", courseDepartment: "MUS", courseNumber: "307", courseInstructor: "Jeff Hellmer", courseID: "2312", coursePeriod: "Fall 2018")
//        testCourse!.databaseID = "-LQwSgE9YtZBFIl3tcHu"
//        testStatus = Status(course: testCourse!, statusText: "ASDF")
        
//        var ref: DatabaseReference!
//        ref = Database.database().reference().child("courses").childByAutoId()
//        ref.child("courseName").setValue(testCourse!.courseName)
//        ref.child("courseDepartment").setValue(testCourse!.courseDepartment)
//        ref.child("courseNumber").setValue(testCourse!.courseNumber)
//        ref.child("courseInstructor").setValue(testCourse!.courseInstructor)
//        ref.child("courseID").setValue(testCourse!.courseID)
//        ref.child("coursePeriod").setValue(testCourse!.coursePeriod)
        
       
        
        reloadStatuses()
        
        
        // Do any additional setup after loading the view.
    }
    
    func reloadStatuses() {
    
        Course.loadCourses(schoolDatabaseID: School.selectedSchoolDatabaseID, onLoadedCourse: {
            self.newsTableView.reloadData()
        })
        
        Status.loadStatuses(schoolDatabaseID: School.selectedSchoolDatabaseID, onLoadedStatus: {
            self.newsTableView.reloadData()
        })
        
        
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showAddPost") {
//            (segue.destination as! PostViewController).schoolDatabaseID = School.selectedSchoolDatabaseID
        }
        
        if (segue.identifier == "statusToCommentsSegue") {
            (segue.destination as! CommentViewController).status = NewsViewController.selectedStatus
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        reloadStatuses()
    }
    
}
