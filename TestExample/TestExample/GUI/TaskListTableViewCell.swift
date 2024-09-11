//
//  ComputerTableViewCell.swift
//  WakeUpOnLan
//
//  Created by Nguyễn Tất Hùng on 5/10/16.
//  Copyright © 2016 Nguyễn Tất Hùng. All rights reserved.
//

import UIKit

class TaskListTableViewCell: UITableViewCell {
    @IBOutlet weak var taskImage: UIImageView!
    @IBOutlet weak var taskDescript: UILabel!
    @IBOutlet weak var taskName: UILabel!
    @IBOutlet weak var time: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
