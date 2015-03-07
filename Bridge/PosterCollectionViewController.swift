//
//  PosterCollectionViewController.swift
//  Bridge
//
//  Created by 许Bill on 15-2-18.
//  Copyright (c) 2015年 Fudan.SS. All rights reserved.
//

import UIKit
let reuseIdentifier = "Poster Cell"

class PosterCollectionViewController: UICollectionViewController {
    var posterSource:Activity?
    var posters = [Poster]()
    var isNormalUser = true
    override func viewDidLoad() {
        super.viewDidLoad()
        let parentVC = self.parentViewController
        
            let targetActivity = posterSource
            var queryThePosters:PFQuery  = PFQuery(className: "Poster")
//            queryThePosters.whereKey("PosterOf", equalTo: targetActivity)
            queryThePosters.findObjectsInBackgroundWithBlock({ (results, error) -> Void in
                println("COUNT: \(results.count)")
                for result in results {
                    self.posters.append( Poster(newPFObject:result as PFObject))
                }
                self.collectionView?.reloadData()
            })
       
        self.collectionView!.registerClass(PosterCellCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        let nib = UINib(nibName: "PosterCellCollectionViewCell", bundle: nil)
        self.collectionView!.registerNib(nib, forCellWithReuseIdentifier: reuseIdentifier)
        
        
        // Do any additional setup after loading the view.
       
    }

  
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        //#warning Incomplete method implementation -- Return the number of sections
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //#warning Incomplete method implementation -- Return the number of items in the section
        return isNormalUser ? self.posters.count : self.posters.count+1
    }
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> PosterCellCollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as PosterCellCollectionViewCell
        var indexRow = indexPath.row
        if isNormalUser == false {
            if indexPath.row == 0 {
                cell.poster.image = UIImage(named:"addPhoto_16-9")
                return cell
            }
            else{
                indexRow--
            }
        }
        let object = self.posters[indexRow]
        println("Another \(object)")
        let userImageFile: PFFile = object.image!
        userImageFile.getDataInBackgroundWithBlock {
            (imageData: NSData!, error: NSError!) -> Void in
            if error == nil {
                cell.poster.image = UIImage(data: imageData)
            }
            else{
                println("No picture for him")
            }
        }
       return cell
    }
    // MARK: UICollectionViewDelegate
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        
        let selectedCell = collectionView.cellForItemAtIndexPath(indexPath) as PosterCellCollectionViewCell
        println("\(indexPath.row) tapped!")

//        performSegueWithIdentifier("fireoff", sender: selectedCell)
        
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        let cell = sender as PosterCellCollectionViewCell
//        
//        if segue.identifier == "fireoff" {
////            var posterDetailVC = segue.destinationViewController as PosterDetailViewController
////            posterDetailVC.posterToDisplay = cell.poster.image
//        }
    }


}
