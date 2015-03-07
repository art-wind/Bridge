//
//  ExperienceTViewCell.swift
//  Bridge
//
//  Created by 许Bill on 15-3-3.
//  Copyright (c) 2015年 Fudan.SS. All rights reserved.
//

import UIKit

class ExperienceTViewCell: UITableViewCell {
    @IBOutlet var activityIcon: UIImageView!
    @IBOutlet var voteButton: UIButton!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var bodyLabel: UITextView!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var activityNameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
