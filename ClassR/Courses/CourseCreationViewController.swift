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
    
    static var courseSearchViewController: CourseSearchViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
//    @objc func keyboardWillShow(notification: NSNotification) {
//        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
//            let contentInsets = UIEdgeInsets(top: keyboardSize.height, left: 0, bottom: 0, right: 0)
//            scrollView.contentInset = contentInsets
//            scrollView.scrollIndicatorInsets = contentInsets
//            print(self.view.frame.origin.y)
//            if self.view.frame.origin.y == 64 {
//                self.view.frame.origin.y -= keyboardSize.height
//            }
//        }
//    }
    
//    @objc func keyboardWillHide(notification: NSNotification) {
//        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
//            let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//            scrollView.contentInset = contentInsets
//            scrollView.scrollIndicatorInsets = contentInsets
//
//            print(self.view.frame.origin.y)
//            if self.view.frame.origin.y != 64{
//                self.view.frame.origin.y += keyboardSize.height
//            }
//        }
//    }
    
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
            
            if (courseName.isEmpty || courseDepartment.isEmpty || courseNumber.isEmpty || courseInstructor.isEmpty || coursePeriod.isEmpty || courseID.isEmpty) {
                _ = Toast(text: "Please fill out all fields")
                return
            }
            let currentCourse : Course = Course(courseName: courseName, courseDepartment: courseDepartment, courseNumber: courseNumber, courseInstructor: courseInstructor, courseID: courseID, coursePeriod: coursePeriod)
            
            currentCourse.addToDatabase()
            
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
                Course.loadCourses(schoolDatabaseID: School.selectedSchoolDatabaseID, completion: {
                    CourseCreationViewController.courseSearchViewController!.courseSearchTableView.reloadData()
                })
                _ = Toast(text: "Course added")
            }
            
        }
        
        
    }
    
}
