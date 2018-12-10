//
//  Status.swift
//  ClassR
//
//  Created by Evan Shrestha on 11/9/18.
//  Copyright © 2018 Evan Shrestha. All rights reserved.
//

import Foundation
import Firebase
import CoreData

// "Status" is inconsistent with "News" because I can't make up my mind
class Status {
    
    // Initialize a bunch of stuff
    var courseReferenceID : String = ""
    var statusText : String = ""
    var datePosted : Date = Date()
    var databaseID : String = ""
    var uuid : String = ""
    var likeCount : Int = 0
    var liked : Bool = false
    let deviceUUID = UIDevice.current.identifierForVendor!.uuidString
    var imageReferencePath : String = ""
    var saved : Bool = false
    var nsObject : NSManagedObject?
    static let ref = Database.database().reference()
    
    
    static var statuses : [Int: [String: Status]] = [:]
    static var savedStatuses : [NSManagedObject] = []
    static var doneLoading : Bool = false
    
    static var appDelegate = UIApplication.shared.delegate as? AppDelegate
    static var context = appDelegate?.persistentContainer.viewContext
    
    init(courseReferenceID: String, statusText: String) {
        self.courseReferenceID = courseReferenceID
        self.statusText = statusText
    }
    
    func onSave() {
        do {
            let entity = NSEntityDescription.entity(forEntityName: "SavedStatus", in: Status.context!)
            let currentStatus = NSManagedObject(entity: entity!, insertInto: Status.context!)
            currentStatus.setValue(self.databaseID, forKey: "databaseID")
            
            self.nsObject = currentStatus
            self.saved = true

            Status.savedStatuses.append(currentStatus)
            try Status.context!.save()
            print(Status.savedStatuses)
        } catch {
            print("Failed saving")
        }
    }
    
    func onUnsave() {
        print("UNSAVING")
        do {
            Status.context!.delete(self.nsObject!)
            if let index = Status.savedStatuses.index(of: self.nsObject!) {
                Status.savedStatuses.remove(at: index)
                print(index)
            }
            self.saved = false
            try Status.context!.save()
        } catch {
            print("Failed unsaving")
        }
    }
    
    func onLike() {
        if (liked) {
            likeCount -= 1
        Status.ref.child("likes").child(School.selectedSchoolDatabaseID).child(databaseID).child(deviceUUID).removeValue()
        } else {
            likeCount += 1
            Status.ref.child("likes").child(School.selectedSchoolDatabaseID).child(databaseID).child(deviceUUID).setValue(true)
        }
        liked = !liked
    Status.ref.child("statuses").child(School.selectedSchoolDatabaseID).child(databaseID).child("likeCount").setValue(likeCount)
    }
    
    static func loadStatuses(schoolDatabaseID : String, onLoadedStatus : @escaping () -> ()) {
        Status.doneLoading = false
        Status.statuses = [:]
        var index = 0
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
                    if let likeCount = currentStatusInfo["likeCount"] as? Int {
                        currentStatus.likeCount = likeCount
                    }
                    ref.child("likes").child(schoolDatabaseID).child(currentStatus.databaseID).observe(.value, with: { (snapshot) in
                        if snapshot.hasChild(UIDevice.current.identifierForVendor!.uuidString) {
                            currentStatus.liked = true
                            onLoadedStatus()
                        }
                    })
                    if (isSavedStatus(databaseID: snapshot.key)) {
                        currentStatus.saved = true
                        
                        currentStatus.nsObject = Status.getSavedStatusNSObject(databaseID: snapshot.key)
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
    
    static func isSavedStatus(databaseID : String) -> Bool {
        for savedStatus in savedStatuses {
            if (databaseID == savedStatus.value(forKey: "databaseID") as? String ?? "") {
                return true
            }
        }
        return false
    }
    
    static func getSavedStatusNSObject(databaseID : String) -> NSManagedObject {
        for savedStatus in savedStatuses {
            if (databaseID == savedStatus.value(forKey: "databaseID") as? String ?? "") {
                return savedStatus
            }
        }
        return NSManagedObject()
    }
    
    static func loadStatuses(schoolDatabaseID : String, savedOnly : Bool, onLoadedStatus : @escaping () -> ()) {
        
        if (savedOnly) {
            Status.doneLoading = false
            Status.statuses = [:]
            var index = 0
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
                        if let likeCount = currentStatusInfo["likeCount"] as? Int {
                            currentStatus.likeCount = likeCount
                        }
                        ref.child("likes").child(schoolDatabaseID).child(currentStatus.databaseID).observe(.value, with: { (snapshot) in
                            if snapshot.hasChild(UIDevice.current.identifierForVendor!.uuidString) {
                                currentStatus.liked = true
                                onLoadedStatus()
                            }
                        })
                        if (isSavedStatus(databaseID: snapshot.key)) {
                            currentStatus.saved = true
                            currentStatus.nsObject = Status.getSavedStatusNSObject(databaseID: snapshot.key)
                            Status.statuses[index] = [snapshot.key : currentStatus]
                            index = index + 1
                        }
                    }
                    
                    onLoadedStatus()
                } else {
                    print("No statuses found")
                }
            }) {
                (error) in
                print(error.localizedDescription)
            }
        } else {
            Status.doneLoading = false
            Status.statuses = [:]
            var index = 0
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
                        if let likeCount = currentStatusInfo["likeCount"] as? Int {
                            currentStatus.likeCount = likeCount
                        }
                        ref.child("likes").child(schoolDatabaseID).child(currentStatus.databaseID).observe(.value, with: { (snapshot) in
                            if snapshot.hasChild(UIDevice.current.identifierForVendor!.uuidString) {
                                currentStatus.liked = true
                                onLoadedStatus()
                            }
                        })
                        if (isSavedStatus(databaseID: snapshot.key)) {
                            currentStatus.saved = true
                            currentStatus.nsObject = Status.getSavedStatusNSObject(databaseID: snapshot.key)
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
    
    static func loadSavedStatuses() {
        do {
            var savedStatus :NSManagedObject?
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "SavedStatus")
            let result = try Status.context!.fetch(request)
            
            if (result.count == 0) {
                let entity = NSEntityDescription.entity(forEntityName: "SavedStatus", in: context!)
                savedStatus = NSManagedObject(entity: entity!, insertInto: context)
            } else {
                for data in result as! [NSManagedObject] {
                    savedStatus = data
                    self.savedStatuses.append(savedStatus!)
                }
            }
            print(self.savedStatuses)
            print(self.savedStatuses.count)
        } catch {
            print("error with coredata")
        }
    }
    
}
