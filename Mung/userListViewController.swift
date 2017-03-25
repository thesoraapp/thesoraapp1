//
//  userListViewController.swift
//  Mung
//
//  Created by Chike Chiejine on 14/10/2016.
//  Copyright © 2016 Color & Space. All rights reserved.
//

import UIKit
import Parse

class userListViewController: UITableViewController {
    
    var viewTitle = String()
    var usersList = [UserClass?]()
    var changed : Bool?
    
    @IBOutlet weak var navTitle: UINavigationItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navTitle.title  = viewTitle
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 300
        tableView.tableFooterView = UIView()
    }

    @IBAction func followTapped(_ sender: UIButton) {
        followTappedC(sender as! UIButton)
    }
    
    
    func followTappedC(_ sender: UIButton) {
        sender.isEnabled = false
        UserClass().toggleFollow(givenUser: usersList[sender.tag]?.userObj, perspective: PFUser.current(), completion: { followed, error in
            if error != nil {
                // Show error...
                
            }
            if followed! {
                self.setFollowButton(sender: sender, following: true)
            } else {
                self.setFollowButton(sender: sender, following: false)
            }
            sender.isEnabled = true
        })
    }
    
    
    func setFollowButton(sender: UIButton, following: Bool) {
        
        if following == true {
            let followingIcon = UIImage(named: "tick-icon.png")
            sender.setTitle("", for: UIControlState.normal)
            sender.frame.size = CGSize(width: 30, height: sender.frame.height)
            sender.setImage(followingIcon, for: UIControlState.normal)
            sender.backgroundColor = UIColor(red:0.01, green:0.68, blue:0.88, alpha:1.0)

        } else {
            
            let noFollowingIcon = UIImage(named: "plus-icon.png")
            sender.setImage(noFollowingIcon, for: UIControlState.normal)
            sender.backgroundColor = UIColor.clear
            sender.layer.borderColor = UIColor(red:0.80, green:0.80, blue:0.80, alpha:1.0).cgColor
            sender.layer.borderWidth =  1
            sender.titleLabel?.textColor = UIColor.soraDarkGrey()
            sender.tintColor = UIColor(red:0.67, green:0.67, blue:0.67, alpha:1.0)
            sender.setTitle("Follow", for: UIControlState.normal)
        
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return usersList.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let userCell = tableView.dequeueReusableCell(withIdentifier: "user", for: indexPath) as! userViewCell
            let indexrow = indexPath.row
            let userTemp = self.usersList[indexrow]
        
            userCell.userName.text = userTemp?.username
        
            helperFuns().getImageData (urlString: (userTemp?.userImagePath!), completion: { (Image, error) in
                userCell.userProfile.image = Image
            })
            
            print("userOBJIn")
            print(usersList[indexrow]?.userObj)
        
            UserClass().isFollowed(givenUser: usersList[indexrow]?.userObj, perspective: PFUser.current(), completion: {
                isFollowed, error in
                if isFollowed! {
                    self.setFollowButton(sender: userCell.followButton, following: true)
                } else {
                    self.setFollowButton(sender: userCell.followButton, following: false)
                }
            })
            userCell.followButton.tag = indexrow
            return userCell
    }
}
