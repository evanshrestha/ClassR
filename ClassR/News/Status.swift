//
//  Status.swift
//  ClassR
//
//  Created by Evan Shrestha on 11/9/18.
//  Copyright © 2018 Evan Shrestha. All rights reserved.
//

import Foundation
import Firebase

class Status {
    var courseReferenceID : String = ""
    var statusText : String = ""
    var datePosted : Date = Date()
    var databaseID : String = ""
    var uuid : String = ""
    var liked : Bool = false
    var imageReferencePath : String = ""
    
    static var statuses : [Int: [String: Status]] = [:]
    static var doneLoading : Bool = false
    
    init(courseReferenceID: String, statusText: String) {
        self.courseReferenceID = courseReferenceID
        self.statusText = statusText
    }
    
    static func loadStatuses(schoolDatabaseID : String, onLoadedStatus : @escaping () -> ()) {
        Status.doneLoading = false
        Status.statuses = [:]
        var index = 0
        let ref = Database.database().reference()
        ref.child("statuses").child(schoolDatabaseID).queryOrdered(byChild: "datePosted").observe(.childAdded, with: { (snapshot) in
            if let currentStatusInfo = snapshot.value as? NSDictionary {
                if let currentStatusText = currentStatusInfo["statusText"] as? String,
                    let currentCourseReferenceID = currentStatusInfo["courseReferenceID"] as? String {
                    let currentStatus = Status(courseReferenceID: currentCourseReferenceID, statusText: currentStatusText)
                    currentStatus.databaseID = snapshot.key
                    if let uuid = currentStatusInfo["uuid"] as? String {
                        currentStatus.uuid = uuid
                    }
                    if let imageRef = currentStatusInfo["imageReferencePath"] as? String {
                        currentStatus.imageReferencePath = imageRef
                    }
                    Status.statuses[index] = [snapshot.key : currentStatus]
                    index = index + 1
                    
                    
                    
                }
                onLoadedStatus()
            } else {
                print("No statuses found")
            }
        }) {
            (error) in
            print(error.localizedDescription)
        }
    }
    
}
