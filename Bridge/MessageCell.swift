//
//  MessageCell.swift
//  Attributor
//
//  Created by 许Bill on 15-2-9.
//  Copyright (c) 2015年 Fudan.SS. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {
    @IBOutlet var imageIcon: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var contentLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    
    //    override init(){
    //        super.init()
    //        self.nameLabel.text = "Name";
    //        self.contentLabel.text = ""
    //        self.timeLabel.text = "Now"
    //
    //    }
    
    //    required init(coder aDecoder: NSCoder) {
    //        fatalError("init(coder:) has not been implemented")
    //    }
    override func awakeFromNib() {
        super.awakeFromNib()
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
    
}
