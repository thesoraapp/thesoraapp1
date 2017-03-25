//
//  discoverViewController.swift
//  Mung
//
//  Created by Chike Chiejine on 01/10/2016.
//  Copyright © 2016 Color & Space. All rights reserved.
//

import UIKit
import Parse
import Alamofire
import AlamofireImage


class discoverViewController: UITableViewController {
    
    var discGoals = [goalsClass] ()
    
    
    var isLiked = [Bool]()
    var liked = false
    var didScroll = false
    var previousNavController = UINavigationController ()
    var tabNC: UINavigationController?
    let refreshImage = UIImageView()
    
    var refresh = UIRefreshControl()
    var indicator = UIActivityIndicatorView()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //XYZ
        fetchGoals()
        
        helpers().startActivityIndicator(sender:self, object: self.view, activityIndicator:indicator, position: "top", start: true)
        
        self.tableView.tableFooterView = UIView()
        
        // Add to Table View
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refresh
        } else {
            tableView.addSubview(refresh)
        }
        
        refresh.addTarget(self, action: Selector("fetchGoals"), for: UIControlEvents.valueChanged)
        refresh.backgroundColor = UIColor.clear
        refresh.tintColor = UIColor.lightGray
        refresh.addSubview(refreshImage)
        
        self.tableView.separatorInset = UIEdgeInsets.zero
        self.tableView.layoutMargins = UIEdgeInsets.zero
        //        self.tableView.separatorStyle = .none
        self.navigationController?.title = "Discover"
        
        let footerviewHeight = self.tableView.tableFooterView?.frame.height
        let footerviewWidth = self.tableView.tableFooterView?.frame.width
        
        
        
        for family: String in UIFont.familyNames
        {
            print("\(family)")
            for names: String in UIFont.fontNames(forFamilyName: family)
            {
                print("== \(names)")
            }
        }
        
        configureTableView()
        
    }
    
    
    func animateRefresh() {
        
        
    }
    
    
    
    
    func  configureTableView() {
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 235
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        self.view.resignFirstResponder()
        self.view.endEditing(true)
        
        
        
        self.navigationController?.navigationBar.isHidden = false
        
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        
        
        
    }
    
    
    func updateLikes(userObj: PFObject, goalObj: PFObject) {
        
        //update like count
        
        goalObj.incrementKey("goalLikes", byAmount: 1)
        goalObj.saveInBackground()
        
        //add relation
        let likes = PFObject(className: "likes")
        
        likes["likeGoalParent"] = goalObj
        likes["likeUserParent"] = userObj
        
        likes.saveInBackground{(success, error) in
            if success == true {
                print(" saved to parse")
            } else {
                print("save failed: \(error)")
            }
        }
    }
    
    func fetchGoals() {
        
        //XYZ
//        discGoals = []
        
        let users = PFQuery(className: "User")
        var goals = PFQuery(className: "goals")
        let likes = PFQuery(className: "likes")
        
        if let currentUser = PFUser.current() {
            print("currentuser")
            print(PFUser.current()!)
            
            
            likes.whereKey("likeUserParent", equalTo: currentUser)
            
        }
        
        var goalsArray = [PFObject]()
        
        goals.limit = 10
        
        //this will be 0 on first iteration
        //query.skip = 10*skipCount
        goals.includeKey("goalAuthor")
        goals.includeKey("userGoalAllocations")
        print("hoorayweresubquering22")
        goals.findObjectsInBackground { (objects, error) in
            print("FINDING IN BACKGROUND")
            // Put goals into object
            
            self.discGoals.removeAll(keepingCapacity: true)
            
            
            if error == nil {
                print(objects)
                goalsArray = objects!
                // Nested Query to find specific likes for given goals
                likes.whereKey("likeGoalParent", containedIn: goalsArray)
                likes.findObjectsInBackground { (objects, error) in
                    print(objects)
                    if error == nil && objects != nil {
                        for goal_ in goalsArray {
                            var didWeAppendTrue = false
                            for like_ in objects! {
                                let like_1 = like_["likeGoalParent"] as! PFObject
                                if goal_ == like_1 {
                                    self.isLiked.append(true)
                                    didWeAppendTrue = true
                                }
                            }
                            if didWeAppendTrue == false {
                                self.isLiked.append(false)
                            }
                            didWeAppendTrue = false
                        }
                        
                        
                        
                        //                        self.refreshImage.isHidden = true
                        self.refresh.endRefreshing()
                        helpers().startActivityIndicator(sender:self, object: self.view, activityIndicator:self.indicator, position: "top", start: false)
                        self.tableView.reloadData()
                    }
                    
                }} else {print(error)}
            
            for goal_ in goalsArray {
                print("we have our goals")
                print(goal_)
                
                //            if goal_ == goalsArray[2] {
                //
                //                goal_["goalImagePath"] = "https://s3-eu-west-1.amazonaws.com/cdn.thepostinternazionale.it/files/uploads/1-50orig_main.jpg"
                //                goal_.saveInBackground()
                //
                //            }
                
                self.discGoals.append(goalsClass(goal: goal_))
                
                
            }
            
            helpers().startActivityIndicator(sender: self, object:self.view, activityIndicator: self.indicator, position: "top", start: false)
            self.tableView.reloadData()
            helpers().tableFooter(sender: self.tableView)
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
        
        return self.discGoals.count
    }
    
    
    
    //   override func tab
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Get Cell and Index
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "goal", for: indexPath) as! goalViewCell
        let indexRow = (indexPath as NSIndexPath).row
        
        print("printhere")
        
        //Measurements
        
        let width = self.tableView.frame.width
        let height = cell.frame.height
        
        //Gradient Overlay
        
        //        cell.backgroundColor = UIColor.white
        cell.overlayGradient.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        cell.overlayGradient.locations = [0.0, 0.9]
        cell.overlayGradient.frame = CGRect(x: 0, y: 0, width: width, height: cell.goalImage.frame.height)
        
        let imageNamed = UIImage(named:"no-image-bg")
        cell.goalImage.layer.insertSublayer(cell.overlayGradient, at: 0)
        
        print("discGoals 2.a")
        print(discGoals)
        print("indexRow 2.a")
        print(indexRow)
        
        cell.goalAuthorName.setTitle(discGoals[indexRow].goalAuthorName, for: .normal)
        //        cell.goalAuthorProfile.setImage(UIImage(named: goalAuthorProfiles[indexRow]), for: .normal)
        cell.goalTitle.text = discGoals[indexRow].goalTitle
        
        
        // Set button targets
        
        cell.commentButton.addTarget(self, action:#selector(commentButton), for: .touchUpInside)
        cell.likeGoal.addTarget(self, action:#selector(likeButton), for: UIControlEvents.touchUpInside)
        cell.shareGoal.addTarget(self, action:#selector(shareGoal), for: UIControlEvents.touchUpInside)
        cell.likeAmount.addTarget(self, action: #selector(likeAmount), for: UIControlEvents.touchUpInside)
        cell.copyAmount.addTarget(self, action: #selector(copyAmount), for: UIControlEvents.touchUpInside)
        cell.goalAuthorName.addTarget(self, action:#selector(authorProfile), for: UIControlEvents.touchUpInside)
        cell.goalAuthorProfile.addTarget(self, action:#selector(authorProfile), for: UIControlEvents.touchUpInside)
        
        
        // Like button status appearance
        
        
        if self.isLiked.count > 0 {
            if self.isLiked[indexRow] {
                
                
                //Set up liked button state
                let likedButton = UIImage(named: "filledHeart-icon.png")?.withRenderingMode(.alwaysTemplate)
                cell.likeGoal.tintColor = UIColor(red:0.90, green:0.04, blue:0.20, alpha:1)
                cell.likeGoal.setImage(likedButton, for: UIControlState.normal)
                
            }
        }
        
        
        // Set Up button tags
        
        cell.commentButton.tag = indexRow
        cell.likeGoal.tag = indexRow
        cell.goalAuthorName.tag = indexRow
        cell.goalAuthorProfile.tag = indexRow
        cell.shareGoal.tag = indexRow
        cell.likeAmount.tag = indexRow
        cell.copyAmount.tag = indexRow
        
        
        
        if let imageprofile1 = URL(string: self.discGoals[indexRow].goalImagePath!) {
            
            cell.goalImage.af_setImage(withURL: imageprofile1, placeholderImage: UIImage(named:"no-image-bg"), filter: nil,imageTransition: .crossDissolve(0.2), runImageTransitionIfCached: true, completion: nil)
            
        }
        
        
        if let imageprofile2 = URL(string: self.discGoals[indexRow].goalAuthorImagePath!) {
            
            
            cell.goalAuthorProfile.af_setImage(for: UIControlState.normal, url: imageprofile2, placeholderImage: UIImage(named: "user-placeholder"), filter: nil, completion: nil)
            
        }
        
        
        //        URLSession.shared.dataTask(with: imageprofile1!) { (data, response, error) in
        //            if error != nil {
        //                } else {
        //               DispatchQueue.main.async {
        //                    cell.goalImage.image = UIImage(data: data!)
        //
        //
        //
        //                }
        //            }
        //        }.resume()
        
        
        
        
        return cell
        
        
    }
    
    
    //Like button target function
    
    func likeAmount(sender: UIButton) {
        
        
        print("Show like amounts")
        
        
    }
    
    func copyAmount(sender: UIButton) {
        
        
        print("Show copy amounts")
        
        
    }
    
    @IBAction func commentButton(_ sender: UIButton) {
        
        
        let nextvC = self.storyboard?.instantiateViewController(withIdentifier: "commentsView") as! commentsViewController
        
        nextvC.goalObject = self.discGoals[sender.tag]
   
        self.show(nextvC, sender: self)
        
    }
    
    
    func likeButton(sender: UIButton){
        // Get index from sender
        let indexRow = sender.tag
        if let currentUser = PFUser.current() {
            if currentUser == nil {
                //send to login
                let vC = self.storyboard?.instantiateViewController(withIdentifier: "loginView")
                self.show(vC!, sender: self)
            } else {
                if isLiked[indexRow] == true {
                    let likedQuery = PFQuery(className: "likes")
                    likedQuery.whereKey("likeUserParent", equalTo: PFUser.current()!)
                    likedQuery.whereKey("likeGoalParent", equalTo: discGoals[indexRow].goalObj!)
                    likedQuery.findObjectsInBackground { (goalobjects, error) in
                        if goalobjects != nil {
                            for goal_ in goalobjects! {
                                goal_.deleteInBackground()
                            }}}
                    isLiked[indexRow] = false
                    self.liked = false
                    let likedButton = UIImage(named: "linedHeart-icon.png")
                    sender.setImage(likedButton, for: UIControlState.normal)
                } else {
                    let likeObj = PFObject(className: "likes")
                    likeObj["likeUserParent"] = PFUser.current()!
                    likeObj["likeGoalParent"] = self.discGoals[indexRow].goalObj!
                    likeObj.saveInBackground()
                    isLiked[indexRow] = true
                    self.liked = true
                    
                    //Set up liked button state
                    
                    let likedButton = UIImage(named: "filledHeart-icon.png")?.withRenderingMode(.alwaysTemplate)
                    sender.tintColor = UIColor(red:0.90, green:0.04, blue:0.20, alpha:1)
                    sender.setImage(likedButton, for: UIControlState.normal)
                }}}}
    
    
    //Author profile target function
    
    
    func authorProfile(sender: UIButton){
        
        // Get index from sender
        
        let indexRow = sender.tag
        
        // Stop activity indicator whilst user is being signed up
        let vC = self.storyboard?.instantiateViewController(withIdentifier: "profileView") as! meViewController
        
        vC.selectedUser = discGoals[indexRow].goalAuthorObject
        
        if discGoals[indexRow].goalAuthorObject != PFUser.current() {
            vC.otherSelectedUser = true
            
        }
        self.show(vC, sender: self)
        
        
        
    }
    
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        print("I SELECTED!!!!!!!")
        
        //    let vC = self.storyboard?.instantiateViewControllerWithIdentifier("userProfile") as!  userProfileTableViewController
        //
        //
        //
        //    vC.selectedUserName = self.usernames[indexPath.row]
        //    //vC.selectedUser = self.users[indexPath.row]
        //    vC.isFollowing = self.isFollowing
        //    vC.wishBoneCounter  =  self.otherUserWishBoneCounter
        //    vC.userProfiles = self.userProfiles
        //
        //
        //    self.navigationController?.pushViewController(vC, animated: true)
        
    }
    
    
    
    
}




extension discoverViewController: UIViewControllerTransitioningDelegate{
    
    
    // Share goal target function
    
    
    func shareGoal(sender: UIButton){
        
        // Get index from sender
        
        let indexRow = sender.tag
        
        
        // Stop activity indicator whilst user is being signed up
        //        let vC = self.storyboard?.instantiateViewController(withIdentifier: "shareView") as! shareViewController
        //
        //        vC.view.frame = CGRect(x: 0, y: 120, width: self.view.frame.width, height: self.view.frame.height - 120)
        //
        //        vC.modalPresentationStyle = UIModalPresentationStyle.custom
        //        vC.transitioningDelegate = self
        //
        //        self.present(vC, animated: true, completion: nil)
        
        
        
        
        
        
        //        let textToShare = "Swift is awesome!  Check out this website about it!"
        //        if let myWebsite = NSURL(string: "http://www.codingexplorer.com/")
        //        {
        //            let objectsToShare = [textToShare, myWebsite] as [Any]
        //            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        //
        //            //            //New Excluded Activities Code
        //            //            activityVC.excludedActivityTypes = [UIActivityTypeAirDrop, UIActivityTypeAddToReadingList]
        //            //            //
        //
        //            self.present(activityVC, animated: true, completion: nil)
        //
        //        }
        
        
    }
    
    
}


//class HalfSizePresentationController : UIPresentationController {


// override func frameOfPresentedViewInContainerView() -> CGRect {
//   return CGRect(x: 0, y: 200, width: containerView!.bounds.width, height: 200)
//}


//}






