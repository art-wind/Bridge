//
//  RegisterViewController.swift
//  Bridge
//
//  Created by 许Bill on 15-2-18.
//  Copyright (c) 2015年 Fudan.SS. All rights reserved.
//

import UIKit

class RegisterViewController: UITableViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate {

    @IBOutlet var iconImageView: UIImageView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var usernameLabel: UITextField!
    @IBOutlet var passwordLabel: UITextField!
    @IBOutlet var nicknameLabel: UITextField!
    @IBOutlet var tagsLabel: UILabel!
    var tags:[String] = [String]()
    var vector = [Int]()
    @IBAction func cancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            
        })
    }
    var imagePickerActionFormTitle = "从何处选取照片"
    @IBAction func takePhotoAsIcon(sender: UIButton) {
        
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
        self.iconImageView.image = image
        //        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    }

    @IBAction func doneAction(sender: UIBarButtonItem) {
        
//        activityIndicator.startAnimating()
        let username = self.usernameLabel.text
        let password = self.passwordLabel.text
        let nickname = self.nicknameLabel.text
        let tags = self.tags
        
        let vectorHandler = VectorHandler()
        var doubleVector = self.vector.map({ (r) -> Double in
            //            return r as Double
            if r == 1 {
                return 1.0
            }
            else{
                return 0
            }
            
            
        })
        let vector = vectorHandler.formalize(vectorToBeFormalized: doubleVector)
        var signUpUser = PFUser()
        signUpUser.username = username
        signUpUser.password = password
        signUpUser["nickname"] = nickname
        signUpUser["tags"] = tags
        signUpUser["vector"] = vector
        
        let thumbnail = Thumbnail.thumbnailFromImage(self.iconImageView.image!,scaledToFillSize: CGSize(width: 100,height: 100))
        let imageData = UIImagePNGRepresentation(thumbnail)
        let imageFile = PFFile(name:"icon.png", data:imageData)
        signUpUser["icon"] = imageFile
        
        signUpUser.signUpInBackgroundWithBlock { (ok, error) -> Void in
            if error != nil {
                println("Register wrong")
            }
            else{
//                self.activityIndicator.stopAnimating()
                self.dismissViewControllerAnimated(true, completion: { () -> Void in
                    
                })
            }
        }
     
        
        
    }
    @IBAction func chooseCategory(sender: UIButton) {
    }
    @IBAction func unwindFromCatgorySelection(segue:UIStoryboardSegue){
        let categoryVC = segue.sourceViewController as CategoryTableViewController
        let fromVC = segue.sourceViewController as CategoryTableViewController

        
        self.vector = fromVC.selectedCategories
        var categories = Vector.getVectorList()
        
        var selectedCatgories = fromVC.selectedCategories
        if selectedCatgories.count == 0 {
            self.tagsLabel.text = ""
        }
        else{
            var catsToDisplay:NSMutableAttributedString?
            var seperateIndex = [Int]()
            var index = 0
            var stringToBeDisplayed:String = ""
            var length = categories.count
            println("L: \(length)")
            for index in 0..<length{
                if selectedCatgories[index] == 1{
                    stringToBeDisplayed += " \(categories[index])"
                    self.tags.append(categories[index])
                }
            }
            
           self.tagsLabel.text = stringToBeDisplayed
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
}
