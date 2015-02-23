//
//  DialogViewController.swift
//  Bridge
//
//  Created by 许Bill on 15-2-23.
//  Copyright (c) 2015年 Fudan.SS. All rights reserved.
//

import UIKit

class DialogViewController: UIViewController {

    @IBOutlet var dialogHistoryContainer: UIView!
    @IBOutlet var messageToBeSent: UITextField!
    @IBAction func sendMessage(sender: UIButton) {
        var vc = dialogHistoryContainer 
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
