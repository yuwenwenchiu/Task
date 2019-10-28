//
//  RecentAccountingTableViewCell.swift
//  Task
//
//  Created by Yuwen Chiu on 2019/10/8.
//  Copyright © 2019 YuwenChiu. All rights reserved.
//

import UIKit

class RecentAccountingTableViewCell: UITableViewCell {
    
    @IBOutlet weak var recordImage: UIImageView!
    @IBOutlet weak var recordCategory: UILabel!
    @IBOutlet weak var recordRemarks: UILabel!
    @IBOutlet weak var recordLocation: UILabel!
    @IBOutlet weak var recordMethod: UILabel!
    @IBOutlet weak var recordMoney: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
