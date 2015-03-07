//
//  OrganiztionActivityOverviewTVC.swift
//  Bridge
//
//  Created by 许Bill on 15-2-25.
//  Copyright (c) 2015年 Fudan.SS. All rights reserved.
//

import UIKit

class OrganiztionActivityOverviewTVC: ParentActivityOverviewTVC {

    var reuseIdentifier = "Activity Overview Cell"
    //    var testObject:[PFObject] = [PFObject]()
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        println("Clear")
        self.relatedActivity = [Activity]()
        let logonUser = PFUser.currentUser()
        let query = PFQuery(className: "Activity")
        query.whereKey("createdBy", equalTo: logonUser)
        query.fromLocalDatastore()
        
        query.findObjectsInBackgroundWithBlock { (results, error) -> Void in
            println(results.count)
            for result in results {
                println(result)
                let act = Activity(newPFObject: result as PFObject)
                self.relatedActivity.append(act)
            }
            println("CC:\(self.relatedActivity.count)")
            self.tableView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let logonUser = PFUser.currentUser()
        let query = PFQuery(className: "Activity")
//        query.whereKey("CreatedBy", equalTo: logonUser)
//        query.findObjectsInBackgroundWithBlock { (results, error) -> Void in
//            for result in results {
//                let act = Activity(newPFObject: result as PFObject)
//                self.relatedActivity.append(act)
//            }
//            self.tableView.reloadData()
//        }
        
        self.tableView.registerClass(ActivityOverViewTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        self.tableView.registerNib(UINib(nibName: "ActivityOverViewTableViewCell", bundle: nil), forCellReuseIdentifier: reuseIdentifier)
    }
    override func viewWillAppear(animated: Bool) {
        self.tableView.reloadData()
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
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath) as ActivityOverViewTableViewCell
        
        let object:Activity = self.relatedActivity[indexPath.row]
        cell.activityNameLabel.text = object.activityName
        println("Name\(object.activityName)")
        var formatter = NSDateFormatter()
        formatter.dateFormat = "MM/dd HH:mm"
        cell.timeLabel.text = formatter.stringFromDate(object.startDate)

        cell.activityPlaceLabel.text = object.activityPlace
        cell.activityDescriptionLabel.text = object.activityDescription
        
        let userImageFile = object.icon!
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
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = self.tableView.cellForRowAtIndexPath(indexPath) as ActivityOverViewTableViewCell
        
        performSegueWithIdentifier("Show Activity Detail", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier   == "Show Activity Detail" {
            //            if segue.destinationViewController
            let activityDetailVC =  segue.destinationViewController as ActivityViewController
            let indexPath = self.tableView.indexPathForCell(sender as ActivityOverViewTableViewCell)!
            activityDetailVC.activityToBeDisplay =
                self.relatedActivity[0]
            //indexPath.row
            println(index)
        }
    }

}
