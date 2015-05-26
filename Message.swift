//
//  Message.swift
//  Attributor
//
//  Created by 许Bill on 15-2-9.
//  Copyright (c) 2015年 Fudan.SS. All rights reserved.
//

import Foundation
class Message: PFObject,PFSubclassing {
    //Attribute of a certain class
    var content:String = "Default"
    var ID:String = ""
    var source:PFUser?
    var sendDate:NSDate?
    init(newPFObject:PFObject){
        self.ID = ""
        
//        var dialogID:PFObject?
//        let object = newPFObject["dialogID"] as PFObject
//        self.dialogID = Dialog(newPFObject: object)
        self.content = newPFObject["content"] as String
        self.source = newPFObject["source"] as? PFUser
        self.sendDate = newPFObject["sendDate"] as? NSDate
        super.init()
    }
    override init!(className newClassName: String!) {
        
        super.init(className: newClassName)
    }
    
    //The method to implement the parent Class's function
    //Don't modify
    override init(){
        super.init()
    }
    override class func initialize() {
        var onceToken : dispatch_once_t = 0;
        dispatch_once(&onceToken) {
            self.registerSubclass()
        }
    }
    override class func load() {
        superclass()?.load()
        self.registerSubclass()
    }
    
    class func parseClassName() -> String! {
        return "Message"
    }
}