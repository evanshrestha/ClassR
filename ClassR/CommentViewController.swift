//
//  CommentViewController.swift
//  ClassR
//
//  Created by Evan Shrestha on 11/9/18.
//  Copyright © 2018 Evan Shrestha. All rights reserved.
//

import UIKit

class CommentViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var commentTableView: CommentTableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.row == 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "commentHeaderCell") as! CommentHeaderTableViewCell
            cell.headerView.layer.cornerRadius = CGFloat(10)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell") as! CommentTableViewCell
            cell.commentView.layer.cornerRadius = CGFloat(10)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.row == 0) {
            return CGFloat(130)
        }
        return CGFloat(100)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        commentTableView.delegate = self
        commentTableView.dataSource = self

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
