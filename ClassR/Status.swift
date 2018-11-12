//
//  Status.swift
//  ClassR
//
//  Created by Evan Shrestha on 11/9/18.
//  Copyright © 2018 Evan Shrestha. All rights reserved.
//

import Foundation

class Status {
    var course : Course
    var statusText : String = ""
    var datePosted : Date = Date()
    
    init(course : Course, statusText: String) {
        self.course = course
        self.statusText = statusText
    }
    
}
