//
//  Thumbnail.swift
//  Bridge
//
//  Created by 许Bill on 15-2-27.
//  Copyright (c) 2015年 Fudan.SS. All rights reserved.
//

import Foundation
import UIKit
class Thumbnail{
    class func thumbnailFromImage(image:UIImage,scaledToFillSize size:CGSize)->UIImage{
        let scale = max(size.width/image.size.width, size.height/image.size.height)
        let width = image.size.width * scale
        let height = image.size.width*scale
        let imageRect:CGRect = CGRect(x: (size.width - width)/2.0, y: (size.height - height)/2.0, width: width, height: height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        image.drawInRect(imageRect)
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}