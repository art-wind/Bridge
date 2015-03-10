//
//  FriendDetailViewController.swift
//  Attributor
//
//  Created by 许Bill on 15-2-10.
//  Copyright (c) 2015年 Fudan.SS. All rights reserved.
//

import UIKit

class FriendDetailViewController: UIViewController {
    var doesHaveFriendShip:Bool = true
    var isSureAboutFriendship = true
    @IBOutlet var icon: UIImageView!
    
    @IBOutlet var vectorView: UILabel!
    @IBOutlet var nicknameLabel: UILabel!
    @IBOutlet var concernButton: UIButton!
    @IBOutlet var chatButton: UIButton!
    
    @IBOutlet var cancelFriendShip: UIButton!
    
    @IBAction func cancelFriendshipAction(sender: UIButton) {
        let friendshipQuery = PFQuery(className: "Friendship")
        friendshipQuery.whereKey("source", equalTo: PFUser.currentUser())
        friendshipQuery.whereKey("target", equalTo: PFUser(withoutDataWithObjectId: self.relatedUser?.ID))
        friendshipQuery.findObjectsInBackgroundWithBlock {[weak self] (results, error) -> Void in
            if error != nil{
                
                
            }else{
                for r in results   {
                    let pfR = (r as PFObject)
                    pfR.deleteInBackgroundWithBlock({(ok, error) -> Void in
                        if error != nil {
                            
                        }
                        else{
                            if ok {
                                println("Delete Done")
                                self!.doesHaveFriendShip = false
                                self!.setTheConcernButton()
                                NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: "deleteFriendship", object: nil))
                            }
                            
                        }

                    })
                }
            }
        }
    }
    var relatedUser:User?
    override func viewDidLoad() {
        
        let imageData = relatedUser?.imageIcon
        self.icon.image = UIImage(named: "defaultActivityIcon")
        imageData?.getDataInBackgroundWithBlock({ (data, error) -> Void in
            self.icon.image = UIImage(data: data)
        })
        self.nicknameLabel.text = self.relatedUser?.nickname
        var tags = self.relatedUser?.tags
        var tagsToShow:String = ""
        for t in tags! {
            tagsToShow += "  \(t)"
        }
        self.vectorView.text = tagsToShow
        initializeTheConcernButton()
        
        
        self.icon.layer.cornerRadius = 10
        self.icon.layer.masksToBounds = true
        self.concernButton.layer.cornerRadius = 5
        self.concernButton.layer.masksToBounds = true
        self.chatButton.layer.cornerRadius = 5
        self.chatButton.layer.masksToBounds = true
        self.vectorView.layer.cornerRadius = 10
        self.vectorView.layer.masksToBounds = true
        self.cancelFriendShip.layer.cornerRadius = 5
        self.cancelFriendShip.layer.masksToBounds = true
    }
    func setTheConcernButton(){
        if self.doesHaveFriendShip == true {
            self.cancelFriendShip.hidden = false
            self.concernButton.setTitle("已关注", forState: UIControlState.Normal)
            self.concernButton.enabled = false
        }
        else{
            self.cancelFriendShip.hidden = true
            self.concernButton.setTitle("关注", forState: UIControlState.Normal)
            self.concernButton.enabled = true
        }
    }
    func initializeTheConcernButton(){
        if self.isSureAboutFriendship == true {
            setTheConcernButton()
        }
        else{
            var relationQuery = PFQuery(className: "Friendship")
            relationQuery.whereKey("source", equalTo: PFUser.currentUser())
            relationQuery.whereKey("target", equalTo: PFUser(withoutDataWithObjectId: self.relatedUser?.ID))
            relationQuery.findObjectsInBackgroundWithBlock({ [weak self](result, error) -> Void in
                if error != nil {
                    println()
                }
                else{
                    self!.isSureAboutFriendship = true
                    println("\(result.count)")
                    if result.count == 0 {
                        self!.doesHaveFriendShip = false
                    }
                    else{
                        self!.doesHaveFriendShip = true
                    }
                    self!.isSureAboutFriendship = true
                    self!.setTheConcernButton()
                }
            })
        }
        
    }
    @IBAction func flashBack(sender:UIBarButtonItem){
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            
        })
    }
    @IBAction func establishRelationship(sender: UIButton) {
        let targetUser = PFUser(withoutDataWithObjectId: self.relatedUser?.ID)
        var friendShipQuery = PFQuery(className: "Friendship")
        friendShipQuery.whereKey("source", equalTo: PFUser.currentUser())
        friendShipQuery.whereKey("target", equalTo: targetUser)
        friendShipQuery.findObjectsInBackgroundWithBlock { (relations, error) -> Void in
            if relations.count == 1{
                println("You are already Friends!!!")
            }
            else{
                var relation = PFObject(className: "Friendship")
                relation["target"] = PFUser(withoutDataWithObjectId: self.relatedUser?.ID)
                relation["source"] = PFUser.currentUser()
                relation.saveInBackgroundWithBlock {[weak self](ok, error) -> Void in
                    if error != nil {
                        println("FriendDetailVC save relationship error")
                    }
                    else{
                        if ok == true {
                            NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: "newFollowUp", object: nil))
                            println("Relationship ested")
                            self!.doesHaveFriendShip = true
                            self!.setTheConcernButton()
                        }
                    }
                }
            }
        }
        
        
    }
    @IBAction func startChat(sender: UIButton) {
        recursiveSearchDialogAndSegue()
        
    }
    func recursiveSearchDialogAndSegue(){
        let tmpRelatedUser = PFUser(withoutDataWithObjectId: self.relatedUser?.ID)
        let array = [tmpRelatedUser,PFUser.currentUser()]
        let dialogQuery = PFQuery(className: "Dialog")
        dialogQuery.whereKey("participants", containedIn: array)
        dialogQuery.whereKey("participants", containsAllObjectsInArray: array)
        dialogQuery.findObjectsInBackgroundWithBlock { (dials, error) -> Void in
            if error != nil {
                println("Fetching dialog error")
            }
            else{
                if dials.count > 1 {
                    println("Duplicates dialogs error")
                }
                else{
                    if dials.count == 1 {
                        let dialog = Dialog(newPFObject: dials[0] as PFObject)
                        let dialogHistoryVC = DialogHistoryViewController()
                        dialogHistoryVC.opponentImage = UIImage(named: "defaultIcon")!
                        dialogHistoryVC.dialogIDToBeDisplayed = dialog
                        dialogHistoryVC.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
                        self.navigationController?.pushViewController(dialogHistoryVC, animated: true)
                    }
                    else{
                        var createNewDialog = PFObject(className:"Dialog")
                        createNewDialog["participants"] = array
                        createNewDialog["lastMessageTime"] = NSDate()
                        createNewDialog["lastMessageContent"] = "testContent"
                        weak var weakDialog = createNewDialog
                        println(weakDialog)
                        createNewDialog.saveInBackgroundWithBlock({ (success, error) -> Void in
                            if success {
                                self.recursiveSearchDialogAndSegue()
                            }
                        })
                    }
                }
            }
        }
    }
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Embedded Experience" {
            let expTVC = segue.destinationViewController as ExperienceTableVC
            expTVC.relatedUser = self.relatedUser
        }
        
    }
    
    
}
