//
//  extendUIColor.swift
//  Mung
//
//  Created by Chike Chiejine on 13/02/2017.
//  Copyright © 2017 Color & Space. All rights reserved.
//

import Foundation
import UIKit



extension UIColor{
    
    // Sora Blue
    class func soraBlue() -> UIColor{
        return UIColor(red:0.01, green:0.68, blue:0.88, alpha:1.0) //Done
    }
    
    //Sora light grey
    
    class func soraGrey() -> UIColor{
        return UIColor(red:0.71, green:0.71, blue:0.71, alpha:1.0)
    }
    
    //Sora dark grey
    
    class func soraDarkGrey() -> UIColor{
        return UIColor(red:0.043, green:0.576 ,blue:0.588 , alpha:1.00)
    }
    
    //Sora heart red
    
    class func soraHeartRed() -> UIColor{
        return UIColor(red:0.90, green:0.04, blue:0.20, alpha:1) // Done
    }
    
    // Sora green 
    
    class func soraGreen() -> UIColor{
        return UIColor(red:0.40, green:0.80, blue:0.20, alpha:1.0) // Done
    }

    
    
}



extension UIView {
    
    func dropShadow() {
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: -1, height: 1)
        self.layer.shadowRadius = 1
        
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
    }
}
