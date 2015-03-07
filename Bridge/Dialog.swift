//
//  Dialog.swift
//  Bridge
//
//  Created by 许Bill on 15-3-1.
//  Copyright (c) 2015年 Fudan.SS. All rights reserved.
//

import Foundation
class Dialog: PFObject,PFSubclassing {
    //Attribute of a certain class
    var participants:[PFUser] = [PFUser]()
    var lastMessageContent:String?
    var lastMessageTime:NSDate?
    var ID:String = ""
    init(newPFObject:PFObject){
        if let id = newPFObject.objectId {
            
            self.ID = id
        }
        self.participants = newPFObject["participants"] as [PFUser]
        self.lastMessageContent = newPFObject["lastMessageContent"] as? String
        self.lastMessageTime = newPFObject["lastMessageTime"] as? NSDate
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
        return "Dialog"
    }
}