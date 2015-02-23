//
//  DateTextField.swift
//  Bridge
//
//  Created by 许Bill on 15-2-22.
//  Copyright (c) 2015年 Fudan.SS. All rights reserved.
//

import UIKit

class DateTextField: UITextField {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

    override func caretRectForPosition(position: UITextPosition!) -> CGRect {
        return CGRectZero
    }

}
