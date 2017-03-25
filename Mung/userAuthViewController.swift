//
//  userAuthViewController.swift
//  Mung
//
//  Created by Chike Chiejine on 15/10/2016.
//  Copyright © 2016 Color & Space. All rights reserved.
//

import Foundation
import Parse

class userAuthViewController: UIViewController {
    
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var mungMotto: UILabel!
    @IBOutlet weak var logo: UIImageView!
    
    var statusBarShouldBeHidden = false
    
    var cameFromInvest = false
    
    
    // to be called from Login View
    @objc func notificationAuthDismiss(notification: Notification) {
        if let userInfo = notification.userInfo, let status = userInfo["status"] as? Bool {
            self.navigationController?.presentingViewController?.dismiss(animated: true, completion: nil)
            
        } else {
            print("notification, no user info")
        }
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        var userInfo = [String: Bool]()
        
        print("authcamefrominvest")
        print(self.cameFromInvest)
        
        if cameFromInvest == true {
            userInfo = ["status": true, "cameFromInvest": true]
        } else {
            userInfo = ["status": true, "cameFromInvest": false]
        }
        
        print("VCORDER")
        print(self.navigationController?.viewControllers)
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "authDismissToggled"), object: nil, userInfo: userInfo)
        
        self.navigationController?.presentingViewController?.dismiss(animated: true, completion: nil)
        
        
        //Goran dismiss
        //        self.navigationController?.presentingViewController?.dismiss(animated: true, completion: nil)
        
        
        // Stop activity indicator whilst user is being signed up
        //        let vC = self.storyboard?.instantiateViewController(withIdentifier: "home")
        //        self.resignFirstResponder()
        //        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        //        appDelegate.window?.rootViewController = vC
        
    }
    
    
    @IBAction func signupButton(_ sender: AnyObject) {
        
        let vC = self.storyboard?.instantiateViewController(withIdentifier: "loginView")
        self.navigationController?.show(vC!, sender: self)
        
    }
    
    let overlayGradient = CAGradientLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        logo.image = UIImage(named: "logo-sora.pdf")
        logo.layer.masksToBounds = true
        mungMotto.text = "INVEST IN YOUR DREAMS"
        backgroundImage.image = UIImage(named: "festival.jpg")
        loginButton.layer.cornerRadius = 5
        signUpButton.layer.cornerRadius = 5
        
        
        //Gradient Overlay
        
        let width = self.view.frame.width
        let height = self.view.frame.height
        overlayGradient.colors = [UIColor.clear.cgColor, UIColor(red:0.01, green:0.11, blue:0.23, alpha:0.7).cgColor]
        overlayGradient.locations = [0.0, 0.7]
        overlayGradient.frame = CGRect(x: 0, y: 0, width: width, height: height)
        self.backgroundImage.layer.insertSublayer(overlayGradient, at: 0)
        
        NotificationCenter.default.addObserver(self, selector: #selector(notificationAuthDismiss(notification:)), name: Notification.Name(rawValue: "authDismiss"), object: nil)
        
    }
    
    
    override var prefersStatusBarHidden: Bool {
        get {
            return statusBarShouldBeHidden
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        print(self.view.frame.width)
        
        // Do any additional setup after loading the view.
        
        let buttonWidth = loginButton.frame.width
        let buttonHeight = loginButton.frame.height
        let buttonImageHeight = (loginButton.imageView?.frame.height)! / 2
        let yCenter = (buttonHeight / 2) + buttonImageHeight
        let xPos = 15
        
        
        if self.view.frame.width == 320 {
            
            loginButton.titleEdgeInsets = UIEdgeInsetsMake(yCenter, -18, yCenter, 10)
            
            let buttonImageWidth = (loginButton.imageView?.frame.width)!
            let yCenter = (buttonHeight / 2) + buttonImageHeight
            let xPos = buttonWidth - buttonImageWidth - 30
            loginButton.imageEdgeInsets = UIEdgeInsetsMake(yCenter, xPos, yCenter, 0)
            
        }
        
        if self.view.frame.width == 375 {
            
            loginButton.titleEdgeInsets = UIEdgeInsetsMake(yCenter, -10, yCenter, 0)
            
            let buttonImageWidth = (loginButton.imageView?.frame.width)!
            let yCenter = (buttonHeight / 2) + buttonImageHeight
            let xPos = buttonWidth - buttonImageWidth - 15
            loginButton.imageEdgeInsets = UIEdgeInsetsMake(yCenter, xPos, yCenter, 0)
            
        }
        
        if self.view.frame.width == 414 {
            
            let buttonImageWidth = (loginButton.imageView?.frame.width)!
            let yCenter = (buttonHeight / 2) + buttonImageHeight
            let xPos = buttonWidth - buttonImageWidth - 10
            loginButton.imageEdgeInsets = UIEdgeInsetsMake(yCenter, xPos, yCenter, 0)
            
            
        }
        
        self.navigationController?.navigationBar.isHidden = true
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    
    
    
    
}
