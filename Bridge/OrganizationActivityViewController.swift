//
//  OrganizationActivityViewController.swift
//  Bridge
//
//  Created by 许Bill on 15-3-4.
//  Copyright (c) 2015年 Fudan.SS. All rights reserved.
//

import UIKit
import Parse
class OrganizationActivityViewController: UIViewController {
    @IBOutlet var activityNameLabel: UILabel!
    @IBOutlet var activityTimeLabel: UILabel!
    @IBOutlet var activityPlaceLabel: UILabel!
    @IBOutlet var iconImageView: UIImageView!
    @IBOutlet var tagsLabel: UILabel!
    var shareViewShown:Bool?
    var activityToBeDisplay:Activity?
    var image:UIImage?
    
    @IBOutlet var descriptionLabel: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let im = activityToBeDisplay?.icon
        
        println(self.activityToBeDisplay)
        
        self.activityNameLabel.text = activityToBeDisplay?.activityName
        
        var formatter = NSDateFormatter()
        formatter.dateFormat = "MM/dd HH:mm"
        self.activityTimeLabel.text = formatter.stringFromDate(activityToBeDisplay!.startDate)
        
        self.activityPlaceLabel.text = activityToBeDisplay?.activityPlace
        im?.getDataInBackgroundWithBlock({ (result, error) -> Void in
            self.iconImageView.image = UIImage(data: result)
            self.image = UIImage(data: result)
        })
        var tagsToBeShown = ""
        for i in self.activityToBeDisplay!.tags! {
            tagsToBeShown += " \(i)"
        }
        self.tagsLabel.text = tagsToBeShown

        
        
        
        let cameraItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Camera, target: self, action: Selector("uploadPics:"))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Camera, target: self, action: Selector("uploadPoster:"))
    }
    func uploadPics(sender:UIBarButtonItem!){
        
    }
    func uploadPoster(sender:UIBarButtonItem){
    }
    
    
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "Embed Poster Segue" {
            var embeddedCollectionVC = segue.destinationViewController as PosterCollectionViewController
            embeddedCollectionVC.posterSource = activityToBeDisplay
            embeddedCollectionVC.isNormalUser = false
        }
        else{
            if segue.identifier == "Embed Follower Segue"{
                var embeddedFollowerVC = segue.destinationViewController as FollowerCollectionVC
                embeddedFollowerVC.followersForActivity = self.activityToBeDisplay!
                println("10 \(self.activityToBeDisplay?.ID)")
            }
            else {
                if segue.identifier == "Embed Segue Outer Experience"{
                    var outerExpTVC = segue.destinationViewController as OuterExperienceTVController
                    outerExpTVC.activityForExperience = self.activityToBeDisplay
                }
            }

        }
    }
  

}
