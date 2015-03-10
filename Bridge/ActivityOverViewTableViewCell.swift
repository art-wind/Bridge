//
//  ActivityOverViewTableViewCell.swift
//  Bridge
//
//  Created by 许Bill on 15-2-24.
//  Copyright (c) 2015年 Fudan.SS. All rights reserved.
//

import UIKit

class ActivityOverViewTableViewCell: UITableViewCell {

    
    @IBOutlet var activityNameLabel: UILabel!
    @IBOutlet var activityDescriptionLabel: UILabel!
    @IBOutlet var activityIcon: UIImageView!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var activityPlaceLabel: UILabel!
    @IBOutlet var oraganizationLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setTime(date:NSDate){
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM/dd HH:mm"
        let timeString = dateFormatter.stringFromDate(date)
        self.timeLabel.text = timeString
    }
    
}
