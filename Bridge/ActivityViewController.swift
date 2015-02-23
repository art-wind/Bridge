//
//  ActivityViewController.swift
//  Bridge
//
//  Created by 许Bill on 15-2-22.
//  Copyright (c) 2015年 Fudan.SS. All rights reserved.
//

import UIKit
import Social
class ActivityViewController: UIViewController {
    
    @IBOutlet var customNaviBar: UINavigationBar!
    var shareViewShown:Bool?
    @IBAction func shareActivity(sender: UIBarButtonItem) {
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //        let shareItem = UIBarButtonItem(title: "分享", style: UIBarButtonItemStyle.Bordered, target: self, action: SelectorSelector(share:))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "分享", style: UIBarButtonItemStyle.Bordered, target: self, action: Selector("share:"))
        // Do any additional setup after loading the view.
    }
    func share (sender:UIBarButtonItem!){
        let scvc:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeSinaWeibo)
        scvc.setInitialText("我在关注#\(self.title) 欢迎来参与")
        let url:String = "http://baike.baidu.com/link?url=K9A8YNZcaUPWl17WcsZ15aZzfkPyREw1mbRB2_aKjLlVRa9NC05GzSdo4hZC5NWFufjGVuP8cBrP6YoeyMNSQw8AfZ6ws9qqjPjH8SqKlOy"
        scvc.addURL(NSURL(string: url))
        scvc.addImage(UIImage(named: "minion"))
        self.presentViewController(scvc, animated: true) { () -> Void in
            println("sakjdhkjsd")
        }
        
        scvc.completionHandler = {(result: SLComposeViewControllerResult) in
            if result == SLComposeViewControllerResult.Done {
                //                self.label.text = "Done with it "
            }
            else{
                if result == SLComposeViewControllerResult.Cancelled {
                    //                    self.label.text = "Canecel"
                }
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        self.navigationItem.rightBarButtonItem = nil
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
