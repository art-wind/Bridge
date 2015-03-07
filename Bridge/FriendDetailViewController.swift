//
//  FriendDetailViewController.swift
//  Attributor
//
//  Created by 许Bill on 15-2-10.
//  Copyright (c) 2015年 Fudan.SS. All rights reserved.
//

import UIKit

class FriendDetailViewController: UIViewController {
   
    @IBOutlet var icon: UIImageView!
    
    @IBOutlet var nicknameLabel: UILabel!
    @IBOutlet var concernButton: UIButton!
    @IBOutlet var vectorView: UIView!
    var relatedUser:User?
    override func viewDidLoad() {
        println("Start loading")
        let imageData = relatedUser?.imageIcon
        self.icon.image = UIImage(named: "defaultActivityIcon")
        imageData?.getDataInBackgroundWithBlock({ (data, error) -> Void in
            self.icon.image = UIImage(data: data)
        })
        self.nicknameLabel.text = self.relatedUser?.nickname
    }
    @IBAction func flashBack(sender:UIBarButtonItem){
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            
        })
    }
    @IBAction func establishRelationship(sender: UIButton) {
        let targetUser = PFUser(withoutDataWithObjectId: self.relatedUser?.ID)
        var friendShipQuery = PFQuery(className: "Relationship")
        friendShipQuery.whereKey("target", equalTo: targetUser)
        friendShipQuery.whereKey("source", equalTo: PFUser.currentUser())
        friendShipQuery.findObjectsInBackgroundWithBlock { (relations, error) -> Void in
            if relations.count == 1{
                println("You are already Friends!!!")
            }
            else{
                var relation = PFObject(className: "Relationship")
                relation["target"] = PFUser(withoutDataWithObjectId: self.relatedUser?.ID)
                relation["source"] = PFUser.currentUser()
                relation.saveInBackgroundWithBlock { (ok, error) -> Void in
                    if error != nil {
                        println("FriendDetailVC save relationship error")
                    }
                    else{
                        if ok == true {
                            println("Relationship ested")
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
