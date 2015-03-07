//
//  DialogViewController.swift
//  Bridge
//
//  Created by 许Bill on 15-2-19.
//  Copyright (c) 2015年 Fudan.SS. All rights reserved.
//

import UIKit

class DialogHistoryViewController: UITableViewController,UISplitViewControllerDelegate{
    let reuseIdentifier = "Dialog Cell"
    var dialogIDToBeDisplayed:Dialog?
    var messagesLocalDB = [Message]()
    var opponentImage:UIImage = UIImage(named: "defaultIcon")!
    var computedDialog:Dialog?{
        get{
            return dialogIDToBeDisplayed
        }
        set{
            dialogIDToBeDisplayed = newValue
            loadTheTableViewManually()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("loadTheTableView:"), name: "newInputMessage", object: nil)
        
        
    
        self.tableView.registerNib(UINib(nibName: "DialogCell", bundle: nil), forCellReuseIdentifier: reuseIdentifier)
        self.tableView.registerClass(DialogCell.self, forCellReuseIdentifier: reuseIdentifier)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Compose, target: self, action: Selector("writeMessage:"))
        loadTheTableViewManually()
        
    }
    func loadTheTableView(notification:NSNotification ){
//        dialogues = [Message]()
        var queryDialogsFromLocalDB = PFQuery(className: "Message")
        queryDialogsFromLocalDB.whereKey("participants", containsAllObjectsInArray: [PFUser.currentUser()])
        queryDialogsFromLocalDB.fromLocalDatastore()
        queryDialogsFromLocalDB.findObjectsInBackgroundWithBlock { (dialogs, error) -> Void in
            if error == nil {
                for obj in dialogs {
                    let dialog = obj as PFObject
                }
                self.tableView.reloadData()
            }
        }
    }
    func loadTheTableViewManually(){
        self.messagesLocalDB = [Message]()
        if let id = computedDialog{
            var queryMessagsFromLocalDB = PFQuery(className: "Message")
           queryMessagsFromLocalDB.whereKey("dialogID", equalTo:PFObject(withoutDataWithClassName: "Dialog", objectId: computedDialog!.ID))
           queryMessagsFromLocalDB.addAscendingOrder("sendDate")

            println(computedDialog!.ID)
            queryMessagsFromLocalDB.findObjectsInBackgroundWithBlock { (messages, error) -> Void in
                if error == nil {
                    println(messages.count)
                    for obj in messages {
                        let message = Message(newPFObject:obj as PFObject)
                        self.messagesLocalDB.append(message)
                    }
                    self.tableView.reloadData()
                }
                else{
                    println("Error")
                    println(messages.count)
                }
            }
        }
        else{
            println("Nothing to have")
        }
        if self.messagesLocalDB.count > 0{
            self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: self.messagesLocalDB.count-1), atScrollPosition:UITableViewScrollPosition.Bottom, animated: true)
        }
        
    }
    //MARK: -Send message
    @IBAction func writeMessage(sender: UIBarButtonItem) {
        
        var alert = UIAlertController(title: "Alert", message: "Message", preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addTextFieldWithConfigurationHandler({(textField: UITextField!) in
            textField.placeholder = "Enter text:"
        })
        
        
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        
        
        let sendAction = UIAlertAction(title:"发送"
            , style: UIAlertActionStyle.Default) { (act) -> Void in
                let message = alert.textFields?[0] as UITextField
                let string = message.text
                self.sendMessage(string)
        }
        alert.addAction(sendAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    func sendMessage(message:String){
        let sendDate = NSDate()
        let content = message
        let source = PFUser.currentUser()
        let dialogID =  PFObject(withoutDataWithClassName: "Dialog", objectId: dialogIDToBeDisplayed?.ID)
        
        var uploadMessage = PFObject(className: "Message")
        
        var dialogQuery = PFQuery(className:"Dialog")
        dialogQuery.getObjectInBackgroundWithId(self.dialogIDToBeDisplayed?.ID) {
            (dialog: PFObject!, error: NSError!) -> Void in
            if error != nil {
                println(error)
            } else {
                dialog["lastMessageTime"] = sendDate
                dialog["lastMessageContent"] = content
                dialog.saveInBackgroundWithBlock({ (ok, error) -> Void in
                    let notificationCenter = NSNotificationCenter.defaultCenter()
                    
                    notificationCenter.postNotification(NSNotification(name:"refreshMessageTableView"
                        , object:nil))
                    
                    
                })
                
            }
        }
        
        uploadMessage["dialogID"] = dialogID
        uploadMessage["source"] = source
        uploadMessage["content"] = content
        uploadMessage["sendDate"] = sendDate
        uploadMessage.saveInBackgroundWithBlock { (success, error) -> Void in
            if success == true {
                println("Successfully upload The message")
                self.loadTheTableViewManually()
                //Post notification to split view controller 
                
                let deviceQuery = PFInstallation.query()
                let group = self.dialogIDToBeDisplayed?.participants.filter({ (g) -> Bool in
                    return g != PFUser.currentUser()
                })
                
                deviceQuery.whereKey("currentUser", containedIn: group)
                let push = PFPush()
                let data = [
                    "alert" : "You have a message from \(User(newPFUser: PFUser.currentUser()).nickname!))!",
                    "badge" : "Increment",
                    "id":"\(self.dialogIDToBeDisplayed!.ID)"
                ]
                push.setQuery(deviceQuery)
                push.setData(data)
//                push.setMessage("You have a message from \(User(newPFUser: PFUser.currentUser()).nickname))!")
                push.sendPushInBackground()
            }
        }
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return messagesLocalDB.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath) as DialogCell
        cell.deInitialize()
        // dialogues[indexPath.row % dialogues.count]
        var message:Message = messagesLocalDB[indexPath.row]

        if message.source == PFUser.currentUser(){
            cell.setViews(cell.frame.width,icon: UIImage(named: "minion")!, messageContent: message.content, backgroungImage: UIImage(named: "dialog_blue")!,isLeft:false)
        }
        else{
            cell.setViews(cell.frame.width,icon: self.opponentImage, messageContent: message.content, backgroungImage: UIImage(named: "dialog_green")!,isLeft:true)
        }
        return cell
    }

    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return DialogCell.getHeight(messagesLocalDB[indexPath.row].content,cellWidth:self.tableView.frame.width)
    }
}
