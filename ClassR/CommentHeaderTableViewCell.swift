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
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
