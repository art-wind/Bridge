//
//  CreateActivityViewController.swift
//  Bridge
//
//  Created by 许Bill on 15-2-22.
//  Copyright (c) 2015年 Fudan.SS. All rights reserved.
//

import UIKit

class CreateActivityViewController: UIViewController,
        UITextFieldDelegate,UIActionSheetDelegate,
        UIImagePickerControllerDelegate,UINavigationControllerDelegate
    {

    @IBOutlet var formView: UIView!
    @IBOutlet var activityName: UITextField!
    @IBOutlet var activityPlace: UITextField!
    @IBOutlet var startDate: UITextField!
    @IBOutlet var duration: UITextField!
    @IBOutlet var frequency: UITextField!
    
    @IBOutlet var activityIcon: UIImageView!
    var startDatePicker:UIDatePicker! = UIDatePicker()
    var durationDatePicker:UIDatePicker! = UIDatePicker()
    var frequencyDatePicker:UIDatePicker! = UIDatePicker()
    var pickerMapping = ["start":false,"duration":false,"frequency":false]
    var inTheMiddleOfEdittingTime:Bool = false
    @IBOutlet var addPhoto: UIButton!
    @IBOutlet var categoryTextView: UITextView!
    
    @IBAction func clickToSaveTheDetails(sender: AnyObject) {
    }
    
    //Static properties
    var imagePickerActionFormTitle = "从何处选取照片"
    var frequencyPickerActionFormTitle = "频率为"
    var displayLabels = [String]()
    @IBAction func clickToSegue(sender: UIButton) {
        performSegueWithIdentifier("Choose category", sender: sender)
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Choose category" {
            println("Segue to another choice Tabel")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navigationItem.rightBarButtonItem = doneBarItem
        
        
        formView.layer.cornerRadius = 15
        formView.layer.masksToBounds = true
        
        
        
        //Initialize the date Pickers
        startDatePicker.datePickerMode = UIDatePickerMode.DateAndTime
        let nowDate:NSDate = NSDate()
        startDatePicker.minimumDate = nowDate
        startDatePicker.maximumDate = nowDate.dateByAddingTimeInterval(60*60*365)
        startDatePicker.minuteInterval = 15
        startDatePicker.addTarget(self, action: Selector("updateTextFieldForStartDate:"), forControlEvents:UIControlEvents.ValueChanged)
        
        durationDatePicker.datePickerMode = UIDatePickerMode.CountDownTimer
        durationDatePicker.minuteInterval = 15
        durationDatePicker.addTarget(self, action: Selector("updateTextFieldForDuration:"), forControlEvents:UIControlEvents.ValueChanged)
        

        
        
        //Add the controller Tool bars for those date controller
        var controlToolBoorForDatePicker = UIToolbar(frame: CGRect(origin:CGPoint(x: 0, y: 0), size: CGSize(width: self.view.frame.width, height: 40)))
        
        var cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Bordered, target: self, action: Selector("dismissTheDatePicker:"))
        var doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: self, action: nil)
        controlToolBoorForDatePicker.items = [cancelButton,doneButton]
        startDate.inputAccessoryView = controlToolBoorForDatePicker
        duration.inputAccessoryView = controlToolBoorForDatePicker
        frequency.inputAccessoryView = controlToolBoorForDatePicker
        
        frequency.addTarget(self,action: Selector("showFrequecyActionSheet:"), forControlEvents: UIControlEvents.EditingDidBegin)
        
        startDate.inputView = startDatePicker
        duration.inputView = durationDatePicker
        frequency.inputView = nil
        

        

        
        
        
        // Do any additional setup after loading the view.
    }
    func showFrequecyActionSheet(sender:UITextField!)
    {
        var actionForm = UIActionSheet(title: frequencyPickerActionFormTitle, delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: nil, otherButtonTitles: "每天","每周","每月")
        actionForm.showInView(self.view)
    }
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        if(actionSheet.title == frequencyPickerActionFormTitle){
            let choice = actionSheet.buttonTitleAtIndex(buttonIndex)
            frequency.text = choice
        }
    }
    
    
    func dismissTheDatePicker(sender:UIBarButtonItem!){
        if startDate.resignFirstResponder() == false {
            if duration.resignFirstResponder() == false {
                frequency.resignFirstResponder()
            }
        }
        
    }
    func updateTextFieldForStartDate(sender:UIBarButtonItem!){
        let date = startDatePicker.date
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        startDate.text = formatter.stringFromDate(date)
    }
    func updateTextFieldForDuration(sender:UIBarButtonItem!){
        let date = durationDatePicker.date
        let formatter = NSDateFormatter()
        formatter.dateFormat = "HH 小时 mm分钟"
//        duration.text = "\(date.)"
        duration.text = formatter.stringFromDate(date)
    }
    
    
    @IBAction func enterDate(sender: UITextField) {
        sender.backgroundColor = UIColor.yellowColor()
        if inTheMiddleOfEdittingTime {
//            sender.resignFirstResponder()
            inTheMiddleOfEdittingTime = false
        }
        else{
            inTheMiddleOfEdittingTime  = true
        }
    }
    
    @IBAction func unwindFromCategoryVC(segue:UIStoryboardSegue){
        let fromVC = segue.sourceViewController as CategoryTableViewController
        var selectedCatgories = fromVC.selectedCategories
        if selectedCatgories.count == 0 {
            self.categoryTextView.text = ""
        }
        else{
            var catsToDisplay:NSMutableAttributedString?
            var seperateIndex = [Int]()
            var index = 0
            var stringToBeDisplayed:String = ""
            for category in selectedCatgories {
                stringToBeDisplayed += category
            }
            catsToDisplay = NSMutableAttributedString(string: stringToBeDisplayed)
            
            catsToDisplay?.addAttribute(NSForegroundColorAttributeName, value: UIColor.blueColor(), range: NSMakeRange(0, 2))
//             catsToDisplay?.addAttribute(NSForegroundColorAttributeName, value: UIColor.greenColor(), range: NSMakeRange(3, 5))
            categoryTextView.attributedText = catsToDisplay
        }
        
    }
    override func viewWillAppear(animated: Bool) {
        
    }
    
    @IBAction func addPictureAsIcon(sender: UIButton!) {
        var actionForm = UIActionSheet(title: imagePickerActionFormTitle, delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: nil, otherButtonTitles: "Photo Library","Take a photo")
        actionForm.showInView(self.view)
    }
    func actionSheet(actionSheet: UIActionSheet, didDismissWithButtonIndex buttonIndex: Int) {
        println("Press at index : \(buttonIndex)")
        if actionSheet.title == imagePickerActionFormTitle {
            if buttonIndex == 0 {
                
            }
            else{
                var imagePickerController = UIImagePickerController()
                imagePickerController.delegate = self
                if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) == false {
                    UIAlertAction(title: "Camera is not availble in your device!", style: UIAlertActionStyle.Cancel)
                        {
                            result in
                            println("A disabled phone Detected")
                    }
                }
                
                if buttonIndex == 1 {
                    
                }
                if buttonIndex == 2 {
                    imagePickerController.sourceType = UIImagePickerControllerSourceType.Camera
                    imagePickerController.showsCameraControls = true
                    imagePickerController.allowsEditing = true
                }
                presentViewController(imagePickerController, animated: true, completion: { () -> Void in
                })
            }
            
        }
       
        
    }
    
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        
        self.dismissViewControllerAnimated(true){}
        println("sadsad")
        
        self.activityIcon.image = image
//        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    }
    
}
