//
//  meViewController.swift
//  Mung
//
//  Created by Chike Chiejine on 30/09/2016.
//  Copyright © 2016 Color & Space. All rights reserved.
//

import UIKit



let offset_HeaderStop:CGFloat = 190.0 // At this offset the Header stops its transformations

//Author Information

class likedGoals {
    
    var goalImages = ["pic1.png", "pic3.png", "pic4.jpg", ]
    var goalTitles = ["Paris Summer Vacation", "Fashion Photography Equipment", "Summer 18 Gap Year Fund" ]
    var goalAuthorProfiles = ["pro1.jpg", "pro3.jpg", "pro4.jpg"]
    var goalAuthorNames = ["Amani Roy", "Jaslene Proctor", "Desmond Kramer"]
    var likedGoals = ["Amani Roy", "Jaslene Proctor", "Desmond Kramer"]
    
}

class myGoals {
    
    var goalImages = ["pic5.jpg", ]
    var goalTitles = ["Pilot School"]
    var goalAuthorProfiles = ["pro5.jpg"]
    var goalAuthorNames = ["Paige Richards"]
    var likedGoals = ["Amani Roy"]
    
}



class meViewController: UIViewController, SimpleTabsDelegate, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {
    
 
    
    
    var liked = false
    
    
    
    enum tablesForTabs {
        case likedGoals, myGoals
    }
    
    
    var contentToDisplay : tablesForTabs = .likedGoals
    var vc:SimpleTabsViewController!
    let tabContainerView = UIView()


    @IBOutlet weak var tableView: UITableView!
    let header = UIView()
    
    @IBOutlet var profileView: UIView!
    @IBOutlet var segmentView: UIView!
    @IBOutlet var profileImage: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
    
     
//        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        
        setupHeaderView()
        
        
        
        
        
        
        
        
        //Tabs Confiigure
        
