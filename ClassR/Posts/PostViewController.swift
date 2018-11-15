//
//  PostViewController.swift
//  ClassR
//
//  Created by Evan Shrestha on 11/11/18.
//  Copyright © 2018 Evan Shrestha. All rights reserved.
//

import UIKit
import Firebase

class PostViewController: UIViewController, UITextViewDelegate{

    @IBOutlet weak var insideView: UIView!
    @IBOutlet var outsideTapGestureRecognizer: UITapGestureRecognizer!
    
    var newsViewController : NewsViewController?
    
    @IBOutlet weak var courseDepartmentTextField: UITextField!
    @IBOutlet weak var courseNumberTextField: UITextField!
    @IBOutlet weak var postTextField: UITextView!
    @IBAction func onPostButtonClick(_ sender: Any) {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        Database.database().reference().child("courses").child(School.selectedSchoolDatabaseID).observeSingleEvent(of: .value, with: { (snapshot) in
            
            var courses : NSDictionary
            courses = snapshot.value as! NSDictionary
            
            let newPostReference = ref.child("statuses").child(School.selectedSchoolDatabaseID).childByAutoId()
            
            for course in courses {
                let courseDatabaseReference = course.key
                let courseInformation = courses[courseDatabaseReference] as! NSDictionary
                if ((courseInformation["courseDepartment"] as! String) == self.courseDepartmentTextField.text!) && ((courseInformation["courseNumber"] as! String) == self.courseNumberTextField.text!) {
                    newPostReference.child("statusText").setValue(self.postTextField.text!)
                    newPostReference.child("courseReferenceID").setValue(courseDatabaseReference)
                    newPostReference.child("datePosted").setValue(Date().description)
                }
            }
            
            DispatchQueue.main.async {
                var postCreated = false
                var numChecks = 0
                while (!postCreated && numChecks < 5) {
                    
                    usleep(200000)
                    self.newsViewController?.reloadStatuses()
                    for dict in Status.statuses.values {
                        for status in dict.values {
                            if status.databaseID == newPostReference.key {
                                postCreated = true
                                self.closePostViewController()
                                break
                            }
                        }
                    }
                    numChecks = numChecks + 1
                }
            }
            self.closePostViewController()
        }) {
            (error) in
            print(error.localizedDescription)
        }
        
    }
    @IBAction func onOutsideTap(_ sender: UITapGestureRecognizer) {
        if (!insideView.layer.bounds.contains(sender.location(in: insideView))) {
            closePostViewController()
        }
    }
    
    @IBOutlet var outsideView: UIView!
    
    func closePostViewController () {
        dismiss(animated: true, completion: {
            self.newsViewController?.reloadStatuses()
        })
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //outsideView.addGestureRecognizer(outsideTapGestureRecognizer)
        // Do any additional setup after loading the view.
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
 */
    
 

}
