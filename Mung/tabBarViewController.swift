//
//  tabBarViewController.swift
//  Mung
//
//  Created by Chike Chiejine on 12/10/2016.
//  Copyright © 2016 Color & Space. All rights reserved.
//

import UIKit
import Parse

class tabBarViewController: UIViewController, UIViewControllerTransitioningDelegate {
    
    
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet var buttons: [UIButton]!
    @IBOutlet weak var investButton: UIButton!
    

    var discoverController: UIViewController!
    var goalSetupController: UIViewController!
    var meViewController: UIViewController!
    

    var viewControllers: [UIViewController]!
    var selectedIndex: Int = 0
    
    
    @objc func notificationCancelAuth(notification: Notification) {
        if let userInfo = notification.userInfo, let status = userInfo["status"] as? Bool {
            self.didPressTab(buttons[0])
        } else {
            print("notification, no user info")
        }
    }


    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        //Get all button images
        
        let discoverImageSelected = UIImage(named: "Discover-Selected")
        let discoverImageUnselected = UIImage(named: "Discover-Unselected")
        
        let newImageSelected = UIImage(named: "New-Selected")
        let newImageUnselected = UIImage(named: "New-Selected")
        
        let meImageSelected = UIImage(named: "User-Selected")
        let meImageUnselected = UIImage(named: "User-Unselected")
        
        // Set all button images
        
        buttons[0].setImage(discoverImageSelected, for: UIControlState.selected)
        buttons[0].setImage(discoverImageUnselected, for: UIControlState.normal)

        investButton.setImage(newImageSelected, for: UIControlState.selected)
        investButton.setImage(newImageUnselected, for: UIControlState.normal)
        investButton.layer.cornerRadius = 5
        
        buttons[1].setImage(meImageSelected, for: UIControlState.selected)
        buttons[1].setImage(meImageUnselected, for: UIControlState.normal)

        let storyboard = UIStoryboard(name: "NewMain", bundle: nil)
        self.discoverController = storyboard.instantiateViewController(withIdentifier: "discoverRoot")
        self.meViewController = storyboard.instantiateViewController(withIdentifier:
            "meViewRoot")
        
        print("VIEW LOADING")
        self.viewControllers = [discoverController, meViewController]
        print("VIEW LOADING2")
        
        
        buttons[selectedIndex].isSelected = true
        buttons[selectedIndex].tintColor = UIColor(red:0.20, green:0.68, blue:0.89, alpha:1.0) //Light blue
        buttons[selectedIndex].setTitleColor(UIColor(red:0.20, green:0.68, blue:0.89, alpha:1.0), for: UIControlState.selected)
        self.didPressTab(buttons[selectedIndex])
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(notificationCancelAuth(notification:)), name: Notification.Name(rawValue: "authDismissToggled"), object: nil)
        
        
    }
    
    
    @IBAction func didPressTab(_ sender: UIButton) {
        
        print("ACTION")
        
        let previousIndex = selectedIndex
        selectedIndex = sender.tag
        
        buttons[previousIndex].isSelected = false
        let previousVC = viewControllers[previousIndex]
        previousVC.willMove(toParentViewController: nil)
        previousVC.view.removeFromSuperview()
        previousVC.removeFromParentViewController()
        
        buttons[previousIndex].setTitleColor(UIColor(red:0.67, green:0.67, blue:0.67, alpha:1.0) , for: UIControlState.normal)
        buttons[previousIndex].tintColor = UIColor(red:0.67, green:0.67, blue:0.67, alpha:1.0) // Light Grey
        
        sender.isSelected = true
        let vc = viewControllers[selectedIndex]
        addChildViewController(vc)
        vc.view.frame = contentView.bounds
        contentView.addSubview(vc.view)
        vc.didMove(toParentViewController: self)
        
        buttons[selectedIndex].setTitleColor(UIColor(red:0.20, green:0.68, blue:0.89, alpha:1.0), for: UIControlState.selected)
        buttons[selectedIndex].tintColor = UIColor(red:0.20, green:0.68, blue:0.89, alpha:1.0) //Light blue
        
    }
    
    
    @IBAction func investTab(_ sender: Any) {
        
        self.performSegue(withIdentifier: "tabGoalSetup", sender: self)
        
    }

    


    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
