//
//  NewsViewController.swift
//  ClassR
//
//  Created by Evan Shrestha on 11/8/18.
//  Copyright © 2018 Evan Shrestha. All rights reserved.
//

import UIKit

class NewsViewController: UITableViewController {
    @IBOutlet weak var newsTableView: NewsTableView!
    
    var testCourse : Course?
    var testStatus : Status?
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsCell") as! NewsTableViewCell
        cell.classNameLabel.text = testStatus!.course.courseName
        cell.newsTextLabel.text = testStatus!.statusText
        cell.status = testStatus!
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(200);
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        testCourse = Course(courseName: "Jazz Appreciation", courseDepartment: "MUS", courseNumber: "307", courseInstructor: "Jeff Hellmer", courseID: "2312", coursePeriod: "Fall 2018")
        testStatus = Status(course: testCourse!, statusText: "ASDF")

        // Do any additional setup after loading the view.
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
