//
//  DialogViewController.swift
//  Bridge
//
//  Created by 许Bill on 15-2-23.
//  Copyright (c) 2015年 Fudan.SS. All rights reserved.
//

import UIKit

class DialogViewController: UIViewController,UIActionSheetDelegate,UISplitViewControllerDelegate {
    
    var dialogToBeDisplayed:Dialog?
    @IBOutlet var scrollViewForDialog: UIScrollView!
    @IBOutlet var dialogHistoryContainer: UIView!
    
    
    @IBOutlet var messageToBeSent: UITextField!
    @IBAction func sendMessage(sender: UIButton) {
        var messageToSend = self.messageToBeSent.text
        self.messageToBeSent.text = ""
        let uploadMessage = PFObject(className: "Message")
        uploadMessage["MessageContent"] = messageToSend
//        uploadMessage["Dialog"] = givenDialog
        uploadMessage["Source"] = PFUser.currentUser()
        uploadMessage.pinInBackgroundWithBlock { (success, error) -> Void in
            if error == nil {
               
                NSNotificationCenter.defaultCenter().postNotificationName("newInputMessage", object: self)
                //Signal a notification
            }
        }
        uploadMessage.saveInBackgroundWithBlock { (success, error) -> Void in
            if error == nil {
                
            }
        }
    }
    override func awakeFromNib() {
        self.splitViewController?.delegate = self
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShowUp:"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func keyboardWillShowUp(notification:NSNotification){
        let userInfo = notification.userInfo as NSDictionary!
        let frameNew = (userInfo[UIKeyboardFrameEndUserInfoKey] as NSValue).CGRectValue()
        (self.scrollViewForDialog.contentInset.bottom) = frameNew.height
        //        self.tableView.contentInset.bottom = frameNew.height
        println( "bt\(self.scrollViewForDialog.contentInset.bottom)")
        println("Scroll height \(frameNew.height)")
    }
    func keyboardWillHide(notification:NSNotification){
        let userInfo = notification.userInfo as NSDictionary!
        let kbSize = (userInfo[UIKeyboardFrameBeginUserInfoKey])?.CGRectValue()
        let insetNewBottom = scrollViewForDialog.convertRect(kbSize!, fromView: nil).height
        
        println( "btDOWNWODNW  \(self.scrollViewForDialog.contentInset.bottom)")
        self.scrollViewForDialog.contentInset.bottom = 0
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Embed Dialog History"{
            var dialogHistoryVC = segue.destinationViewController as DialogHistoryViewController
            dialogHistoryVC.computedDialog = self.dialogToBeDisplayed
        }
    }
    
}
