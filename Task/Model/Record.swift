//
//  Record.swift
//  Task
//
//  Created by Yuwen Chiu on 2019/10/22.
//  Copyright © 2019 YuwenChiu. All rights reserved.
//

import Foundation

class Record {
    
    var eiType: Int
    var image: String
    var money: Int
    var date: String
    var method: String
    var category: String
    var remarks: String
    var location: String
    
    init(eiType: Int, image: String, money: Int, date: String, method: String, category: String, remarks: String, location: String) {
        
        self.eiType = eiType
        self.image = image
        self.money = money
        self.date = date
        self.method = method
        self.category = category
        self.remarks = remarks
        self.location = location
    }
    
    convenience init() {
        
        self.init(eiType: 0, image: "", money: 0, date: "", method: "", category: "", remarks: "", location: "")
    }
}
