//
//  Person.swift
//  Attributor
//
//  Created by 许Bill on 15-2-10.
//  Copyright (c) 2015年 Fudan.SS. All rights reserved.
//

import Foundation
class Person{
    var personName:String = "";
    var sortedString:String = "";
    var gender:String="";
    var imageIcon:String = "";
    var registerTime:NSDate;
    
    init(personName:String,sortedString:String,gender:String,imageIcon:String,registerTime:NSDate){
        self.personName = personName
        self.sortedString = sortedString
        self.gender = gender
        self.imageIcon = imageIcon
        self.registerTime = registerTime
    }
}