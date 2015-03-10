//
//  HomePageViewController.swift
//  Bridge
//
//  Created by 许Bill on 15-3-8.
//  Copyright (c) 2015年 Fudan.SS. All rights reserved.
//

import UIKit

class HomePageViewController: UIViewController {

    @IBOutlet var iconImageView: UIImageView!
    @IBOutlet var nicknameLabel: UILabel!
    @IBOutlet var tagsLabel: UILabel!
    override func viewDidLoad() {
        let user = User(newPFUser:PFUser.currentUser())
        
        self.iconImageView.image = UIImage(named: "defaultIcon")
        let imgFile = user.imageIcon as PFFile?
        imgFile?.getDataInBackgroundWithBlock({ (data, error) -> Void in
            if error != nil {
                println("No picture Found")
            }
            else{
                self.iconImageView.image = UIImage(data: data)
            }
        })
        self.nicknameLabel.text = user.nickname
        
        let tags = user.tags!
        var tagsToShown = ""
        for tag in tags {
            tagsToShown += " "+tag
        }
        self.tagsLabel.text = tagsToShown
        
    }
    @IBAction func logoutAction(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            let install = PFInstallation.currentInstallation()
            install.removeObjectForKey("currentUser")
        })
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Embed Experience Segue" {
            let expTVC = segue.destinationViewController as ExperienceTableVC
            expTVC.relatedUser = User(newPFUser: PFUser.currentUser())
        }
    }
}
