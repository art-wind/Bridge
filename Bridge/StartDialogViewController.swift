//
//  StartDialogViewController.swift
//  Bridge
//
//  Created by 许Bill on 15-2-27.
//  Copyright (c) 2015年 Fudan.SS. All rights reserved.
//

import UIKit

class StartDialogViewController: UIViewController {
    var sharedInstance:PFObject?
    @IBAction func fetchDialogs(sender: UIButton) {
        let dialogQuery = PFQuery(className: "Dialog")
        let arr = [sharedInstance!]
        dialogQuery.fromPin()
        dialogQuery.whereKey("participants", containsAllObjectsInArray:  arr)
        dialogQuery.getFirstObjectInBackgroundWithBlock { (dialog, error) -> Void in
            if error == nil {
                let messagesQuery = PFQuery(className: "Message")
                messagesQuery.whereKey("DialogID", equalTo: dialog as PFObject)
                messagesQuery.fromPin()
                messagesQuery.findObjectsInBackgroundWithBlock({ (messages, error) -> Void in
                    for m in messages{
                        println((m as PFObject)["MessageContent"])
                    }
                })
            }
        }
    }
    @IBAction func createDialog(sender: UIButton) {
        var objects = [PFObject]()
        let query = PFUser.query()
        query.findObjectsInBackgroundWithBlock { (results, error) -> Void in
            var ind = 0
            self.sharedInstance = results[0] as? PFObject
            for r in results{
            
                let u = r as PFUser
                objects.append(u)
                ind++
                if ind==2{
                    break
                }
            }
            var dialogToSave = PFObject(className: "Dialog")
            dialogToSave["participants"] = objects
            dialogToSave.saveInBackgroundWithBlock({ (success, error) -> Void in
                if error == nil {
                    println("success")
                }
                else {
                    println("Bad")
                }
            })
        }
       
    }
    @IBAction func checkAvailable(sender: UIButton) {
        var objects = [PFObject]()
        let query = PFUser.query()
        query.findObjectsInBackgroundWithBlock { (results, error) -> Void in
            var ind = 0
            self.sharedInstance = results[0] as? PFObject
            for r in results{
                let u = r as PFUser
                objects.append(u)
                ind++
                if ind==2{
                    break
                }
            }
            var dialogQuery = PFQuery(className: "Dialog")
            dialogQuery.whereKey("participants", containsAllObjectsInArray: objects)
            dialogQuery.findObjectsInBackgroundWithBlock({ (results, error) -> Void in
                if error == nil{
                    var objs = [PFObject]()
                    for r in results {
                        objs.append(r as PFObject)
                    }
                    if objs.count == 0 {
                        var dialog = PFObject(className: "Dialog")
                        dialog["participants"] = objects
                        var message = PFObject(className: "Message")
                        message["DialogID"] = dialog
                        message["MessageContent"] = "testCreation"
                        message["Sourcer"] = objects[0]
                        
                        message.saveInBackgroundWithBlock({ (success, error) -> Void in
                            if success {
                                println("Successfully establish a message")
                                var pushTargetQuery :PFQuery = PFInstallation.query()
                                pushTargetQuery.whereKey("currentUser", containedIn: objects)
                                
                                let push = PFPush()
                                push.setQuery(pushTargetQuery) // Set our Installation query
                                push.setMessage("You got a message from Source")

                                push.sendPushInBackground()
                            }
                        })
                        message.pinInBackground()
                        println("BackGround")
                        println("ad")
                    }
                }
            })
        }

        
        
    }
}
