//
//  FriendOverviewTableVC.swift
//  Bridge
//
//  Created by 许Bill on 15-3-1.
//  Copyright (c) 2015年 Fudan.SS. All rights reserved.
//

import UIKit
class FriendOverviewTableVC: UITableViewController{
    var friendsList:[User] = [User]()
    let resuseCellIdentifier:String = "Friend Cell"
    let NibClassName:String = "FriendTableCell"
    var seguePropertyOfFriend:User?
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: NibClassName, bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: resuseCellIdentifier)
        //        self.tableView.registerClass(MessageCell.self, forCellReuseIdentifier: resuseCellIdentifier)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("loadData"), name: "newFriendship", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("loadData"), name: "deleteFriendship", object: nil)
        loadDataManually()
        
        
    }
    func loadDataManually(){
        self.friendsList = [User]()
        let currentUser = PFUser.currentUser()
        var friendQuery = PFQuery(className: "Friendship")
        friendQuery.whereKey("source", equalTo: currentUser)
        friendQuery.findObjectsInBackgroundWithBlock { (friendships, error) -> Void in
            for frdship in friendships{
                println("Fr \(frdship as PFObject)")
                let f = User(newPFUser: frdship["target"] as PFUser)
                println(f)
                self.friendsList.append(f)
            }
            self.tableView.reloadData()
        }
    }
    func loadData(sender:AnyObject?){
        loadDataManually()
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
        return self.friendsList.count
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(resuseCellIdentifier) as FriendTableCell
        
        let row = indexPath.row
        let section = indexPath.section
        
        
        let p:User = self.friendsList[row]
        println("p:  \(p)")
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
    
    
    //MARK: - Delegate Method
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.seguePropertyOfFriend = self.friendsList[indexPath.row]
        performSegueWithIdentifier("Check Detail", sender: self.tableView.cellForRowAtIndexPath(indexPath))
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Check Detail"{
            var friendDetailVC = segue.destinationViewController as FriendDetailViewController
            
            friendDetailVC.relatedUser =  self.seguePropertyOfFriend
            friendDetailVC.doesHaveFriendShip = true
            friendDetailVC.isSureAboutFriendship = true
        }
    }
}
