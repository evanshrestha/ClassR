//
//  NewsTableViewCell.swift
//  ClassR
//
//  Created by Evan Shrestha on 11/8/18.
//  Copyright © 2018 Evan Shrestha. All rights reserved.
//

import UIKit

class NewsTableViewCell: UITableViewCell {

    @IBOutlet weak var classNameLabel: UILabel!
    @IBOutlet weak var newsTextLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func onLikeTap(_ sender: Any) {
    }
    @IBAction func onCommentsTap(_ sender: Any) {
    }
    
}
