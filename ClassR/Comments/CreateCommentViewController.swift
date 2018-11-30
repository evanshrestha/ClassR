//
//  CreateCommentViewController.swift
//  ClassR
//
//  Created by Evan Shrestha on 11/14/18.
//  Copyright © 2018 Evan Shrestha. All rights reserved.
//

import UIKit
import Firebase

class CreateCommentViewController: UIViewController {
    @IBOutlet weak var nicknameLabel: UITextField!
    @IBOutlet weak var replyTextView: UITextView!
    
    var selectedStatus : Status?
    var commentViewController : CommentViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func onCommentPostButtonClick(_ sender: Any) {
        postComment()
    }
    
    func postComment() {
        let databaseReference = Database.database().reference()
        let commentsDatabaseReference = databaseReference.child("comments").child(School.selectedSchoolDatabaseID).child(selectedStatus!.databaseID).childByAutoId()
        commentsDatabaseReference.child("text").setValue(replyTextView.text!)
        commentsDatabaseReference.child("uuid").setValue(UIDevice.current.identifierForVendor!.uuidString)
        commentsDatabaseReference.child("nickname").setValue(nicknameLabel.text!)
        commentsDatabaseReference.child("dateCreated").setValue(Date().description)
        
        DispatchQueue.main.async {
            var postCreated = false
            var numChecks = 0
            while (!postCreated && numChecks < 5) {
                
                usleep(200000)
                self.commentViewController?.reloadComments()
                for comment in Comment.comments.values {
                    if commentsDatabaseReference.key == comment.databaseID {
                        postCreated = true
                        self.navigationController?.popViewController(animated: true)
                        break
                    }
                }
                numChecks = numChecks + 1
            }
        }
        self.navigationController?.popViewController(animated: true)
        
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
