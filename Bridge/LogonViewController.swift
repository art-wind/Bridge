//
//  LogonViewController.swift
//  Bridge
//
//  Created by 许Bill on 15-2-18.
//  Copyright (c) 2015年 Fudan.SS. All rights reserved.
//

import UIKit

class LogonViewController: UIViewController{

    @IBOutlet var logonActivityIndicator: UIActivityIndicatorView!
    @IBOutlet var logonButton: UIButton!
    @IBOutlet var imageIcon: UIImageView!
    @IBOutlet var username: UITextField!
    @IBOutlet var password: UITextField!
    var readyToSegue = false
    
    var isPrepared = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        roundRect(logonButton,radius: 5)
        roundRect(imageIcon, radius: 12)
        let animator = UIDynamicAnimator(referenceView: logonButton)
        let behavour = UIDynamicBehavior()
//        scroll.setNeedsDisplayInRect(self)
        // Do any additional setup after loading the view.
    }

    func roundRect(view:UIView,radius:CGFloat){
        view.layer.cornerRadius = radius
        view.layer.masksToBounds = true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        if identifier == "Logon" {
            if self.isPrepared {
                return true
            }
            else{
                return false
            }
        }
        else{
            return super.shouldPerformSegueWithIdentifier(identifier, sender: sender)
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }
    @IBAction func logonAction(sender: UIButton) {
        weak var weakSelf = self
        logonActivityIndicator.startAnimating()
        PFUser.logInWithUsernameInBackground(username.text, password: password.text) { (User, error) -> Void in
            if User != nil {
                let installation = PFInstallation.currentInstallation()
                installation["currentUser"] = PFUser.currentUser()
                installation.saveInBackground()
                
                
//                self.initializeTheDialog()
                
                
                weakSelf?.isPrepared = true
                weakSelf?.performSegueWithIdentifier("Logon", sender: sender)
                weakSelf?.logonActivityIndicator.stopAnimating()
            }
        }
    }
    func initializeTheDialog(){
        var objects = [PFObject]()
        let query = PFUser.query()
        query.addAscendingOrder("username")
        query.findObjectsInBackgroundWithBlock { (results, error) -> Void in
            var ind = 0
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
            dialogToSave.pin(nil)
            
            var m = PFObject(className: "Message")
            m["source"] = PFUser.currentUser()
            m["content"] = "Hello 0 "
            m["dialogID"] = dialogToSave
            m["sendDate"] = NSDate()
//            m.saveInBackgroundWithBlock({(success, error) -> Void in
//                
//            })
            m.pinInBackgroundWithBlock({ (s, e) -> Void in
                if s {
                    println("M1 s")
                }
            })
            var m2 = PFObject(className: "Message")
            m2["source"] = PFUser.currentUser()
            m2["content"] = "Hello 1 "
            m2["dialogID"] = dialogToSave
            m2["sendDate"] = NSDate()
//            m2.saveInBackgroundWithBlock({(success, error) -> Void in
//                
//            })
            m2.pinInBackgroundWithBlock({ (s, e) -> Void in
                if s {
                    println("M2 s")
                }
            })
        }

    }
    

}
