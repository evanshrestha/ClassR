//
//  CourseSearchTableViewCell.swift
//  ClassR
//
//  Created by Evan Shrestha on 11/16/18.
//  Copyright © 2018 Evan Shrestha. All rights reserved.
//

import UIKit

class CourseSearchTableViewCell: UITableViewCell {
    @IBOutlet weak var courseNameLabel: UILabel!
    @IBOutlet weak var courseDepartmentNumberLabel: UILabel!
    @IBOutlet weak var courseInstructorLabel: UILabel!
    @IBOutlet weak var coursePeriodLabel: UILabel!
    @IBOutlet weak var courseIDLabel: UILabel!
    @IBOutlet weak var coursePostsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
