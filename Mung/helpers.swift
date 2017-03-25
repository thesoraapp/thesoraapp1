//
//  helpers.swift
//  Mung
//
//  Created by Chike Chiejine on 13/01/2017.
//  Copyright © 2017 Color & Space. All rights reserved.
//

import Foundation
import UIKit
import Parse




class helpers {
    
    
    // Animation Styles
    public enum position {
        case  left, right, top, bottom
    }
    
    
    func hideElementsForNonCurrent(element: UIView ) {
        
        if PFUser.current() == nil {
            
            element.isHidden = true
            
        } else {
            
            element.isHidden = false
            
        }
        
    }
    
    
    
    
    func soraUserAlert(view: UIViewController, string : String = "", positive: Bool = false, remove : Bool = true ) {
        
        let soraUserAlert = UIView()
        let alertLabel = UILabel()
        soraUserAlert.alpha = 0
        soraUserAlert.frame = CGRect(x: 0, y: 0, width: view.view.bounds.width, height: 60)
        soraUserAlert.backgroundColor = UIColor.soraHeartRed()
        
        
        
        alertLabel.frame = soraUserAlert.frame
        alertLabel.frame.size.height = soraUserAlert.frame.height - 15
        alertLabel.frame.origin.x = 10
        alertLabel.frame.origin.y = soraUserAlert.frame.origin.y + 15
        alertLabel.text = string
        alertLabel.frame.size.width = soraUserAlert.frame.width - 20
        alertLabel.font = UIFont(name: "Proxima Nova Soft", size: 14)
        alertLabel.textColor = .white
        
        soraUserAlert.addSubview(alertLabel)
        let windowCount = UIApplication.shared.windows.count
        UIApplication.shared.windows[windowCount - 1].addSubview(soraUserAlert)
//        view.view.addSubview(soraUserAlert)
        
//        if view.navigationController?.navigationBar != nil {
//            
//            soraUserAlert.frame = CGRect(x: 0, y: (view.navigationController?.navigationBar.frame.height)! + 10, width: view.view.bounds.width, height: 40)
//        }
        
        if positive == true {
            
            soraUserAlert.backgroundColor = UIColor.soraGreen()
            
        }
        
        if remove == true {
            
            
            soraUserAlert.removeFromSuperview()
            
        }
        
        UIView.animate(withDuration: 0.5, animations: {
            
            soraUserAlert.alpha = 1
            
        }) { (true) in
            
            UIView.animate(withDuration: 0.5, delay: 3, options: UIViewAnimationOptions.curveEaseInOut, animations: {
                
                soraUserAlert.alpha = 0
            }) { (true) in
                
                soraUserAlert.alpha = 1
                soraUserAlert.removeFromSuperview()
            }
            
        }
  
        
    }
    
    
    func refStoryboards(name: String) -> UIStoryboard {
        
        var GoalSetup: UIStoryboard!
        GoalSetup = UIStoryboard(name: name, bundle: nil)
        
        return GoalSetup
        
    }
    
    
    func addGradientLayer(element: UIView , overlay: CAGradientLayer )  {
        
        
        overlay.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        overlay.locations = [0.0, 0.9]
        overlay.frame = CGRect(x: 0, y: 2, width: element.frame.width + 40, height: element.frame.height)
        element.layer.insertSublayer(overlay, at: 0)
        
    }
    
    
    func cornerRadius(element: UIView) -> UIView{
        
        element.layer.cornerRadius = 5
        element.layer.masksToBounds = true
        
        if let element = element as? UIButton {
            
            element.imageView?.contentMode = .scaleAspectFill
        }
        
        
        return element
        
        
    }
    
    
    func roundCorners(element: UIView) -> UIView{
        
        let radius = element.frame.width / 2
        
        element.layer.cornerRadius = radius
        element.layer.masksToBounds = true
        
        if let element = element as? UIButton {
            
            element.imageView?.contentMode = .scaleAspectFill
        }
        
        
        return element
        
        
    }
    
    
    func progressBar(view: UIViewController, currentStep: Int, progressBar: UIView, next: Bool) -> UIView {
        
//        let progressBar = UIView()
        let steps = Int(view.view.frame.width / 4)
        
        // Set Up progress line
        progressBar.frame = CGRect(x: 0, y:(view.navigationController?.navigationBar.frame.height)! + 20, width:0, height: 3)
        progressBar.backgroundColor = UIColor(red:0.20, green:0.68, blue:0.89, alpha:1.0) //Light blue
        
        let windowCount = UIApplication.shared.windows.count
        
        
        let currentProgressWidth = CGFloat(steps * currentStep)

        if let currentstep = CGFloat(currentStep * steps) as? CGFloat {

            if next == true {
                
                print("tester")

                //Next
                
                progressBar.frame = CGRect(x: 0, y: progressBar.frame.origin.y, width: currentProgressWidth - CGFloat(steps), height:  progressBar.frame.height)
                
                UIView.animate(withDuration: 0.5, animations: {
                    
                    progressBar.frame = CGRect(x: 0, y: progressBar.frame.origin.y, width: currentstep, height:  progressBar.frame.height)
                    
                })
                
                
            } else {

                //Previous
                
                print("tester222")
                
                UIView.animate(withDuration: 0.1, animations: {
                    
                    progressBar.isHidden = false
                    progressBar.frame = CGRect(x: 0, y: progressBar.frame.origin.y, width: currentProgressWidth - CGFloat(steps), height:  progressBar.frame.height)
                    
                })
            }
        }
        
        print(progressBar)
//        UIApplication.shared.windows[0].addSubview(progressBar)
//        view.view.addSubview(progressBar)
        
        return progressBar
        
        
    }
    
    
    
