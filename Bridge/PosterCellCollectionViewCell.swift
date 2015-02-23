//
//  PosterCellCollectionViewCell.swift
//  Bridge
//
//  Created by 许Bill on 15-2-18.
//  Copyright (c) 2015年 Fudan.SS. All rights reserved.
//

import UIKit

class PosterCellCollectionViewCell: UICollectionViewCell {

    @IBOutlet var poster: UIImageView!
    var isInDeletingMode = false
    var subDeletingView : UIView?
    override func awakeFromNib() {
        //Create borer radius 
        poster.layer.cornerRadius = 10
        poster.layer.masksToBounds = true
        let contentViewIsAutoresized:Bool = CGSizeEqualToSize(self.frame.size, self.contentView.frame.size);
        
        if( !contentViewIsAutoresized) {
//            let contentViewFrame = self.contentView.frame
//            contentViewFrame.size = self.frame.size
            self.contentView.frame = self.frame
        }
        
        
        self.frame = self.bounds
        self.contentView.frame = self.frame
        self.contentView.autoresizingMask = UIViewAutoresizing.FlexibleHeight | UIViewAutoresizing.FlexibleWidth
    }
    
    @IBAction func addOne(sender: UITapGestureRecognizer) {
        if isInDeletingMode == false {
            isInDeletingMode == true
            subDeletingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 15))
            subDeletingView?.backgroundColor = UIColor.brownColor()
            self.poster.addSubview(subDeletingView!)
        }
        else{
            subDeletingView?.removeFromSuperview()
        }
    }
}
