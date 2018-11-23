//
//  School.swift
//  ClassR
//
//  Created by Evan Shrestha on 11/12/18.
//  Copyright © 2018 Evan Shrestha. All rights reserved.
//

import Foundation


class School {
    
    static var selectedSchoolDatabaseID = ""
    
    var databaseID = ""
    var name = ""
    var nickname = ""
    
    init (databaseID: String, name: String, nickname: String) {
        self.databaseID = databaseID
        self.name = name
        self.nickname = nickname
    }
}
