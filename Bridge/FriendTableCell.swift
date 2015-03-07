//
//  FriendTableCell.swift
//  Attributor
//
//  Created by 许Bill on 15-2-10.
//  Copyright (c) 2015年 Fudan.SS. All rights reserved.
//

import UIKit

class FriendTableCell: UITableViewCell {

    @IBOutlet var imageIcon: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
//        imageIcon.image = UIImage(named: "default")
//        nameLabel.text = "Default"
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
