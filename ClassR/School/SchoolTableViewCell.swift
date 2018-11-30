//
//  SchoolTableViewCell.swift
//  ClassR
//
//  Created by Evan Shrestha on 11/12/18.
//  Copyright © 2018 Evan Shrestha. All rights reserved.
//

import UIKit

class SchoolTableViewCell: UITableViewCell {
    
    var schoolDatabaseID = ""
    
    @IBOutlet weak var schoolNameLabel: UILabel!
    
    @IBOutlet weak var schoolNicknameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
