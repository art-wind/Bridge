//
//  Message.swift
//  Attributor
//
//  Created by 许Bill on 15-2-9.
//  Copyright (c) 2015年 Fudan.SS. All rights reserved.
//

import Foundation

class Message:NSObject{
    
    var name:String = "";
    var time:String?;
    var displayContent:String?;
    
    override init(){
        super.init()
        self.name = ""
        self.time = nil
        self.displayContent = nil
    }
    func setAttributes(messenger inName:String,sendingTime time:String?,message content:String?){
        
        self.name = inName
        self.time = time
        self.displayContent = content
        
    }
    
    
}