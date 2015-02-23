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

    @IBAction func getBack() {
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            
        })
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
