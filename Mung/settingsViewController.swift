//
//  settingsViewController.swift
//  Mung
//
//  Created by Chike Chiejine on 13/02/2017.
//  Copyright © 2017 Color & Space. All rights reserved.
//

import UIKit
import Parse

class settingsViewController: UITableViewController, UIViewControllerTransitioningDelegate {
    
    
    var userObject = UserClass(userPFObject: nil, userPFUser: nil)

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Sign out
        
        if indexPath.section == 0 {
            
            if indexPath.row == 1  {
                
                //Log out
                PFUser.logOut()
                // No current user- Go to login view
                let vC = self.storyboard?.instantiateViewController(withIdentifier: "userAuth") as! userAuthViewController
                vC.modalPresentationStyle = UIModalPresentationStyle.custom
                vC.transitioningDelegate = self
                vC.statusBarShouldBeHidden = true
                let vcRoot = UINavigationController(rootViewController: vC)
                self.present(vcRoot, animated: true, completion: nil)
                
                
                NotificationCenter.default.post(name: Notification.Name(rawValue: "RefreshDiscover"), object: nil, userInfo: ["status": true])
                
                let nilUser = UserClass(userPFObject: nil, userPFUser: nil)
                NotificationCenter.default.post(name: Notification.Name(rawValue: "refreshToggled"), object: nil, userInfo: ["status": nilUser])
                
            }
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if let edit = segue.destination as? editProfileViewController{
            print("passalong111")
            edit.userObject = userObject
        }
        
    }
    

}
