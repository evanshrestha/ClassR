//
//  PostViewController.swift
//  ClassR
//
//  Created by Evan Shrestha on 11/11/18.
//  Copyright © 2018 Evan Shrestha. All rights reserved.
//

import UIKit
import Firebase

class PostViewController: UIViewController, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    @IBOutlet weak var insideView: UIView!
    @IBOutlet var outsideTapGestureRecognizer: UITapGestureRecognizer!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var optionsButton: UIButton!
    var newsViewController : NewsViewController?
    var selectedCourse : Course?
    @IBOutlet weak var selectCourseButton: UIButton!
    
    let imagePicker = UIImagePickerController()
    
    @IBOutlet weak var postTextField: UITextView!
    @IBAction func onPostButtonClick(_ sender: Any) {
        
        if (postTextField.text.isEmpty || selectedCourse == nil) {
            return
        }
        
        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        let newPostReference = ref.child("statuses").child(School.selectedSchoolDatabaseID).childByAutoId()
        newPostReference.child("statusText").setValue(self.postTextField.text!)
        newPostReference.child("courseReferenceID").setValue(self.selectedCourse?.databaseID)
        newPostReference.child("datePosted").setValue(Date().description)
        newPostReference.child("uuid").setValue(UIDevice.current.identifierForVendor!.uuidString)
        
        if let selectedImage = imageView.image {
            
            let imageUUID = NSUUID()
            let storageRef = Storage.storage().reference()
            let imageRef = storageRef.child("images").child(School.selectedSchoolDatabaseID).child(
                imageUUID.uuidString + ".jpg")
            
            newPostReference.child("imageReferencePath").setValue(imageUUID.uuidString + ".jpg")
            var data = selectedImage.jpegData(compressionQuality: 0.8)
            imageRef.putData(data!, metadata: nil)
            
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
            if (!postCreated) {
                self.closePostViewController()
            }
        }
    }
    
    func selectCourse(selectedCourse: Course) {
        self.selectedCourse = selectedCourse
        self.selectCourseButton.setTitle(selectedCourse.courseName, for: .normal)
    }
    
    @IBAction func onOutsideTap(_ sender: UITapGestureRecognizer) {
        if (!insideView.layer.bounds.contains(sender.location(in: insideView))) {
            closePostViewController()
        }
    }
    
    @IBOutlet var outsideView: UIView!
    
    func closePostViewController () {
        self.newsViewController?.reloadStatuses()
        self.navigationController?.popViewController(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
        self.postTextField.layer.borderColor = UIColor.lightGray.cgColor
        self.postTextField.layer.cornerRadius = 10
        imagePicker.delegate = self
    }
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        postTextField.resignFirstResponder()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "postToCourseSelectionSegue") {
            if let destination = segue.destination as? CourseSearchViewController {
                destination.postViewController = self
            }
        }
    }
    
    @IBAction func onOptionsClick(_ sender: Any) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let photoAction = UIAlertAction(title: "Take Photo...", style: .default) { (_) in
            self.imagePicker.allowsEditing = false
            self.imagePicker.sourceType = .camera
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        let libraryAction = UIAlertAction(title: "Choose from Library...", style: .default) { (_) in
            self.imagePicker.allowsEditing = false
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        alertController.addAction(photoAction)
        alertController.addAction(libraryAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true) {
            
        }
    }
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = pickedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    @objc func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