    func backButton(sender:UIViewController ) -> UIBarButtonItem {
        
        let viewController = sender
        
        var backButtonImage = UIImage(named: "arrow-icon")
        let newBackButton = UIBarButtonItem(image: backButtonImage, style: UIBarButtonItemStyle.plain, target: viewController, action: "goBack")
        viewController.navigationItem.leftBarButtonItem = newBackButton
        
        //        viewController.navigationController?.popViewController(animated: true)
        
        return viewController.navigationItem.leftBarButtonItem!
        
    }
    
    
    
    func tableFooter(sender: UITableView) -> UIView {
        
        let viewController = sender
        
        // Table Footer
        
        let footerView = UIView()
        footerView.frame = CGRect(x: 0, y: 0, width: viewController.frame.width, height: 90 )
        footerView.backgroundColor = .white
        let footerLogo = UIImageView()
        footerLogo.image = UIImage(named: "logo-icon-vector")
        footerLogo.tintColor = UIColor(red:0.78, green:0.76, blue:0.76, alpha:1.0)
        footerLogo.frame = CGRect(x: (viewController.frame.width / 2) - 16, y: (footerView.frame.height / 2) - 16, width: 32, height: 32 )
        footerView.addSubview(footerLogo)
        viewController.tableFooterView?.tag = 10
        viewController.tableFooterView = footerView
        
        return sender.tableFooterView!
        
    }
    
    
    
    func startActivityIndicator(sender:UIViewController, object: UIView, activityIndicator: UIActivityIndicatorView, position: String = "", start: Bool) -> UIActivityIndicatorView {
        
        print("Indicator")
        
        let superview = object.superview
        
        
        var xPos = CGFloat()
        var yPos = CGFloat()
        
        
        
        if position == "right"  {
            
            xPos = object.frame.origin.x +  object.frame.width + 20
            yPos = object.frame.origin.y + (object.frame.height / 2) - 22.5
            
        } else if position == "left" {
            
            xPos = object.frame.origin.x - 20
            yPos = object.frame.origin.y + (object.frame.height / 2) - 22.5
            
        } else if position == "center" {
            
            xPos = object.center.x - 22.5
            yPos = object.center.y
            
        } else if position == "top" {
            
            xPos = object.center.x - 22.5
            yPos = (sender.navigationController?.navigationBar.frame.height)! + 20
            
        }
        
        activityIndicator.frame = CGRect(x: xPos, y:
            yPos, width: 45, height: 45)
        
        activityIndicator.backgroundColor = .clear
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        
        if position != "top" {
            
            superview?.addSubview(activityIndicator)
            
        } else {
            
            object.addSubview(activityIndicator)
            
        }
        
        
        if start {
            
            activityIndicator.startAnimating()
            
        } else {
            
            activityIndicator.stopAnimating()
            
        }
        
        
        return activityIndicator
        
    }
    
    
    
    
    
    
    
    
    
    
    
}
