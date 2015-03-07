//
//  Activity.swift
//  Bridge
//
//  Created by 许Bill on 15-2-24.
//  Copyright (c) 2015年 Fudan.SS. All rights reserved.
//

import Foundation
import Parse
class Activity: PFObject,PFSubclassing {
    //Attribute of a certain class
    var activityName:String = ""
    var startDate:NSDate = NSDate()
    var activityDescription:String = ""
    var activityPlace:String?
    
    var duration:NSDate?
    var frequency:String?
    var icon:PFFile?
    var image:UIImage?
    var ID:String = ""
    var tags:[String]?
    var vector:[Double]?
    //The methods to subclass a instance
    init(newPFObject:PFObject){
        newPFObject.fetchIfNeeded()
        self.ID = newPFObject.objectId
        self.activityName = newPFObject["name"] as String
        self.startDate = newPFObject["startDate"] as NSDate
        if let optionalDes = newPFObject["description"] as? String {
            self.activityDescription = optionalDes
        }
        self.frequency = newPFObject["frequency"] as String?
        self.icon = newPFObject["icon"] as PFFile?
        self.duration = newPFObject["duration"] as NSDate?
        self.activityPlace = newPFObject["place"] as String?
        self.tags = newPFObject["tags"] as? [String]
        self.vector = newPFObject["vector"] as? [Double]
        println("Vec \(self.vector)")
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
        return "Activity"
    }
}