//
//  SchoolViewController.swift
//  ClassR
//
//  Created by Evan Shrestha on 11/12/18.
//  Copyright © 2018 Evan Shrestha. All rights reserved.
//

import UIKit
import Firebase

class SchoolViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var schools : Dictionary<Int, School> = [:]
    var schoolIndex = 0
    
    @IBOutlet weak var schoolTableView: UITableView!
    
    @IBOutlet weak var schoolTextField: UITextField!
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return schools.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let school : School = schools[indexPath.row]!
        let cell = tableView.dequeueReusableCell(withIdentifier: "schoolCell") as! SchoolTableViewCell
        cell.schoolNameLabel.text = school.name
        cell.schoolNicknameLabel.text = school.nickname
        cell.schoolDatabaseID = school.databaseID
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        School.selectedSchoolDatabaseID = schools[indexPath.row]!.databaseID
        performSegue(withIdentifier: "showSchoolPosts", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        loadSchools()
        
    }
    
    func loadSchools() {
        self.schools = [:]
        self.schoolIndex = 0
        Database.database().reference().child("schools").queryOrderedByKey().observe(.childAdded, with: { (snapshot) in
            print(snapshot)
            if let schoolDict = snapshot.value as? NSDictionary {
                let schoolName = schoolDict["name"] as! String
                let schoolNickname = schoolDict["nickname"] as! String
                let school : School = School(databaseID: snapshot.key, name: schoolName, nickname: schoolNickname)
                
                self.schools[self.schoolIndex] = school
                
                self.schoolIndex = self.schoolIndex + 1
            } else {
                print("No schools found")
            }
            
            self.schoolTableView.reloadData()
        }) {
            (error) in
            print(error.localizedDescription)
        }
        
        schoolTableView.reloadData()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showSchoolPosts") {
            //(segue.destination as! NewsViewController).schoolDatabaseID = self.selectedSchoolDatabaseID
        }
    }

}
