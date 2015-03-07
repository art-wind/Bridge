//
//  ActivityOverViewTableViewController.swift
//  Bridge
//
//  Created by 许Bill on 15-3-7.
//  Copyright (c) 2015年 Fudan.SS. All rights reserved.
//

import UIKit

class ActivityOverViewTableViewController: ParentActivityOverviewTVC {
    var reuseIdentifier = "Activity Overview Cell"
    var recordsToBeFeteched = 0
    var startFetch = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.registerClass(ActivityOverViewTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        self.tableView.registerNib(UINib(nibName: "ActivityOverViewTableViewCell", bundle: nil), forCellReuseIdentifier: reuseIdentifier)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("loadDateByNotification:"), name: "newFollowUp", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("loadDateByNotification:"), name: "cancelFollowUp", object: nil)
        loadData()
        
        
        
        
        
    }
    func loadDateByNotification(sender:NSNotification){
        loadData()
    }
    func loadData(){
        self.relatedActivity = [Activity]()
        let logonUser = PFUser.currentUser()
        let query = PFQuery(className: "FollowUp")
        query.whereKey("Follower", equalTo: logonUser)
        query.findObjectsInBackgroundWithBlock {(results, error) -> Void in
            self.recordsToBeFeteched = results.count
            println("Length:  \(self.recordsToBeFeteched)")
            self.startFetch = true
            for result in results {
                let object = result["Channel"] as PFObject
                object.fetchInBackgroundWithBlock({(retAct, error) -> Void in
//                    println(retAct)
                    self.relatedActivity.append(Activity(newPFObject: retAct as PFObject))
                    self.recordsToBeFeteched--
                    self.reloadDataIfNeeded()
                })
            }
            
            
        }
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier(reuseIdentifier) as ActivityOverViewTableViewCell
        let activity = self.relatedActivity[indexPath.row]
        
        cell.activityNameLabel.text = activity.activityName
        cell.activityPlaceLabel.text = activity.activityPlace
        
        
        cell.timeLabel.text = "\(activity.startDate)"
        cell.activityDescriptionLabel.text = activity.activityDescription
        
        let im = activity.icon as PFFile?
        im?.getDataInBackgroundWithBlock({ (data, error) -> Void in
            if error == nil {
                cell.activityIcon.image = UIImage(data: data)
            }
        })
        cell.oraganizationLabel.text = "Organization"
        
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    
    
    override func viewWillAppear(animated: Bool) {
        self.tableView.reloadData()
    }
    func reloadDataIfNeeded(){
        if startFetch == true && recordsToBeFeteched == 0 {
            self.tableView.reloadData()
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
        return self.relatedActivity.count
//        return 0
    }
    
    
    
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
            return "我的活动"
        }
        else{
            return super.tableView(tableView, titleForHeaderInSection: section)
        }
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = self.tableView.cellForRowAtIndexPath(indexPath) as ActivityOverViewTableViewCell
        
        performSegueWithIdentifier("Show Activity Detail", sender: cell)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier   == "Show Activity Detail" {
            let activityDetailVC =  segue.destinationViewController as ActivityViewController
            let indexPath = self.tableView.indexPathForCell(sender as ActivityOverViewTableViewCell)!
            activityDetailVC.isFollowedUP = true
            activityDetailVC.activityToBeDisplay = self.relatedActivity[indexPath.row]
            println(self.relatedActivity[indexPath.row].vector)
        }
    }
    
}
