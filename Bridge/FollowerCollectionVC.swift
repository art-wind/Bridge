//
//  FollowerCollectionVC.swift
//  Bridge
//
//  Created by 许Bill on 15-2-28.
//  Copyright (c) 2015年 Fudan.SS. All rights reserved.
//

import UIKit


class FollowerCollectionVC: UICollectionViewController {
    let reuseIdentifier = "Cell"
    var followersForActivity:Activity = Activity()
    var users = [User]()
    var selectedUser:User?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.registerClass(ThumbnailForUserCVCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        let nib = UINib(nibName: "ThumbnailForUserCVCell", bundle: nil)
        self.collectionView!.registerNib(nib, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
        let query:PFQuery = PFQuery(className: "FollowUp")
        query.whereKey("Channel",equalTo:PFObject(withoutDataWithClassName: "Activity", objectId: self.followersForActivity.ID))
        query.findObjectsInBackgroundWithBlock { (results, error) -> Void in
            for result in results{
                let user = User(newPFUser:result["Follower"] as PFUser)
                self.users.append(user)
            }
            self.collectionView?.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        return users.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as ThumbnailForUserCVCell
        let user = users[indexPath.row] as User
        let imageData = user.imageIcon as PFFile?
        imageData?.getDataInBackgroundWithBlock({ (data, error) -> Void in
            cell.iconThumbnail.image = UIImage(data: data)
        })
        cell.usernameLabel.text = user.nickname
        println(user.nickname )
        println(user )
        return cell
    }
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let rowIndex = indexPath.row
        self.selectedUser = self.users[rowIndex]
//        performSegueWithIdentifier("Check User Detail", sender: self)
        let friendDetailVC = FriendDetailViewController()
        friendDetailVC.relatedUser = self.selectedUser
        self.navigationController?.pushViewController(friendDetailVC, animated: true)
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Check User Detail"{
            let friendDetailVC = segue.destinationViewController as  FriendDetailViewController
            friendDetailVC.relatedUser = self.selectedUser
        }
        
    }
   

}
