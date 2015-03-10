//
//  ExperienceTableVC.swift
//  Bridge
//
//  Created by 许Bill on 15-3-3.
//  Copyright (c) 2015年 Fudan.SS. All rights reserved.
//

import UIKit

class ExperienceTableVC: UITableViewController {
    let cellReuseIdentifier = "Experience Cell"
    let nibClassname = "ExperienceTViewCell"
    var experiencelList = [Experience]()
    var relatedUser:User?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: nibClassname, bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: cellReuseIdentifier)
        let currentUser = self.relatedUser
        var expQuery = PFQuery(className: "Experience")
        expQuery.whereKey("uploadedBy", equalTo: PFUser(withoutDataWithObjectId: currentUser?.ID))
        expQuery.findObjectsInBackgroundWithBlock { (exps, error) -> Void in
            for exp in exps{
                
                let castedExp = Experience(newPFObject: exp as PFObject)
                self.experiencelList.append(castedExp)
            }
            self.tableView.reloadData()
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        var tmp = self.experiencelList.sorted {
            return $0.sendDate!.timeIntervalSince1970 < $1.sendDate!.timeIntervalSince1970
        }
        self.experiencelList = tmp
        return self.experiencelList.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier, forIndexPath: indexPath) as ExperienceTViewCell
        let experience = self.experiencelList[indexPath.row]
        cell.titleLabel.text = experience.title
        cell.bodyLabel.text = experience.body
        cell.voteButton.setTitle("\(experience.voted)", forState: UIControlState.Normal)
        
        cell.setTime(experience.sendDate!)
        cell.activityIcon.image = UIImage(named: "defaultActivityIcon")?
        let relatedActivity = experience.relatedActivity
        cell.activityNameLabel.text = relatedActivity?.activityName
        
        
        let iconFile = relatedActivity?.icon
        
        // Configure the cell...
        iconFile?.getDataInBackgroundWithBlock({ (ret, error) -> Void in
            cell.activityIcon.image = UIImage(data: ret)
        })
        return cell
    }
    
    
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    }
    */
    
}
