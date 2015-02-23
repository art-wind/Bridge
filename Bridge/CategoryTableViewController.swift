//
//  CategoryTableViewController.swift
//  Bridge
//
//  Created by 许Bill on 15-2-23.
//  Copyright (c) 2015年 Fudan.SS. All rights reserved.
//

import UIKit

class CategoryTableViewController: UITableViewController {
    // MARK: - Table view data source
    var categories = [String]()
    var selectedCategories = [String]()
    override func viewDidLoad() {
        categories = ["体育","音乐","文艺","品茶","欢喜"]
    }
//    func unwind
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return categories.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as UITableViewCell
        cell.textLabel?.text = categories[indexPath.row]
        cell.detailTextLabel?.text = categories[indexPath.row]
        // Configure the cell...
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = self.tableView.cellForRowAtIndexPath(indexPath)!
        if cell.accessoryType == UITableViewCellAccessoryType.None {
            selectedCategories.append(categories[indexPath.row])
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        }
        else{
            let title = cell.textLabel?.text
            var removeIndex = 0
            for index in 0...selectedCategories.count {
                if title == selectedCategories[index]{
                    removeIndex = index
                    break
                }
            }
            selectedCategories.removeAtIndex(removeIndex)
            cell.accessoryType = UITableViewCellAccessoryType.None
        }
        
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        println("\(indexPath.row) deselected!")
    }
    override func viewWillDisappear(animated: Bool) {
      println(self.selectedCategories)
      

    }
//    override func segueForUnwindingToViewController(toViewController: UIViewController, fromViewController: UIViewController, identifier: String?) -> UIStoryboardSegue {
//        var viewController = toViewController as CreateActivityViewController
//        viewController.displayLabels = self.selectedCategories
//        return UIStoryboardSegue(identifier: identifier, source: fromViewController, destination: toViewController)
//    }
    
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */
    

}
