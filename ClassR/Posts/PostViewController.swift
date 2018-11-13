//
//  PostViewController.swift
//  ClassR
//
//  Created by Evan Shrestha on 11/11/18.
//  Copyright © 2018 Evan Shrestha. All rights reserved.
//

import UIKit
import Firebase

class PostViewController: UIViewController {

    @IBOutlet weak var insideView: UIView!
    @IBOutlet var outsideTapGestureRecognizer: UITapGestureRecognizer!
    
    @IBOutlet weak var courseDepartmentTextField: UITextField!
    @IBOutlet weak var courseNumberTextField: UITextField!
    @IBOutlet weak var postTextField: UITextView!
    @IBAction func onPostButtonClick(_ sender: Any) {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        Database.database().reference().child("courses").child(School.selectedSchoolDatabaseID).observeSingleEvent(of: .value, with: { (snapshot) in
            
            var courses : NSDictionary
            courses = snapshot.value as! NSDictionary
            
            for course in courses {
                let courseDatabaseReference = course.key
                let courseInformation = courses[courseDatabaseReference] as! NSDictionary
                if ((courseInformation["courseDepartment"] as! String) == self.courseDepartmentTextField.text!) && ((courseInformation["courseNumber"] as! String) == self.courseNumberTextField.text!) {
                    let newPostReference = ref.child("statuses").child(School.selectedSchoolDatabaseID).childByAutoId()
                    newPostReference.child("statusText").setValue(self.postTextField.text!)
                    newPostReference.child("courseReferenceID").setValue(courseDatabaseReference)
                    newPostReference.child("datePosted").setValue(Date().description)
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
        })
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //outsideView.addGestureRecognizer(outsideTapGestureRecognizer)
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
 */
    
 

}
