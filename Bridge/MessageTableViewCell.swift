//
//  MessageTableViewCell.swift
//  Attributor
//
//  Created by 许Bill on 15-2-9.
//  Copyright (c) 2015年 Fudan.SS. All rights reserved.
//

import UIKit
class MessageTableViewCell: UITableViewCell {
    @IBOutlet var imageIcon: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var contentLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    
    @IBOutlet var badgeIcon: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        let height = self.badgeIcon.bounds.height
        self.badgeIcon.layer.cornerRadius = height/2
        self.badgeIcon.layer.masksToBounds = true
        self.badgeIcon.hidden = true
        // Initialization code
    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setMessageTableViewCell(name:String,content:String?,time:String?){
        self.nameLabel.text = name;
        if let tmp:String = content {
             self.contentLabel.text = tmp
        }
        if let tmpTime:String = time {
            self.timeLabel.text = tmpTime
        }
    }
    func setBadgeValue(number:Int){
        if number > 0
        {
            self.badgeIcon.text = "\(number)"
            self.badgeIcon.hidden = false
        }
        else{
            self.badgeIcon.hidden = true
        }
        
    }
    func setImageIcon(url:NSString){
        self.imageIcon.image = UIImage(named: url)
        self.imageIcon.layer.cornerRadius = 8
        self.imageIcon.layer.masksToBounds = true
        
        
    }

}
