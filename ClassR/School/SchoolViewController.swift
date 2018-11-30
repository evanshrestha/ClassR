//
//  SchoolViewController.swift
//  ClassR
//
//  Created by Evan Shrestha on 11/12/18.
//  Copyright © 2018 Evan Shrestha. All rights reserved.
//

import UIKit
import Firebase
import CoreData

class SchoolViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var schools : Dictionary<Int, School> = [:]
    var schoolIndex = 0
    
    var savedSchoolDatabaseID = ""
    
    var appDelegate : AppDelegate? = UIApplication.shared.delegate as! AppDelegate
    var context : NSManagedObjectContext?
    var settings:NSManagedObject?
    
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
        School.selectedSchool = schools[indexPath.row]
        performSegue(withIdentifier: "showSchoolPosts", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
        do {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Settings")
            if let result = try? context!.fetch(request) {
                for object in result {
                    context!.delete(object as! NSManagedObject)
                }
            }
            let entity = NSEntityDescription.entity(forEntityName: "Settings", in: context!)
            settings = NSManagedObject(entity: entity!, insertInto: context)
            settings!.setValue(schools[indexPath.row]!.databaseID, forKey: "school")
            try context!.save()
            print(settings)
        } catch {
            print("Failed saving")
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadSchools()
        
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate!.persistentContainer.viewContext
        
        
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Settings")
        //request.predicate = NSPredicate(format: "age = %@", "12")
        request.returnsObjectsAsFaults = false
        
        do {
            let result = try context!.fetch(request)
            
            if (result.count == 0) {
                let entity = NSEntityDescription.entity(forEntityName: "Settings", in: context!)
                settings = NSManagedObject(entity: entity!, insertInto: context)
            } else {
                
                for data in result as! [NSManagedObject] {
                    settings = data
                    savedSchoolDatabaseID = data.value(forKey: "school") as! String
                }
            }
        } catch {
            print("error with coredata")
        }
        
        
        
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
                
                if school.databaseID == self.savedSchoolDatabaseID {
                    School.selectedSchoolDatabaseID = school.databaseID
                    School.selectedSchool = school
                    self.performSegue(withIdentifier: "showSchoolPosts", sender: self)
                }
                
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
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showSchoolPosts") {
            //(segue.destination as! NewsViewController).schoolDatabaseID = self.selectedSchoolDatabaseID
        }
    }
    
}
