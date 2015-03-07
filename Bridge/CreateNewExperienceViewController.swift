//
//  CreateNewExperienceViewController.swift
//  Bridge
//
//  Created by 许Bill on 15-3-5.
//  Copyright (c) 2015年 Fudan.SS. All rights reserved.
//

import UIKit

class CreateNewExperienceViewController: UIViewController {

    @IBOutlet var spinner: UIActivityIndicatorView!
    @IBOutlet var titleLabel: UITextField!
    @IBOutlet var bodyTextView: UITextView!
    var relatedActivity:Activity?
    override func viewDidLoad() {
        super.viewDidLoad()
//        var saveButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Save, target: self, action: Selector("saveExperience:"))
        var saveButton = UIBarButtonItem(title: "提交", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("saveExperience:"))
        self.navigationItem.rightBarButtonItem = saveButton
        println(self.relatedActivity?.ID)
        // Do any additional setup after loading the view.
    }
    func saveExperience(sender:UIBarButtonItem!){
        self.spinner.startAnimating()
        let title = titleLabel.text
        let body = bodyTextView.text
        let experience = PFObject(className: "Experience")
        experience["title"] = title
        experience["body"] = body
        experience["sendDate"] = NSDate()
        experience["voted"] = 0
        experience["uploadedBy"] = PFUser.currentUser()
        experience["relatedActivity"] = PFObject(withoutDataWithClassName: "Activity", objectId: relatedActivity!.ID)
        experience.saveInBackgroundWithBlock { (ok, error) -> Void in
            if ok {
                self.spinner.stopAnimating()
                self.navigationController?.popViewControllerAnimated(true)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
