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
    var shareViewShown:Bool?
    var activityToBeDisplay:Activity?
    var image:UIImage?
    
    @IBOutlet var followButton: UIButton!
    @IBOutlet var activityIconView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let im = activityToBeDisplay?.icon
        
        println(self.activityToBeDisplay)
        
        self.activityNameLabel.text = activityToBeDisplay?.activityName
        self.activityTimeLabel.text = "\(activityToBeDisplay?.startDate)"
        self.activityPlaceLabel.text = activityToBeDisplay?.activityPlace
        im?.getDataInBackgroundWithBlock({ (result, error) -> Void in
            self.activityIconView.image = UIImage(data: result)
            self.image = UIImage(data: result)
        })
        
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
    }
  

}
