//
//  OuterExperienceTVCell.swift
//  Bridge
//
//  Created by 许Bill on 15-3-7.
//  Copyright (c) 2015年 Fudan.SS. All rights reserved.
//

import UIKit

class OuterExperienceTVCell: UITableViewCell {

    @IBOutlet var userIcon: UIImageView!
    @IBOutlet var nicknameLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var bodyTextView: UITextView!
    @IBOutlet var timeLabel: UILabel!
    func setTime(date:NSDate){
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM/dd HH:mm"
        let timeString = dateFormatter.stringFromDate(date)
        self.timeLabel.text = timeString
    }
}
