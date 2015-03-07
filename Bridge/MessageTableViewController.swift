//
//  MessageTableViewController.swift
//  Attributor
//
//  Created by 许Bill on 15-2-9.
//  Copyright (c) 2015年 Fudan.SS. All rights reserved.
//

import UIKit
//import "Message"
class MessageTableViewController: UITableViewController,UIApplicationDelegate{
    var dialogsToBeDisplayed:[Dialog] = []
    var imageIcons = [UIImage]()
    var oppentNickname = [String]()
    var newMessages = [String:Int]()
    
    let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    let identifier:String = "Message Cell"
    override func viewDidLoad() {
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: Selector("loadTheTableData:"), forControlEvents: UIControlEvents.ValueChanged)
        super.viewDidLoad()
        self.loadData()
        self.tableView.registerNib(UINib(nibName: "MessageTableViewCell", bundle: nil), forCellReuseIdentifier: identifier)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("loadTheTableData:"), name: "refreshMessageTableView", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("redDotToAlert:"), name: "newMessageIncoming", object: nil)
        
    }
    func redDotToAlert(sender:NSNotification!)
    {
        
        self.newMessages = appDelegate.objectIDForNewMessage
        println(self.newMessages)
        loadData()
    }
    
    
    func loadTheTableData(sender:AnyObject){
        loadData()
    }
    func loadData(){
        self.dialogsToBeDisplayed = [Dialog] ()
        self.imageIcons = [UIImage]()
        var queryDialogsFromLocalDB = PFQuery(className: "Dialog")
        queryDialogsFromLocalDB.whereKey("participants", containsAllObjectsInArray: [PFUser.currentUser()])
        queryDialogsFromLocalDB.addDescendingOrder("lastMessageTime")
        //        queryDialogsFromLocalDB.fromLocalDatastore()
        queryDialogsFromLocalDB.findObjectsInBackgroundWithBlock { (dialogs, error) -> Void in
            if error == nil {
                for obj in dialogs {
                    let dialog = Dialog(newPFObject: obj as PFObject)
                    println(dialog.objectId)
                    self.dialogsToBeDisplayed.append(dialog)
                    
                    self.imageIcons.append(UIImage(named: "defaultIcon")!)
                }
                self.tableView.reloadData()
                self.refreshControl?.endRefreshing()
            }
        }
    }
    @IBAction func refreshAction(sender: UIBarButtonItem) {
        loadData()
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
        return self.dialogsToBeDisplayed.count
    }
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("Message Cell") as MessageTableViewCell
        
        return cell.frame.size.height
    }

    //
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        println("Into the cell")
       
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier) as MessageTableViewCell
        
        let dialog = self.dialogsToBeDisplayed[indexPath.row]
        if let num =  self.newMessages[dialog.ID] {
            if num > 0{
                cell.setBadgeValue(num)
            }
        }
        
        
        
        let messengers = dialog.participants
        var opponent:User?
        for opp in messengers {
            
            if opp != PFUser.currentUser(){
                opponent = User(newPFUser: opp)
                break
            }
        }
        cell.nameLabel.text = opponent?.nickname
        cell.imageIcon.image = UIImage(named: "defaultIcon")
        let icon = opponent?.imageIcon
        icon?.getDataInBackgroundWithBlock({ (data, error) -> Void in
            cell.imageIcon.image = UIImage(data: data)
            self.imageIcons[indexPath.row] = UIImage(data: data)!
        })
        cell.contentLabel.text = dialog.lastMessageContent?
        let dateFormmatter = NSDateFormatter()
        if let date = dialog.lastMessageTime {
            let currentDate = NSDate()
            if currentDate.timeIntervalSinceDate(date) > NSTimeInterval(60*60*24){
                dateFormmatter.dateFormat = "MM/dd"
                cell.timeLabel.text = dateFormmatter.stringFromDate(date)
            }
            else{
                dateFormmatter.dateFormat = "HH:mm"
                cell.timeLabel.text = dateFormmatter.stringFromDate(date)
            }
        }
        
        
        return cell
    }
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let dialog = self.dialogsToBeDisplayed[indexPath.row]
        if var detail = self.splitViewController?.viewControllers[1] as? UINavigationController
        {
            
            if let num =  self.newMessages[dialog.ID] {
                if num > 0{
                    self.newMessages[dialog.ID] = 0
                    self.appDelegate.objectIDForNewMessage[dialog.ID] = 0
                    var cell = self.tableView.cellForRowAtIndexPath(indexPath) as MessageTableViewCell
                    cell.setBadgeValue(0)
                }
            }
            
            
            let dialogVC = detail.topViewController as DialogHistoryViewController//)as DialogHistoryViewController
            dialogVC.computedDialog = dialog
            dialogVC.opponentImage = self.imageIcons[indexPath.row]
            dialogVC.title = (self.tableView.cellForRowAtIndexPath(indexPath) as MessageTableViewCell).nameLabel.text
        }
    }

    

}
