//
//  CreateCommentViewController.swift
//  ClassR
//
//  Created by Evan Shrestha on 11/14/18.
//  Copyright © 2018 Evan Shrestha. All rights reserved.
//

import UIKit
import Firebase

class CreateCommentViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {
    @IBOutlet weak var nicknameLabel: UITextField!
    @IBOutlet weak var replyTextView: UITextView!
    @IBOutlet weak var backgroundView: UIView!
    
    var selectedStatus : Status?
    var commentViewController : CommentViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.replyTextView.layer.borderWidth = CGFloat(1)
        self.replyTextView.layer.borderColor = UIColor.lightGray.cgColor
        self.nicknameLabel.delegate = self
        self.replyTextView.delegate = self
        let outsideTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onOutsideTap))
        backgroundView.addGestureRecognizer(outsideTapGestureRecognizer)
    }
    
    @objc func onOutsideTap() {
        replyTextView.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func onCommentPostButtonClick(_ sender: Any) {
        
        if (nicknameLabel.text!.isEmpty) {
            _ = Toast(text: "Please enter a nickname")
            return
        }
        
        if (replyTextView.text!.isEmpty) {
            _ = Toast(text: "Please enter a reply")
            return
        }
        
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
    
}
