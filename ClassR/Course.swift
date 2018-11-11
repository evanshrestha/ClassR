//
//  Course.swift
//  ClassR
//
//  Created by Evan Shrestha on 11/9/18.
//  Copyright © 2018 Evan Shrestha. All rights reserved.
//

import Foundation

class Course {
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
}
