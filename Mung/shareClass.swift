//
//  shareClass.swift
//  Mung
//
//  Created by Chike Chiejine on 26/02/2017.
//  Copyright © 2017 Color & Space. All rights reserved.
//

import Foundation







extension UIApplication {
    
    var screenShot: UIImage?  {
        
        if let rootViewController = keyWindow?.rootViewController {
            
            let scale = UIScreen.main.scale
            let bounds = rootViewController.view.bounds
            
            UIGraphicsBeginImageContextWithOptions(bounds.size, false, scale)
            if let _ = UIGraphicsGetCurrentContext() {
                rootViewController.view.drawHierarchy(in: bounds, afterScreenUpdates: true)
                let screenshot = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                return screenshot
            }
        }
        return nil
    }
}




class shareClass {
    
    
    
    func sharePopUp(viewController: UIViewController, sender: UIButton){
    
        let indexRow = sender.tag
        let textToShare = "Swift is awesome!  Check out this website about it!"
        if let myWebsite = NSURL(string: "http://www.codingexplorer.com/")
        {
            let objectsToShare = [textToShare, myWebsite] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            viewController.present(activityVC, animated: true, completion: nil)
        }

    
    }
    
    
    
    
}
