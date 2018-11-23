//
//  CourseSearchViewController.swift
//  ClassR
//
//  Created by Evan Shrestha on 11/16/18.
//  Copyright © 2018 Evan Shrestha. All rights reserved.
//

import UIKit

class CourseSearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var courseSearchTableView: UITableView!
    
    var postViewController : PostViewController?
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let emptyLabel = UILabel()
        emptyLabel.text = "Nothing seems to be here yet"
        emptyLabel.textColor = UIColor.white
        emptyLabel.font = UIFont(name: "Open Sans", size: CGFloat(17))
        emptyLabel.textAlignment = NSTextAlignment.center
        if Course.courses.count == 0 {
            tableView.backgroundView = emptyLabel
        } else {
            tableView.backgroundView = nil
        }
        return Course.courses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "courseCell") as! CourseSearchTableViewCell
        let currentCourse = Array(Course.courses.values)[indexPath.row]
        
        let courseName = currentCourse.courseName
        let courseDepartment = currentCourse.courseDepartment
        let courseNumber = currentCourse.courseNumber
        let courseInstructor = currentCourse.courseInstructor
        let coursePeriod = currentCourse.coursePeriod
        let courseID = currentCourse.courseID
        
        cell.courseNameLabel.text = courseName
        cell.courseDepartmentNumberLabel.text = courseDepartment + " " + courseNumber
        cell.courseInstructorLabel.text = courseInstructor
        cell.coursePeriodLabel.text = coursePeriod
        cell.courseIDLabel.text = courseID
        cell.coursePostsLabel.text = ""
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCourse = Array(Course.courses.values)[indexPath.row]
        
        postViewController?.selectCourse(selectedCourse: selectedCourse)
        
        navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(100)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Course.loadCourses(schoolDatabaseID: School.selectedSchoolDatabaseID, completion: {
            self.courseSearchTableView.reloadData()
        })

    }

}
