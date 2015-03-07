//
//  ParentActivityOverviewTVC.swift
//  Bridge
//
//  Created by 许Bill on 15-2-25.
//  Copyright (c) 2015年 Fudan.SS. All rights reserved.
//

import UIKit

class ParentActivityOverviewTVC: UITableViewController {
    var relatedActivity = [Activity]()
    var similarActivity = [Activity]()
//    func initializerelatedActivitiesForUser(){
//        let logonUser = PFUser.currentUser()
//        let query = PFQuery(className: "FollowUp")
//        query.whereKey("Follower", equalTo: logonUser)
//        query.findObjectsInBackgroundWithBlock { (results, error) -> Void in
//            for result in results {
//                let act = result["Channel"] as PFObject
//                act.fetchIfNeededInBackgroundWithBlock({ (retAct, error) -> Void in
//                    self.relatedActivity.append(Activity(newPFObject: retAct))
//                })
//            }
//            
//        }
//        
//       
//        
//    }
//    func initializerelatedActivitiesForOrganization(){
//        let logonUser = PFUser.currentUser()
//        let query = PFQuery(className: "Activity")
//        query.whereKey("CreatedBy", equalTo: logonUser)
//        query.findObjectsInBackgroundWithBlock { (results, error) -> Void in
//            for result in results {
//                let act = Activity(newPFObject: result as PFObject)
//                self.relatedActivity.append(act)
//            }
//            self.tableView.reloadData()
//        }
//        
//    }
    
    
}
