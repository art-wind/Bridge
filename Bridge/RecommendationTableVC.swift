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
    var activityLinkedLists = [[Activity](),[Activity](),[Activity]()]
    var userLinkedLists = [[User](),[User](),[User]()]
    var activityPropertyForSegue:Activity?
    var userPropertyForSegue:User?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nibClassForUser = UINib(nibName: "FriendTableCell", bundle: nil)
        self.tableView.registerNib(nibClassForUser, forCellReuseIdentifier: reuseIDForUsers)
        let nibClassForActivity = UINib(nibName: "ActivityOverViewTableViewCell", bundle: nil)
        self.tableView.registerNib(nibClassForActivity, forCellReuseIdentifier: reuseIDForActivities)
        self.segmentController.addTarget(self, action: Selector("Print:"), forControlEvents: UIControlEvents.ValueChanged)
        loadData()
    }
    func Print(sender:AnyObject){
        println("ininin\(self.segmentController.selectedSegmentIndex)")
        loadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func categorizeActivity(acts:[Activity]){
        let currentUser = User(newPFUser: PFUser.currentUser())
        for act in acts {
            let similar = VectorHandler.computeSimilarity(currentUser, activity: act)
            println()
            if similar > 0.6 {
                self.activityLinkedLists[0].append(act)
            }
            else {
                if similar > 0.3 {
                    self.activityLinkedLists[1].append(act)
                }
                else{
                    self.activityLinkedLists[2].append(act)

                }
            }
        }
    }
    func categorizeUser(users:[User]){
        let currentUser = User(newPFUser: PFUser.currentUser())
        for user in users {
            let similar = VectorHandler.computeUserSimilarity(currentUser, anotherUser: user)
            println("123:\(user.nickname) \(similar)")
            if similar > 0.6 {
                self.userLinkedLists[0].append(user)
            }
            else {
                if similar > 0.3 {
                    self.userLinkedLists[1].append(user)
                }
                else{
                    self.userLinkedLists[2].append(user)
                    
                }
            }
        }
    }
    
    
    
    
    // MARK: - Fetch the result
    func loadData(){
        let logonUser = PFUser.currentUser()
        
        let index = self.segmentController.selectedSegmentIndex
        if index == 0 {
            self.activityLinkedLists = [[Activity](),[Activity](),[Activity]()]
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
                            var tmp = [Activity]()
                            for act in acts{
                                tmp.append(Activity(newPFObject: act as PFObject))
                            }
                            self.categorizeActivity(tmp)
                            self.tableView.reloadData()
                        }
                    }
                }
                
                
                
            }
        }
        //search for the related activities(at most 10)
        
        else{
            self.userLinkedLists = [[User](),[User](),[User]()]
            //search for the related users (at most 10)
            let concernedUserQuery = PFQuery(className: "Friendship")
            concernedUserQuery.whereKey("source", equalTo: PFUser.currentUser())
            concernedUserQuery.findObjectsInBackgroundWithBlock { (concerns, error) -> Void in
                if error != nil {
                    println("Recommendation error fetch concernedUserQuery")
                }
                var concernedUsers = concerns.map({ (r) -> String in
                    return (r["target"] as PFObject).objectId
                })
                let id = PFUser.currentUser().objectId
                concernedUsers.append(id)
                println(concernedUsers)
                
                let userQuery = PFUser.query()
                userQuery.whereKey("objectId", notContainedIn: concernedUsers)
                userQuery.limit = 10
                userQuery.findObjectsInBackgroundWithBlock { (users, error) -> Void in
                    if error != nil {
                        println("Recommendation error fetch act")
                    }
                    else{
                        if users.count == 0 {
                            
                        }
                        else{
                            var tmp = [User]()
                            for u in users{
                                tmp.append(User(newPFUser: u as PFUser))
                            }
                            self.categorizeUser(tmp)
                            self.tableView.reloadData()
                        }
                    }
                }
                
                
                
            }
        }
        
        
    }
    
    
    
    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 3
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        let selectedIndex = self.segmentController.selectedSegmentIndex
        
//        return self.activityLists.count
                if selectedIndex == 0 {
                    
                    var tmp = self.activityLinkedLists[section].sorted {
                        return $0.startDate.timeIntervalSince1970 < $1.startDate.timeIntervalSince1970
                    }
                    self.self.activityLinkedLists[section] = tmp
                    
                    return self.activityLinkedLists[section].count
                }
                else{
                    return self.userLinkedLists[section].count
                }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        let selectedIndex = self.segmentController.selectedSegmentIndex
        if selectedIndex == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier(reuseIDForActivities, forIndexPath: indexPath) as ActivityOverViewTableViewCell
            let activity = self.activityLinkedLists[section][row]
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
            
            let p:User =  self.userLinkedLists[section][row]
            
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
        if self.segmentController.selectedSegmentIndex == 0 {
            if section == 0 {
                return "60%以上吻合"
            }
            if section == 1 {
                return "30% ~ 60% "
            }
            if section == 2 {
                return "低于30%"
            }
        }
        else{
            if section == 0 {
                return "60%以上吻合"
            }
            if section == 1 {
                return "30% ~ 60% "
            }
            if section == 2 {
                return "低于30%"
            }
        }
        return ""
    }
    
    //MARK: - Delegate Method
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let section = indexPath.section
        let row = indexPath.row
        let index = self.segmentController.selectedSegmentIndex
        if index == 0 {
            self.activityPropertyForSegue = self.activityLinkedLists[section][row]
            performSegueWithIdentifier("Recommend Segue For Activity", sender: self)
            
        }
        else{
            println("S: \(section) R: \(row)")
            println("Length:  \(self.userLinkedLists[section].count)")
            self.userPropertyForSegue = self.userLinkedLists[section][row]
            performSegueWithIdentifier("Recommend Segue For User", sender: self)
        }
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Recommend Segue For User"{
            var friendDetailVC = segue.destinationViewController as FriendDetailViewController
//            let  friendDetailVC = naviController.viewControllers[0] as FriendDetailViewController
            friendDetailVC.relatedUser = self.userPropertyForSegue
            friendDetailVC.doesHaveFriendShip = false
        }
        
        else if segue.identifier == "Recommend Segue For Activity" {
            
            var actVC = segue.destinationViewController as ActivityViewController
            actVC.activityToBeDisplay = self.activityPropertyForSegue
            actVC.isFollowedUP = false
        }
        else{
            
           

        }
        
    }
    
    
}
