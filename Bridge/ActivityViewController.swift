//
//  ActivityViewController.swift
//  Bridge
//
//  Created by 许Bill on 15-2-22.
//  Copyright (c) 2015年 Fudan.SS. All rights reserved.
//

import UIKit
import Social
class ActivityViewController:UIViewController {
    @IBOutlet var activityNameLabel: UILabel!
    @IBOutlet var activityTimeLabel: UILabel!
    @IBOutlet var activityDescriptionLabel: UITextView!
    @IBOutlet var activityPlaceLabel: UILabel!
    @IBOutlet var activityTagsLabel: UILabel!
   
    //FollowButton ✚
    var isFollowedUP:Bool?
    var activityToBeDisplay:Activity?
    var image:UIImage?
    @IBOutlet var followButton: UIButton!
    @IBOutlet var activityIconView: UIImageView!
    @IBOutlet var embededPosterCollectionView: UIView!
    @IBOutlet var cancelButton: UIButton!
    
    @IBAction func cancelAction(sender: UIButton) {
        let followUp = PFObject(className: "FollowUp")
        let activity = PFObject(withoutDataWithClassName: "Activity", objectId: self.activityToBeDisplay?.ID)
        followUp["Channel"] = activity
        followUp["Follower"] = PFUser.currentUser()
        followUp.deleteInBackgroundWithBlock { (ok, error) -> Void in
            println("\(activity.objectId) id:\(PFUser.currentUser().objectId)")
            if error == nil {
                self.cancelButton.hidden = true
                self.isFollowedUP = false
                self.changeTitleForGeneralButton()
                NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: "cancelFollowUp", object: nil))
            }
        }
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "分享", style: UIBarButtonItemStyle.Bordered, target: self, action: Selector("share:"))
        
        println(self.activityToBeDisplay)
        let im = activityToBeDisplay?.icon
        
        self.activityNameLabel.text = activityToBeDisplay?.activityName
        self.activityDescriptionLabel.text = activityToBeDisplay?.activityDescription
        var formatter = NSDateFormatter()
        formatter.dateFormat = "MM/dd HH:mm"
        self.activityTimeLabel.text = formatter.stringFromDate(activityToBeDisplay!.startDate)
        
        self.activityPlaceLabel.text = activityToBeDisplay?.activityPlace
        
        //The tag label
        var tagsToBeShown = ""
        for i in self.activityToBeDisplay!.tags! {
            tagsToBeShown += " \(i)"
        }
        self.activityTagsLabel.text = tagsToBeShown
        
        im?.getDataInBackgroundWithBlock({ (result, error) -> Void in
            self.activityIconView.image = UIImage(data: result)
            self.image = UIImage(data: result)
        })
        
        changeTitleForGeneralButton()
       
    }
    func changeTitleForGeneralButton(){
        if self.isFollowedUP == true {
            self.followButton.setTitle("添加到日历  📅", forState: UIControlState.Normal)
        }
        else{
            self.followButton.setTitle("关注活动    ♥️", forState: UIControlState.Normal)
            self.cancelButton.hidden = true
        }
    }

    @IBAction func pressTheGeneralButton(sender: UIButton) {
        if self.isFollowedUP == true{
            // Do some calender things
            let calanderHandler = CalenderHandler()
            let okay = calanderHandler.addACalender(self.activityToBeDisplay!)
            if okay {
                //Printout the result
            }
        }
        else{
            let activity = PFObject(withoutDataWithClassName: "Activity", objectId: self.activityToBeDisplay?.ID)
            var newFollowUp = PFObject(className: "FollowUp")
            newFollowUp["Channel"] = activity
            newFollowUp["Follower"] = PFUser.currentUser()
            newFollowUp.saveInBackgroundWithBlock({ (ok, error) -> Void in
               
                self.followButton.setTitle("添加到日历  📅", forState: UIControlState.Normal)
                self.cancelButton.hidden = false
                self.isFollowedUP = true
                NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: "newFollowUp", object: nil))
                
                
                let vcHandler = VectorHandler()
                vcHandler.adjustUserAfterFollowActity(User(newPFUser: PFUser.currentUser()), activity: self.activityToBeDisplay!)
            })

        }
    }
    
    
    func share (sender:UIBarButtonItem){
       let scvc:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeSinaWeibo)
       scvc.setInitialText("我在关注#\(self.activityToBeDisplay!.activityName) 欢迎来参与")
       let url:String = "http://baike.baidu.com/link?url=K9A8YNZcaUPWl17WcsZ15aZzfkPyREw1mbRB2_aKjLlVRa9NC05GzSdo4hZC5NWFufjGVuP8cBrP6YoeyMNSQw8AfZ6ws9qqjPjH8SqKlOy"
       scvc.addURL(NSURL(string: url))
       scvc.addImage(self.image)
        self.presentViewController(scvc, animated: true) { () -> Void in
            println("sakjdhkjsd")
        }
        
        scvc.completionHandler = {(result: SLComposeViewControllerResult) in
            if result == SLComposeViewControllerResult.Done {
            }
            else{
                if result == SLComposeViewControllerResult.Cancelled {
                }
            }
        }
        
    }
    
    
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
            if segue.identifier == "Embed Follower Segue"{
                var embeddedFollowerVC = segue.destinationViewController as FollowerCollectionVC
                embeddedFollowerVC.followersForActivity = self.activityToBeDisplay!
            }
            else{
                if segue.identifier == "Create Experience"{
                    var createExperienceVC = segue.destinationViewController as CreateNewExperienceViewController
                    createExperienceVC.relatedActivity = self.activityToBeDisplay
                }
            }
//        if segue.identifier == "Embed Poster Segue" {
//            var embeddedCollectionVC = segue.destinationViewController as PosterCollectionViewController
//            embeddedCollectionVC.posterSource = activityToBeDisplay
//        }
//        else{ }
    }
    
    
}
