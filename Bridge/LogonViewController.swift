//
//  LogonViewController.swift
//  Bridge
//
//  Created by 许Bill on 15-2-18.
//  Copyright (c) 2015年 Fudan.SS. All rights reserved.
//

import UIKit

class LogonViewController: UIViewController{

    @IBOutlet var logonButton: UIButton!
    @IBOutlet var imageIcon: UIImageView!
    @IBOutlet var username: UITextField!
    @IBOutlet var password: UITextField!
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
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        self.imageIcon = nil
        self.logonButton = nil
    }
    

}
