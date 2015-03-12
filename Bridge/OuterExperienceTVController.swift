//
//  OuterExperienceTVController.swift
//  Bridge
//
//  Created by 许Bill on 15-3-7.
//  Copyright (c) 2015年 Fudan.SS. All rights reserved.
//

import UIKit

class OuterExperienceTVController: UITableViewController {
    var activityForExperience:Activity?
    var expList:[Experience] = [Experience]()
    let reuseID = "Outer Experience Cell"
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "OuterExperienceTVCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: reuseID)
        
        
        let query = PFQuery(className: "Experience")
        query.whereKey("relatedActivity", equalTo: PFObject(withoutDataWithClassName: "Activity", objectId: self.activityForExperience?.ID))
        query.addDescendingOrder("sendDate")
        query.findObjectsInBackgroundWithBlock { (results, error) -> Void in
            if error != nil {
                println("Sth wrong")
            }
            else{
                for r in results
                {
                    let exp = Experience(newPFObject: r as PFObject)
                    self.expList.append(exp)
                }
                self.tableView.reloadData()
                
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
        var tmp = self.expList.sorted {
            return $0.sendDate!.timeIntervalSince1970 > $1.sendDate!.timeIntervalSince1970
        }
        self.expList = tmp
        return self.expList.count
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = self.tableView.dequeueReusableCellWithIdentifier(reuseID) as OuterExperienceTVCell
        let exp = self.expList[indexPath.row]
        cell.titleLabel.text = exp.title
        cell.bodyTextView.text = exp.body
        cell.setTime(exp.sendDate!)
        
        let targetUser = exp.uploadedBy!
        cell.nicknameLabel.text = targetUser.nickname
        
        let data = targetUser.imageIcon
        data?.getDataInBackgroundWithBlock({ (ret, errp) -> Void in
            
            cell.userIcon.image = UIImage(data: ret)
        })
        return cell
    }

}
