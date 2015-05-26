//
//  Poster.swift
//  Bridge
//
//  Created by 许Bill on 15-2-24.
//  Copyright (c) 2015年 Fudan.SS. All rights reserved.
//

import Foundation
import Parse
class Poster: PFObject,PFSubclassing {
    //Attribute of a certain class
    var content:String = ""
    var relatedActivity:Activity
    var image:PFFile?
    var title:String = ""
    override init(){
        self.relatedActivity = Activity()
        super.init()
        
    }
    //The methods to subclass a instance
    init(newPFObject:PFObject){
        self.title = newPFObject["title"] as String
        self.image = newPFObject["image"] as PFFile?
        self.content = newPFObject["content"] as String
        self.relatedActivity = newPFObject["relatedActivity"] as Activity
        super.init()
    }
    override init!(className newClassName: String!) {
        self.relatedActivity = Activity()
        super.init(className: newClassName)
    }
    
    //The method to implement the parent Class's function
    //Don't modify
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
        return "Poster"
    }
}