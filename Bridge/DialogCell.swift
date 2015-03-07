//
//  MessageCell.swift
//  Bridge
//
//  Created by 许Bill on 15-2-19.
//  Copyright (c) 2015年 Fudan.SS. All rights reserved.
//

import UIKit

class DialogCell: UITableViewCell {
   
    @IBOutlet var iconImageView: UIImageView!
    @IBOutlet var messageBackgroundView: UIImageView!
    @IBOutlet var messageContentTextView: UITextView!
    var maximumSize:CGSize = CGSize(width: 150, height: 1000)
    let padding:CGFloat = 20
    var exactSize:CGSize = CGSize(width: 0, height: 0)
    let magicNumber:CGFloat = 50
    let paddingInset:CGFloat = 5
    func deInitialize() {
        iconImageView?.removeFromSuperview()
        messageBackgroundView?.removeFromSuperview()
        messageContentTextView?.removeFromSuperview()
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }
    

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setViews(cellWidth:CGFloat,icon:UIImage,messageContent:String,backgroungImage:UIImage,isLeft:Bool){
        maximumSize.width = cellWidth*0.5
        iconImageView = UIImageView()
        messageContentTextView = UITextView()
        messageBackgroundView = UIImageView()
        iconImageView.layer.cornerRadius = magicNumber / 8
        iconImageView.layer.masksToBounds = true
        
        
        
        //If left
        self.iconImageView.image = icon
        self.iconImageView.frame.size = CGSize(width: magicNumber, height: magicNumber)
        
        
        messageContentTextView.text = messageContent
        messageContentTextView.font = UIFont.systemFontOfSize(18)
        
        exactSize = messageContentTextView.sizeThatFits(maximumSize)
        self.messageContentTextView.allowsEditingTextAttributes = false
        self.messageContentTextView.backgroundColor = UIColor.clearColor()
        self.messageContentTextView.editable = false
        self.messageContentTextView.selectable = false
        
        
        var new_image = backgroungImage.resizableImageWithCapInsets(UIEdgeInsets(top: 30, left: 30, bottom: 15, right: 30), resizingMode: UIImageResizingMode.Stretch)
        messageBackgroundView.image = new_image
       
        if isLeft == true {
            self.iconImageView.frame.origin.x = padding
            self.iconImageView.frame.origin.y = padding
                        self.messageContentTextView.frame = CGRect(origin: CGPoint(x: 3 * padding + magicNumber, y: padding),
                size: exactSize)
            self.messageContentTextView.frame = CGRect(origin: CGPoint(x: 3*padding + magicNumber, y: padding),size: exactSize)
            
            exactSize.width += 1.5 * padding
            exactSize.height += padding
            self.messageBackgroundView.frame = CGRect(origin: CGPoint(x: 2 * padding + magicNumber, y:padding/2),
                size: exactSize)
        }
       
        else{
            let endX = self.frame.width
            println("EndX \(endX)")
            self.iconImageView.frame.origin.x = endX - padding - magicNumber
            self.iconImageView.frame.origin.y = padding
            self.messageContentTextView.frame = CGRect(origin: CGPoint(x: endX-(3*padding + magicNumber+exactSize.width), y: padding),
                size: exactSize)
            
            exactSize.width += 1.5 * padding
            exactSize.height += padding
            self.messageBackgroundView.frame = CGRect(origin: CGPoint(x: endX-(2*padding + magicNumber+exactSize.width), y:padding/2),
                size: exactSize)
        }
        
        //if Right 
        
        
        self.layer.opacity = 0.3
        self.addSubview(iconImageView)
        self.addSubview(messageBackgroundView)
        self.addSubview(messageContentTextView)
//        self.addSubview(uiview)
    }
    func getCellSize()->CGSize {
        var width = exactSize.width + 3*padding
        var height = exactSize.height + 2*padding
        return CGSize(width: width, height: height)
    }
    class func getHeight(inputString:NSString,cellWidth:CGFloat)->CGFloat {
       var textView:UITextView = UITextView()
       textView.text = inputString
       textView.font = UIFont.systemFontOfSize(18)
//        print("\(self.e)")
       return max(textView.sizeThatFits(CGSize(width: cellWidth*0.5, height: 1000)).height + 40 ,70)
    }
    
    
}
