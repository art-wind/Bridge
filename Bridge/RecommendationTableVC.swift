//
//  RecommendationTableVC.swift
//  Bridge
//
//  Created by 许Bill on 15-3-2.
//  Copyright (c) 2015年 Fudan.SS. All rights reserved.
//

import UIKit

class RecommendationTableVC: UITableViewController {
    var userLists = [User]()
    var activityLists = [Activity]()
    
    let reuseIDForUsers = "Friend Cell"
    let reuseIDForActivities = "Activity Overview Cell"
    @IBOutlet var searchBarView: UISearchBar!
    @IBOutlet var segmentController: UISegmentedControl!
    var activityPropertyForSegue:Activity?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nibClassForUser = UINib(nibName: "FriendTableCell", bundle: nil)
        self.tableView.registerNib(nibClassForUser, forCellReuseIdentifier: reuseIDForUsers)
        let nibClassForActivity = UINib(nibName: "ActivityOverViewTableViewCell", bundle: nil)
        self.tableView.registerNib(nibClassForActivity, forCellReuseIdentifier: reuseIDForActivities)
        loadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    // MARK: - Fetch the result 
    func loadData(){
        let logonUser = PFUser.currentUser()
        //search for the related users (at most 10)
        //search for the related activities(at most 10)
        let concernedActivityQuery = PFQuery(className: "FollowUp")
        concernedActivityQuery.whereKey("Follower", equalTo: PFUser.currentUser())
        concernedActivityQuery.findObjectsInBackgroundWithBlock { (concerns, error) -> Void in
            if error != nil {
                 println("Recommendation error fetch concernedActivityQuery")
            }
            var concernedActivities = concerns.map({ (r) -> String in
                return (r["Channel"] as PFObject).objectId
            })
            println(concerns.count)
            println(concernedActivities)
            let actQuery = PFQuery(className: "Activity")
            actQuery.whereKey("objectId", notContainedIn: concernedActivities)
            actQuery.limit = 10
            actQuery.findObjectsInBackgroundWithBlock { (acts, error) -> Void in
                if error != nil {
                    println("Recommendation error fetch act")
                }
                else{
                    if acts.count == 0 {
                        
                    }
                    else{
                        for act in acts{
                            self.activityLists.append(Activity(newPFObject: act as PFObject))
                        }
                        self.tableView.reloadData()
                    }
                }
            }
            
            
            
        }
        
        
    }
    
    
    
    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
//        let selectedIndex = self.segmentController.selectedSegmentIndex
        
        return self.activityLists.count
//        if selectedIndex == 0 {
//            return self.activityLists.count
//        }
//        else{
//            return self.userLists.count
//        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let section = indexPath.section
        let selectedIndex = self.segmentController.selectedSegmentIndex
        if selectedIndex > -1 {
            let cell = tableView.dequeueReusableCellWithIdentifier(reuseIDForActivities, forIndexPath: indexPath) as ActivityOverViewTableViewCell
            let activity = self.activityLists[indexPath.row]
            cell.activityNameLabel.text = activity.activityName
            
            var formatter = NSDateFormatter()
            formatter.dateFormat = "MM/dd HH:mm"
            cell.timeLabel.text = formatter.stringFromDate(activity.startDate)
            
            cell.activityPlaceLabel.text = activity.activityPlace
            cell.activityDescriptionLabel.text = activity.activityDescription
            
            let userImageFile = activity.icon!
            userImageFile.getDataInBackgroundWithBlock {
                (imageData: NSData!, error: NSError!) -> Void in
                if error == nil {
                    cell.activityIcon.image = UIImage(data: imageData)
                }
                else{
                    println("No picture for him")
                }
            }
            return cell
        }
        else{
            let  cell = tableView.dequeueReusableCellWithIdentifier(reuseIDForUsers, forIndexPath: indexPath) as FriendTableCell
            
            let p:User = self.userLists[indexPath.row]
            
            cell.nameLabel.text = p.nickname
            let imageFile = p.imageIcon as PFFile?
            cell.imageIcon.image = UIImage(named:"defaultIcon")
            imageFile?.getDataInBackgroundWithBlock({ (result, error) -> Void in
                if error == nil{
                    cell.imageIcon.image = UIImage(data: result)
                }
            })
            return cell
        }
    }
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "活动推荐"
        }
        else{
            return "人物推荐"
        }
    }
    
    //MARK: - Delegate Method
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let section = indexPath.section
        let row = indexPath.row
        if section == 0 {
            self.activityPropertyForSegue = self.activityLists[row]
            performSegueWithIdentifier("Recommend Segue For Activity", sender: self)
            
        }
        else{
            
        }
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Recommend Segue For Activity" {
            
            var actVC = segue.destinationViewController as ActivityViewController
            actVC.activityToBeDisplay = self.activityPropertyForSegue
            actVC.isFollowedUP = false
        }
    }


}
