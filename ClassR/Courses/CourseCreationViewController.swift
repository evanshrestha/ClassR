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
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
