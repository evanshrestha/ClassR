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
    
    var statuses : Dictionary<Int, NSDictionary> = [:]
    var courses : NSDictionary = NSDictionary()
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statuses.count
    }
    
    @IBAction func onRefreshButtonClick(_ sender: Any) {
        reloadStatuses()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsCell") as! NewsTableViewCell
        let statusText : String = (statuses[statuses.count - indexPath.row - 1] as! NSDictionary)["statusText"]! as! String
        let courseDatabaseID : String = (statuses[statuses.count - indexPath.row - 1] as! NSDictionary)["courseReferenceID"]! as! String
        let courseName : String = (courses[courseDatabaseID] as! NSDictionary)["courseName"] as! String
        cell.classNameLabel.text = courseName
        cell.newsTextLabel.text = statusText
//        cell.status = testStatus!
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(200);
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
//        ref = Database.database().reference().child("statuses").childByAutoId()
//        ref.child("courseReferenceID").setValue(testStatus!.course.databaseID)
//        ref.child("statusText").setValue("hello tatas")
       
        
        reloadStatuses()
        
        
        // Do any additional setup after loading the view.
    }
    
    func reloadStatuses() {
        self.statuses = [:]
        self.postNumber = 0
    Database.database().reference().child("statuses").queryOrdered(byChild: "datePosted").observe(.childAdded, with: { (snapshot) in
        print(snapshot)
    if let statusDict = snapshot.value as? NSDictionary {
        self.statuses[self.postNumber] = snapshot.value! as! NSDictionary
        self.postNumber = self.postNumber + 1
    } else {
    print("No statuses found")
    }
    }) {
    (error) in
    print(error.localizedDescription)
    }
        
    Database.database().reference().child("statuses").queryOrdered(byChild: "datePosted").observeSingleEvent(of: .value, with: { (snapshot) in
        self.newsTableView.reloadData()
    }) {
        (error) in
        print(error.localizedDescription)
    }
        
    Database.database().reference().child("courses").observeSingleEvent(of: .value, with: { (snapshot) in
    if let courseDict = snapshot.value as? NSDictionary{
        self.courses = snapshot.value as! NSDictionary
    } else {
    print("No courses found")
        self.courses = NSDictionary()
    }
    }) {
    (error) in
    print(error.localizedDescription)
    }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    override func viewDidAppear(_ animated: Bool) {
        print("TEST")
    }
}
