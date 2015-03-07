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
    var selectedCategories = [Int]()
    override func viewDidLoad() {
        self.categories = Vector.getVectorList()
        let count = self.categories.count
        for i in 0..<count {
            self.selectedCategories.append(0)
        }
        self.clearsSelectionOnViewWillAppear = false
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

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = self.tableView.cellForRowAtIndexPath(indexPath)!
        if cell.accessoryType == UITableViewCellAccessoryType.None {
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        }
        else{
            cell.accessoryType = UITableViewCellAccessoryType.None
        }
        let flipCoin = self.selectedCategories[indexPath.row]
        self.selectedCategories[indexPath.row] = (flipCoin == 1 ? 0:1)
        
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        println("\(indexPath.row) deselected!")
    }
    override func viewWillDisappear(animated: Bool) {
      println(self.selectedCategories)
      

    }
    

}
