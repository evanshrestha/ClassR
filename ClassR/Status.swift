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
    
//    static func loadStatusFromDictionary(statusDict : NSDictionary) -> [String : Status]{
//        var statuses : [String : Status] = [:]
//        
//        for elt in statusDict {
//            let statusInformation : NSDictionary = (elt.value as! NSDictionary)
//            let statusText = statusInformation["statusText"] as! String
//            let courseReferenceID = statusInformation["courseReferenceID"] as! String
//            
//            
//            
//        }
//        
//        return statuses
//    }
}
