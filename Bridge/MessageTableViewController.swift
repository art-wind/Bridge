//
//  MessageTableViewController.swift
//  Attributor
//
//  Created by 许Bill on 15-2-9.
//  Copyright (c) 2015年 Fudan.SS. All rights reserved.
//

import UIKit
//import "Message"
class MessageTableViewController: UITableViewController {
    var messages = [Message]()
    var persons = [Person]();
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var person0 = Person(personName: "和神",sortedString:"hesheng",gender: "Male", imageIcon: "icon1", registerTime: NSDate())
        persons.append(person0)
        var person1 = Person(personName: "君君",sortedString:"junjun", gender: "Male", imageIcon:"icon0", registerTime: NSDate())
        persons.append(person1)
        
       
        
        var msg0 = Message()
        msg0.setAttributes(messenger: "和神", sendingTime: "20:17", message: "恩恩好")
        self.messages.append(msg0)
        var msg1 = Message();
        msg1.setAttributes(messenger: "君君", sendingTime: "21:00", message: "不是特别懂sss")
        self.messages.append(msg1)
        
//       
    
       
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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
        return self.messages.count
    }
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let cell = tableView.dequeueReusableCellWithIdentifier("Message Cell") as MessageTableViewCell
        
        return cell.frame.size.height
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identifier:String = "Message Cell"
        println("Into the cell")
       
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier) as MessageTableViewCell
        
        
        let msg:Message = self.messages[indexPath.row]
        cell.setMessageTableViewCell(msg.name, content: msg.displayContent, time: msg.time)
        print(msg.name)
        for person in persons{
            if person.personName == msg.name {
                cell.setImageIcon(person.imageIcon)
            }
        }
        return cell
    }
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        println("inOver")
//        if segue.identifier == "DisplayImage" {
//            let destinationVC = segue.destinationViewController as DisplayImageController
//            
//            let indexPath = tableView.indexPathForSelectedRow()
////            destinationVC.imageToBeDisplayed = self.persons[indexPath!.row].imageIcon
//        }
    }
    
    
    
    //        if cell {
    //            [tableView registerNib:[UINib nibWithNibName:@"DetailsCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
    //            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //        }
    //    cell.textLabel
    //Message msg = (self.messages)[indexPath.row]

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    

}
