//
//  CommentHeaderTableViewCell.swift
//  ClassR
//
//  Created by Evan Shrestha on 11/9/18.
//  Copyright © 2018 Evan Shrestha. All rights reserved.
//

import UIKit

class CommentHeaderTableViewCell: UITableViewCell {
    @IBOutlet weak var classNameLabel: UILabel!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerTextLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    
    var status : Status?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func onLike(_ sender: Any) {
        status?.onLike()
        updateLikeStatus()
    }
    
    func updateLikeStatus() {
        if (status!.liked) {
            likeButton.setTitle("Liked", for: .normal)
            likeButton.setTitleColor(UIColor(hexString: "#00A8E8"), for: .normal)
        } else {
            likeButton.setTitle("Like", for: .normal)
            likeButton.setTitleColor(UIColor(hexString: "#6F7179"), for: .normal)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
