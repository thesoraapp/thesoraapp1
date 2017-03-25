//
//  meViewHeader.swift
//  Mung
//
//  Created by Jake Dorab on 2/21/17.
//  Copyright © 2017 Color & Space. All rights reserved.
//

import Foundation
import UIKit
import Parse

class meViewHeader {

    func setupHeaderView(user: UserClass, header: UIView, otherSelectedUser: Bool, viewController: UIViewController, tabs: UIView) -> UIView {
        
        //Variables
      
        var profileImage = UIImageView()
        var userName = UILabel()
        
        //Measurements
        
        header.frame = CGRect(x: 0, y: 0, width: viewController.view.frame.width, height: 240)
        (viewController as! UICollectionViewController).collectionView?.contentInset = UIEdgeInsetsMake(header.frame.height, 0, 0, 0)
        header.backgroundColor = UIColor.white
        let headerWidth = header.frame.width
        let headerHeight = header.frame.height
        let headerWidthCenter = headerWidth / 2
        let headerHeightCenter = headerHeight / 2
        
        
        
        
        
        
        // Navbar
        
        if otherSelectedUser == false  {
            
            var titleView = UIView()
            
            titleView.frame = CGRect(x: 0, y: 0, width: 180, height: 40)
            
            //  Add Profile Image
            
            let UserInst = user
            
            if UserInst.userObj != nil {
                helperFuns().getImageData(urlString: UserInst.userImagePath, completion: { (userImage, error) in
                    profileImage.image = userImage
                    profileImage.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
                    profileImage.layer.cornerRadius = 20
                    profileImage.layer.borderColor = UIColor.white.cgColor
                    profileImage.backgroundColor = UIColor.lightGray
                    profileImage.layer.borderWidth = 2.0
                    profileImage.clipsToBounds = true
                    profileImage.contentMode = .scaleAspectFill
                    titleView.addSubview(profileImage)
                })
                
                userName.frame = CGRect(x: 50 , y: 10 , width: 120, height: 40)
                userName.font = UIFont(name: "Proxima Nova Soft", size: 16 )
                userName.textColor = .lightGray
                userName.textAlignment = .left
                userName.text = UserInst.userFullName!
                userName.sizeToFit()
                userName.lineBreakMode = .byTruncatingTail
                userName.numberOfLines = 0
                titleView.addSubview(userName)
                
                loadSavedSoFar(PFUserObj: user, header: header, viewController: viewController)
                viewController.navigationItem.titleView = titleView

            }
                
        } else {
            
            // Add Profile Image
            let UserInst = user
            helperFuns().getImageData(urlString: UserInst.userImagePath, completion: { (userImage, error) in
                profileImage.image = userImage
                profileImage.frame = CGRect(x: headerWidthCenter - 40, y: headerHeightCenter - 100, width: 80, height: 80)
                profileImage.layer.cornerRadius = 40
                profileImage.layer.borderColor = UIColor.white.cgColor
                profileImage.backgroundColor = UIColor.lightGray
                profileImage.layer.borderWidth = 3.0
                profileImage.clipsToBounds = true
                profileImage.contentMode = .scaleAspectFill
                header.addSubview(profileImage)
            })
            
            // Add Profile Name
            let labelHalfWayPoint = headerWidthCenter - (headerWidth / 2) + 10
            let lineHeight = userName.font.lineHeight
            userName.frame = CGRect(x: labelHalfWayPoint , y: headerHeightCenter  , width: headerWidth - 20, height: 21)
            userName.font = UIFont(name: "Proxima Nova Soft", size: 20 )
            userName.textColor = .gray
            userName.textAlignment = .center
            userName.text = UserInst.userFullName!
            userName.lineBreakMode = .byWordWrapping
            userName.numberOfLines = 0
            header.addSubview(userName)
        }
        header.tag = 100
        header.addSubview(tabs)
        viewController.view.addSubview(header)
//        let someView = (viewController as! UICollectionViewController).collectionView!
//        someView.tag = 101
//        viewController.view.insertSubview(someView, belowSubview: header)
        return header
    }
    

    func loadSavedSoFar(PFUserObj: UserClass, header: UIView, viewController: UIViewController) {
        
        
        let UserInst = PFUserObj
        
        
        let headerWidth = header.frame.width
        
        // BIG NUMBER
        let bigNumber = UILabel()
        bigNumber.frame = CGRect(x: 20, y: header.center.y - 100, width: viewController.view.frame.width - 40, height: 90)
        bigNumber.font = UIFont(name: "HelveticaNeue-UltraLight", size: 70 )
        bigNumber.textColor = .gray
        bigNumber.textAlignment = .center
        bigNumber.text = String(describing: UserInst.userTotalSaved!)
        bigNumber.lineBreakMode = .byWordWrapping
        bigNumber.numberOfLines = 0
        header.addSubview(bigNumber)
        
        let numberLabel = UILabel()
        numberLabel.frame = CGRect(x: header.center.x - 50, y: bigNumber.frame.origin.y + 90, width: 100, height: 30)
        numberLabel.font = UIFont(name: "Proxima Nova Soft", size: 12)
        numberLabel.textColor = .lightGray
        numberLabel.textAlignment = .center
        numberLabel.text = "TOTAL SAVED"
        numberLabel.lineBreakMode = .byWordWrapping
        numberLabel.numberOfLines = 0
        
        header.addSubview(numberLabel)
        
    }
}
