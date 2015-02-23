//
//  PosterDetailViewController.swift
//  Bridge
//
//  Created by 许Bill on 15-2-22.
//  Copyright (c) 2015年 Fudan.SS. All rights reserved.
//

import UIKit

class PosterDetailViewController: UIViewController {

    @IBOutlet var scrollView: UIScrollView!
//    @IBOutlet var posterDetail: UIImageView!
    var posterToDisplay:UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()
        var posterDetail:UIImageView =  UIImageView(image: self.posterToDisplay!)
        println("\(self.posterToDisplay!)")
        self.scrollView.contentSize = posterDetail.frame.size
        self.scrollView.scrollEnabled = true
        
        posterDetail.setNeedsDisplay()
        self.scrollView.setNeedsDisplay()
        self.scrollView.addSubview(posterDetail)
        
        // Do any additional setup after loading the view.
        self.navigationController!.title = "This is a template poster of it"
        self.title = "This is a template poster of it"
//        println(self.navigationController?.title)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
