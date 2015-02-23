//
//  CameraViewController.swift
//  Bridge
//
//  Created by 许Bill on 15-2-19.
//  Copyright (c) 2015年 Fudan.SS. All rights reserved.
//

import UIKit

class CameraViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate{

   
    @IBOutlet var imageTaken: UIImageView!
    var iPickerController:UIImagePickerController!
    override func viewDidLoad() {
        super.viewDidLoad()
        iPickerController = UIImagePickerController()
        iPickerController.delegate = self
        // Do any additional setup after loading the view.
    }
    @IBAction func takePhoto(sender: UIBarButtonItem) {
        
//        self.imageTaken.image = image!
        
//        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) == false{
//            println("Camera is not allowed")
//        }
//        
//        iPickerController.sourceType = UIImagePickerControllerSourceType.Camera
//
//        iPickerController.allowsEditing = true
//
//        presentViewController(iPickerController, animated: true) { () -> Void in
//            println("Camera Showed")
//        }
        
        
    }
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        
        self.dismissViewControllerAnimated(true){}
        println("sadsad")
        self.imageTaken.image = image
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        // editingInfo[UIImagePickerControllerOriginalImage] as? UIImage
    }
}
