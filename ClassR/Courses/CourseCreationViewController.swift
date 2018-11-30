//
//  CourseCreationViewController.swift
//  ClassR
//
//  Created by Evan Shrestha on 11/16/18.
//  Copyright © 2018 Evan Shrestha. All rights reserved.
//

import UIKit

class CourseCreationViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var courseNameTextField: UITextField!
    @IBOutlet weak var courseDepartmentTextField: UITextField!
    @IBOutlet weak var courseNumberTextField: UITextField!
    @IBOutlet weak var courseInstructorTextField: UITextField!
    @IBOutlet weak var coursePeriodTextField: UITextField!
    @IBOutlet weak var courseIDTextField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let contentInsets = UIEdgeInsets(top: keyboardSize.height, left: 0, bottom: 0, right: 0)
            scrollView.contentInset = contentInsets
            scrollView.scrollIndicatorInsets = contentInsets
            print(self.view.frame.origin.y)
            if self.view.frame.origin.y == 64 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            scrollView.contentInset = contentInsets
            scrollView.scrollIndicatorInsets = contentInsets
            
            print(self.view.frame.origin.y)
            if self.view.frame.origin.y != 64{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func onSubmitCourseClick(_ sender: Any) {
        createCourse()
    }
    
    func createCourse() {
        if let courseName = courseNameTextField.text,
            let courseDepartment = courseDepartmentTextField.text,
            let courseNumber = courseNumberTextField.text,
            let courseInstructor = courseInstructorTextField.text,
            let coursePeriod = coursePeriodTextField.text,
            let courseID = courseIDTextField.text {
            
            let currentCourse : Course = Course(courseName: courseName, courseDepartment: courseDepartment, courseNumber: courseNumber, courseInstructor: courseInstructor, courseID: courseID, coursePeriod: coursePeriod)
            
            currentCourse.addToDatabase()
        }
        
        
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
