//
//  User.swift
//  Bridge
//
//  Created by 许Bill on 15-2-25.
//  Copyright (c) 2015年 Fudan.SS. All rights reserved.
//

import Foundation
class User: PFUser,PFSubclassing {
    //Attribute of a certain class
    var imageIcon:PFFile?
    var nickname:String?
    var ID:String?
    var vector:[Double] = [Double]()
    var tags:[String]?
    override init(){
        super.init()
        
    }
    //The methods to subclass a instance
    init(newPFUser:PFUser){
        let targetUser = newPFUser.fetchIfNeeded() as PFUser
        self.nickname = targetUser["nickname"] as String?
        self.ID = newPFUser.objectId
        println(self.nickname)
        if let im = targetUser["icon"] as? PFFile {
            self.imageIcon = im
        }
        else{
            
        }
        self.vector = targetUser["vector"] as [Double]
        self.tags = targetUser["tags"] as? [String]
        super.init()
    }
    init(newPFObject:PFObject){
        let targetUser = newPFObject.fetchIfNeeded() as PFObject
        self.nickname = targetUser["nickname"] as String?
        self.ID = newPFObject.objectId
        if let im = targetUser["icon"] as? PFFile {
            self.imageIcon = im
        }
        else{
            
        }
        self.vector = targetUser["vector"] as [Double]
        self.tags = targetUser["tags"] as? [String]
        super.init()
    }
    override init!(className newClassName: String!) {
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
    
    override class func parseClassName() -> String! {
        return "User"
    }
}