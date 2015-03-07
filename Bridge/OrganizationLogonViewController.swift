//
//  OrganizationLogonViewController.swift
//  Bridge
//
//  Created by 许Bill on 15-2-18.
//  Copyright (c) 2015年 Fudan.SS. All rights reserved.
//

import UIKit

class OrganizationLogonViewController: UIViewController {

    @IBOutlet var imageIcon: UIImageView!
    @IBOutlet var logonButton: UIButton!
    @IBOutlet var username: UITextField!
    @IBOutlet var password: UITextField!
    var isPrepared = false
    @IBAction func getBack() {
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            
        })
    }
    
    @IBAction func logonAction(sender: UIButton) {
        weak var weakSelf = self
        PFUser.logInWithUsernameInBackground(username.text, password: password.text) { (User, error) -> Void in
            if User != nil {
                self.isPrepared = true
                weakSelf?.performSegueWithIdentifier("Logon", sender: sender)
            }
        }
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

}
