//
//  CommentViewController.swift
//  ClassR
//
//  Created by Evan Shrestha on 11/9/18.
//  Copyright © 2018 Evan Shrestha. All rights reserved.
//

import UIKit

class CommentViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var status : Status?
    var course : Course?
    
    @IBOutlet weak var commentTableView: CommentTableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let emptyLabel = UILabel()
        emptyLabel.text = "Nothing seems to be here yet"
        emptyLabel.textColor = UIColor.white
        emptyLabel.font = UIFont(name: "Open Sans", size: CGFloat(17))
        emptyLabel.textAlignment = NSTextAlignment.center
        if Comment.comments.count == 0 {
            self.commentTableView.backgroundView = emptyLabel
        } else {
            self.commentTableView.backgroundView = nil
        }
        return Comment.comments.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.row == 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "commentHeaderCell") as! CommentHeaderTableViewCell
            
            cell.headerTextLabel.text = status?.statusText
            cell.classNameLabel.text = course?.courseName
            cell.headerView.layer.cornerRadius = CGFloat(10)
            
            // Transfer status to cell
            cell.status = status!
            cell.updateLikeStatus()
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell") as! CommentTableViewCell
            let currentComment = Comment.comments[indexPath.row - 1]
            cell.commentView.layer.cornerRadius = CGFloat(10)
            cell.commentNameLabel.text = currentComment?.creatorNickname
            cell.commentTextLabel.text = currentComment?.text
            
            return cell
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commentTableView.delegate = self
        commentTableView.dataSource = self
        commentTableView.rowHeight = UITableView.automaticDimension
        commentTableView.estimatedRowHeight = 130
        
        reloadComments()
    }
    
    func reloadComments() {
        Comment.loadComments(selectedStatus: status!, onLoadedComment: {
            self.commentTableView.reloadData()
        })
        self.commentTableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "createCommentSegue") {
            if let destination = segue.destination as? CreateCommentViewController {
                destination.selectedStatus = self.status
                destination.commentViewController = self
            }
        }
    }
    
}
