//
//  Course.swift
//  ClassR
//
//  Created by Evan Shrestha on 11/9/18.
//  Copyright © 2018 Evan Shrestha. All rights reserved.
//

import Foundation
import Firebase

class Course {
    
    static var courses : Dictionary<String, Course> = [:]
    
    var courseName : String = "" // Jazz Appreciation
    var courseDepartment : String = "" // MUS
    var courseNumber : String = "" // 307
    var courseInstructor: String = "" // Jeff Hellmer
    var courseID : String = "" // 54145
    var coursePeriod : String = "" // Fall 2018
    var databaseID : String = ""
    
    init(courseName: String, courseDepartment: String, courseNumber: String, courseInstructor: String, courseID: String, coursePeriod: String) {
        self.courseName = courseName
        self.courseDepartment = courseDepartment
        self.courseNumber = courseNumber
        self.courseInstructor = courseInstructor
        self.courseID = courseID
        self.coursePeriod = coursePeriod
    }
    
    func addToDatabase() {
        let databaseReference = Database.database().reference().child("courses").child(School.selectedSchoolDatabaseID).childByAutoId()
        databaseReference.child("courseDepartment").setValue(self.courseDepartment)
        databaseReference.child("courseName").setValue(self.courseName)
        databaseReference.child("courseNumber").setValue(self.courseNumber)
        databaseReference.child("courseInstructor").setValue(self.courseInstructor)
        databaseReference.child("courseID").setValue(self.courseID)
        databaseReference.child("coursePeriod").setValue(self.coursePeriod)
    }
    
    static func loadCourses(schoolDatabaseID : String, completion : @escaping () -> ()) {
        Course.courses = [:]
        let ref = Database.database().reference()
        ref.child("courses").child(schoolDatabaseID).observe(.childAdded, with: { (snapshot) in
            if let currentCourseInfo = snapshot.value as? NSDictionary {
                let currentCourseDepartment = currentCourseInfo["courseDepartment"] as? String ?? ""
                let currentCourseID = currentCourseInfo["courseID"] as? String ?? ""
                let currentCourseInstructor = currentCourseInfo["courseInstructor"] as? String ?? ""
                let currentCourseName = currentCourseInfo["courseName"] as? String ?? ""
                let currentCourseNumber = currentCourseInfo["courseNumber"] as? String ?? ""
                let currentCoursePeriod = currentCourseInfo["coursePeriod"] as? String ?? ""
                let currentCourseDatabaseID = snapshot.key
                
                let currentCourse = Course(courseName: currentCourseName, courseDepartment: currentCourseDepartment, courseNumber: currentCourseNumber, courseInstructor: currentCourseInstructor, courseID: currentCourseID, coursePeriod: currentCoursePeriod)
                
                currentCourse.databaseID = currentCourseDatabaseID
                
                courses[currentCourseDatabaseID] = currentCourse
                
                completion()
            } else {
                print("No courses found")
            }
        }) {
            (error) in
            print(error.localizedDescription)
        }
    }
}
