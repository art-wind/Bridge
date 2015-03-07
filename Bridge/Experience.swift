//
//  Experience.swift
//  Bridge
//
//  Created by 许Bill on 15-3-3.
//  Copyright (c) 2015年 Fudan.SS. All rights reserved.
//

import Foundation
class Experience: PFObject,PFSubclassing {
    //Attribute of a certain class
    var voted:Int = 0
    var ID:String = ""
    var title:String?
    var body:String?
    var relatedActivity:Activity?
    var sendDate:NSDate?
    
    init(newPFObject:PFObject){
        self.ID = newPFObject.objectId
        self.title = newPFObject["title"] as? String
        self.body = newPFObject["body"] as? String
        self.sendDate = newPFObject["sendDate"] as? NSDate
        self.voted = newPFObject["voted"] as Int
        let act = newPFObject["relatedActivity"] as? PFObject
        if let fetchedAct = act?.fetchIfNeeded(){
            self.relatedActivity = Activity(newPFObject: fetchedAct)
        }
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
        return "Experience"
    }
}