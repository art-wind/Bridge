//
//  LogoffOrganizationViewController.swift
//  Bridge
//
//  Created by 许Bill on 15-3-10.
//  Copyright (c) 2015年 Fudan.SS. All rights reserved.
//

import UIKit

class LogoffOrganizationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logoutAction(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            var install = PFInstallation.currentInstallation()
            install.removeObjectForKey("currentUser")
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
