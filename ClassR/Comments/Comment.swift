//
//  Comment.swift
//  ClassR
//
//  Created by Evan Shrestha on 11/13/18.
//  Copyright © 2018 Evan Shrestha. All rights reserved.
//

import Foundation
import Firebase

class Comment {
    
    static var comments : Dictionary<Int, Comment> = [:]
    
    var text = ""
    var creatorUUID = UIDevice.current.identifierForVendor!.uuidString
    var status : Status?
    var creatorNickname = ""
    var databaseID = ""
    var dateCreated = Date()
    
    static let dateFormatter : DateFormatter = DateFormatter()
    
    static func loadComments(selectedStatus: Status, onLoadedComment : @escaping () -> ()) {
        Comment.comments = [:]
        var i = 0
        let ref = Database.database().reference()
        ref.child("comments").child(School.selectedSchoolDatabaseID).child(selectedStatus.databaseID).observe(.childAdded, with: { (snapshot) in
            if let currentCommentInfo = snapshot.value as? NSDictionary {
                let currentCommentText = currentCommentInfo["text"] as? String ?? ""
                let currentCommentCreatorUUID = currentCommentInfo["uuid"] as? String ?? ""
                let currentCommentCreatorNickname = currentCommentInfo["nickname"] as? String ?? ""
                let currentCommentDateCreated = currentCommentInfo["dateCreated"] as? String ?? ""
                
                let currentComment = Comment()
                currentComment.status = selectedStatus
                currentComment.creatorUUID = currentCommentCreatorUUID
                currentComment.creatorNickname = currentCommentCreatorNickname
                currentComment.text = currentCommentText
                currentComment.dateCreated = dateFormatter.date(from: currentCommentDateCreated)!
                currentComment.databaseID = snapshot.key
                
                Comment.comments[i] = currentComment
                i = i + 1
                
                onLoadedComment()
            } else {
                print("No comments found")
            }
        }) { (error) in
            print(error.localizedDescription)
        }

    }
    
    
}