        let tab1 = SimpleTabItem(title:"LIKED", count: 3)
        let tab2 = SimpleTabItem(title:"GOALS", count: 2)
        let tab3 = SimpleTabItem(title:"FOLLOWERS", count: 0)
        let tab4 = SimpleTabItem(title:"FOLLOWING", count: 0)
        vc = SimpleTabsViewController.create(self, baseView: tabContainerView, delegate: self, items: [tab1,tab2,tab3,tab4])
        vc.setTabTitleColor(UIColor(red:0.54, green:0.54, blue:0.54, alpha:1.0))
        vc.setNumberColor(UIColor(red:0.17, green:0.17, blue:0.17, alpha:1.0))
        vc.setNumberBackgroundColor(UIColor.clear)
        vc.setMarkerColor(UIColor(red:0.01, green:0.68, blue:0.88, alpha:1.0))
        vc.setTabTitleFont(UIFont(name: "Proxima Nova Soft", size: 12 )!)
        vc.setNumberFont(UIFont(name: "Proxima Nova Soft", size: 14 )!)
        
     

 
        
    
    }
    
    
    
    func setupHeaderView() {
        
    

        //Measurements 
        header.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 200)
        tableView.contentInset = UIEdgeInsetsMake(header.frame.height, 0, 0, 0)
        header.backgroundColor = UIColor.white
        let headerWidth = header.frame.width
        let headerHeight = header.frame.height
        let headerWidthCenter = headerWidth / 2
        let headerHeightCenter = headerHeight / 2
        //  Add Profile Image
        let profileImage = UIImageView()
        profileImage.frame = CGRect(x: headerWidthCenter - 40, y: headerHeightCenter - 80, width: 80, height: 80)
        profileImage.image = UIImage(named: "profile.jpg")
        profileImage.layer.cornerRadius = 40
        profileImage.layer.borderColor = UIColor.white.cgColor
        profileImage.layer.borderWidth = 3.0
        profileImage.clipsToBounds = true
        profileImage.contentMode = .scaleAspectFill
        header.addSubview(profileImage)
        
        // Add Profile Name
        
        let labelHalfWayPoint = headerWidthCenter - (headerWidth / 2) + 10
        
        let userName = UILabel()
        let lineHeight = userName.font.lineHeight
        userName.frame = CGRect(x: labelHalfWayPoint , y: headerHeight - 120 , width: headerWidth - 20, height: 21)
        userName.font = UIFont(name: "Proxima Nova Soft", size: 20 )
        userName.textColor = UIColor(red:0.17, green:0.17, blue:0.17, alpha:1.0)
        userName.textAlignment = .center
        userName.text = "Name"
        userName.lineBreakMode = .byWordWrapping
        userName.numberOfLines = 0
        header.addSubview(userName)
        tabContainerView.frame = CGRect(x: 0, y: headerHeight - 80, width: headerWidth, height: 80)
        header.addSubview(tabContainerView)
        self.view.addSubview(header)

        
        self.view.insertSubview(tableView, belowSubview: header)

        
        
        
    }


    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    // MARK: - ScrollView Delegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
  
        let offset = scrollView.contentOffset.y + header.bounds.height
        
        var headerTransform = CATransform3DIdentity
        
        
        // PULL DOWN -----------------
        
        if offset < 0 {
            
            let headerScaleFactor:CGFloat = -(offset) / header.bounds.height
            let headerSizevariation = ((header.bounds.height * (1.0 + headerScaleFactor)) - header.bounds.height)/2
            headerTransform = CATransform3DTranslate(headerTransform, 0, headerSizevariation, 0)
            headerTransform = CATransform3DScale(headerTransform, 1.0 + headerScaleFactor, 1.0 + headerScaleFactor, 0)
            
            // Hide views if scrolled super fast
            header.layer.zPosition = 0
            
        }
            
        // SCROLL UP/DOWN ------------
            
        else {
            
            // Header -----------
            
            
            headerTransform = CATransform3DTranslate(headerTransform, 0, max(-offset_HeaderStop, -offset), 0)
            
            
        }
        
        // Apply Transformations
        header.layer.transform = headerTransform


        
        
        
    }
    
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        switch contentToDisplay {
            case .likedGoals:
            
                let liked = likedGoals().likedGoals.count
            
                return liked
            
            case .myGoals:
            
                let goals = myGoals().likedGoals.count
            
                return goals
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let getLikedGoals = likedGoals()
        let getMyGoals = myGoals()
        

        //Get Cell and Index
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "goal", for: indexPath) as! goalViewCell
        let indexRow = (indexPath as NSIndexPath).row
        
        //Measurements
        
        let width = self.tableView.frame.width
        let height = cell.frame.height
        
        //Gradient Overlay
        
        cell.overlayGradient.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        cell.overlayGradient.locations = [0.0, 0.9]
        cell.overlayGradient.frame = CGRect(x: 0, y: 0, width: width, height: 300)
        cell.goalImage.layer.insertSublayer(cell.overlayGradient, at: 0)
        
        
        
        switch contentToDisplay {
            case .likedGoals:
            
            
            //Configure outlets
            
            cell.goalAuthorName.setTitle(getLikedGoals.goalAuthorNames[indexRow], for: .normal)
            cell.goalAuthorProfile.setImage(UIImage(named: getLikedGoals.goalAuthorProfiles[indexRow]), for: .normal)
            cell.goalTitle.text = getLikedGoals.goalTitles[indexRow]
            cell.goalImage.image = UIImage(named: getLikedGoals.goalImages[indexRow])
            
            case .myGoals:
            
            //Configure outlets
            
            cell.goalAuthorName.setTitle(getMyGoals.goalAuthorNames[indexRow], for: .normal)
            cell.goalAuthorProfile.setImage(UIImage(named: getMyGoals.goalAuthorProfiles[indexRow]), for: .normal)
            cell.goalTitle.text = getMyGoals.goalTitles[indexRow]
            cell.goalImage.image = UIImage(named: getMyGoals.goalImages[indexRow])
        
        
        }

        
        // Set button targets
        
        cell.likeGoal.addTarget(self, action:#selector(likeButton), for: UIControlEvents.touchUpInside)
        cell.goalAuthorName.addTarget(self, action:#selector(authorProfile), for: UIControlEvents.touchUpInside)
        cell.goalAuthorProfile.addTarget(self, action:#selector(authorProfile), for: UIControlEvents.touchUpInside)
        cell.shareGoal.addTarget(self, action:#selector(shareGoal), for: UIControlEvents.touchUpInside)
        
        // Set Up button tags
        
        cell.goalAuthorName.tag = indexRow
        cell.goalAuthorProfile.tag = indexRow
        cell.shareGoal.tag = indexRow
        
        
        
        return cell

    
    }
    
    
    
    
    
    //Like button target function
    
    
    func likeButton(sender: UIButton){
        
        
        // Get index from sender
        
        let indexRow = sender.tag
        
        
        // Liked Status
        
        if liked == true {
            
            //  Current user is unliking
            
            liked = false
            
            //Set up normal button state
            
            let likedButton = UIImage(named: "linedHeart-icon.png")
            sender.setImage(likedButton, for: UIControlState.normal)
            
            
        } else {
            
            //  Current user is liking
            
            liked = true
            
            //Set up liked button state
            
            let likedButton = UIImage(named: "filledHeart-icon.png")?.withRenderingMode(.alwaysTemplate)
            sender.tintColor = UIColor(red:0.90, green:0.04, blue:0.20, alpha:1)
            sender.setImage(likedButton, for: UIControlState.normal)
            
            
        }
        
        
    }
    
    //Author profile target function
    
    
    func authorProfile(sender: UIButton){
        
        // Get index from sender
        
        let indexRow = sender.tag
    }
    
    // Share goal target function
    
    
    func shareGoal(sender: UIButton){
        
        // Get index from sender
        
        let indexRow = sender.tag
        
        
        let textToShare = "Swift is awesome!  Check out this website about it!"
        if let myWebsite = NSURL(string: "http://www.codingexplorer.com/")
        {
            let objectsToShare = [textToShare, myWebsite] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            //            //New Excluded Activities Code
            //            activityVC.excludedActivityTypes = [UIActivityTypeAirDrop, UIActivityTypeAddToReadingList]
            //            //
            
            self.present(activityVC, animated: true, completion: nil)
            
        }
        
        
    }
    
    
    
    
    // MARK : - SimpleTabsDelegate
    
    func tabSelected(_ tabIndex:Int){
        
        
            if tabIndex == 0 {
                
                // Goals user has liked
            
                contentToDisplay = .likedGoals
                
            }  else if tabIndex  == 1 {
    
                // Users Goal
        
                contentToDisplay = .myGoals
        
        
            } else if tabIndex == 2 {
                
                // Go to list of people that follow
                
                let vC = self.storyboard?.instantiateViewController(withIdentifier: "userList") as! userListViewController
                
                vC.viewTitle = "Follower"
    
                self.navigationController!.pushViewController(vC, animated: true)
                
            } else if tabIndex == 3{
                
                // Go to list of people that following 
                
                let vC = self.storyboard?.instantiateViewController(withIdentifier: "userList") as! userListViewController
                
                vC.viewTitle = "Following"
                
                self.navigationController!.pushViewController(vC, animated: true)
                
                
        }
        
        tableView.reloadData()
        
    }
    
//            UIView.animate(withDuration: 0.5, animations: {
//                
// 
//
//  
//                
//            })
//        } else if tabIndex  == 1 {
//            
//            UIView.animate(withDuration: 0.5, animations: {
//                
//                self.discoverFeed.alpha = 0
//                self.newFeed.alpha = 1
//                self.anotherFeed.alpha = 0
//                
//            })
//            
//        } else {
//            
//            UIView.animate(withDuration: 0.5, animations: {
//                
//                self.discoverFeed.alpha = 0
//                self.newFeed.alpha = 0
//                self.anotherFeed.alpha = 1
//                
//            })
//            
//        }




}

