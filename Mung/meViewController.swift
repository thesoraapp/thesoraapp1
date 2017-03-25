//
//  meViewController.swift
//  Mung
//
//  Created by Chike Chiejine on 30/09/2016.
//  Copyright © 2016 Color & Space. All rights reserved.
//

import UIKit
import Parse
import Alamofire
import AlamofireImage




// Blue UIColor(red:0.20, green:0.68, blue:0.89, alpha:1.0)

// let offset_HeaderStop:CGFloat = 190.0

class meViewController: UIViewController,  UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, UIViewControllerTransitioningDelegate {
    
    
    let offset_HeaderStop:CGFloat = 190.0
    
    var likedgoals = [goalsClass] ()
    var myGoals = [goalsClass] ()
    
    typealias magicUser = (user_: PFObject, bool_: Bool)
    var myFollowers: [magicUser] = []
    var myFollowed: [magicUser] = []
    
    //From Author profile thumb
    
    var selectedUser: PFUser?
    var otherSelectedUser = false
    
    @IBOutlet weak var leftBarButton: UIBarButtonItem!
    
    
    
    
    //createSecHeader()
    
    var followsYou = false
    var liked = false
    var followerCount = Int()
    var followingCount = Int()
    var profileImageURL = String()
    var editButton = UIButton()
    var headerBG = UIImageView()
    
    let tab1 = UIButton()
    let tab2 = UIButton()
    let tab3 = UIButton()
    let tab4 = UIButton()
    
    var tabWidth : Int?
    var tabItemWidth: Int?
    var tab1Position: Int?
    var tab2Position: Int?
    var tab3Position: Int?
    var tab4Position: Int?
    let bottomBorderLine = UIView()
    
    let goalsLabel = UILabel()
    let likedLabel = UILabel()
    let followersLabel = UILabel()
    let followingLabel = UILabel()
    
    
    // Data
    
    var goalImageURLs = [String]()
    var goalImages = [UIImage]()
    var goalAuthorImages = [UIImage]()
    var goalTitles = [String]()
    var goalTotalSaved = [Float]()
    var goalCurAlloc = [Int]()
    var goalRemainAmount = [Double]()
    var goalCurTimeLeft = [Double]()
    var goalPrettyTimeLeft = [String]()
    var goalTargetAmount = [Double]()
    var goalEndDate = [Date] ()
    var goalCurDepositRate = [Int]()
    var goalPercComplete = [Double]()
    var prevGoal: PFObject?
    //var selectedGoal = [PFObject]()
    
    var profileUser: PFUser?
    
    private var animationProgress: UInt8 = 0
    
    var percAngle: Double?
    
    let footerView = UIView()
    var indicator = UIActivityIndicatorView()
    
    
    enum tablesForTabs {
        case  myGoals, likedGoals
    }
    
    var contentToDisplay : tablesForTabs = .myGoals
    let tabContainerView = UIView()
    
    
    @IBOutlet weak var tableView: UITableView!
    let header = UIView()
    let profileImage = UIImageView()
    let userName = UILabel()
    
    
    
    @IBAction func loginOut(_ sender: AnyObject) {
        
        
//        let vC = storyboard?.instantiateViewController(withIdentifier: "settings") as! settingsViewController
//        
//        self.show(vC, sender: self)
        
//        let currentUser = PFUser.current()
//        
//        if currentUser == nil {
//            
//            PFUser.logOut()
//            let vC = self.storyboard?.instantiateViewController(withIdentifier: "loginView")
//            
//            self.show(vC!, sender: self)
//            
//        } else {
//            print("logout123")
//            PFUser.logOut()
//        }
    }
    
    
    func goBack() {
        
        print("SHOULDGOBACK")
        self.navigationController?.popViewController(animated: true)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("PROFILE VIEW IS LOADING")
        
        tabWidth = Int(self.view.frame.width)
        tabItemWidth = Int(tabWidth! / 4)
        
        tab1Position = 0
        tab2Position = tabItemWidth
        tab3Position = tabItemWidth! * 2
        tab4Position = tabItemWidth! * 3
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.layoutMargins = UIEdgeInsets.zero
        
        
        // Table Footer
        
        
        footerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 300)
        self.tableView.tableFooterView = footerView
        helpers().startActivityIndicator(sender: self, object:self.footerView, activityIndicator: self.indicator, position: "center", start: true)
        
        


        
        
        //sort by most recently liked
        
        
    }
    
    // XYZ - Created new function to setup queries
    
    func loadInfo() {
        
        
        if otherSelectedUser == true {
            
            print("HERE1")
            
            if let currentUser = self.selectedUser! as? PFUser {
                
                createSecHeader()
                getProfileImage(currentUser: currentUser)
                getLikedGoals(currentUser: currentUser)
                getMyGoals(currentUser: currentUser)
                getFollowed(currentUser: currentUser)
                getFollowers(currentUser: currentUser)
                setupHeaderView(currentUser:PFUser.current()!)
                self.userName.text = currentUser.username
                
                
            }
            
        } else {
            
            print("HERE2")
            
            if (PFUser.current() != nil) {
                createSecHeader()
                getProfileImage(currentUser: PFUser.current()!)
                getLikedGoals(currentUser: PFUser.current()!)
                getMyGoals(currentUser: PFUser.current()!)
                getFollowed(currentUser: PFUser.current()!)
                getFollowers(currentUser:PFUser.current()!)
                setupHeaderView(currentUser:PFUser.current()!)
                self.userName.text = PFUser.current()!.username
             
            }
        }
        
    }
    
    
    func loadSavedSoFar() {
        
        let headerWidth = header.frame.width
        
        // BIG NUMBER
        let bigNumber = UILabel()
        bigNumber.frame = CGRect(x: 20, y: header.center.y - 100, width: self.view.frame.width - 40, height: 90)
        bigNumber.font = UIFont(name: "HelveticaNeue-UltraLight", size: 70 )
        bigNumber.textColor = .gray
        bigNumber.textAlignment = .center
        bigNumber.text = "$540.50"
        
        if let PFUser_ = PFUser.current() {
            bigNumber.text = PFUser_["userTotalSaved"] as? String
        }
        
        
        bigNumber.lineBreakMode = .byWordWrapping
        bigNumber.numberOfLines = 0
        
        header.addSubview(bigNumber)
        
        let numberLabel = UILabel()
        numberLabel.frame = CGRect(x: header.center.x - 50, y: bigNumber.frame.origin.y + 90, width: 100, height: 30)
        numberLabel.font = UIFont(name: "Proxima Nova Soft", size: 12)
        numberLabel.textColor = .lightGray
        numberLabel.textAlignment = .left
        numberLabel.text = "TOTAL SAVED"
        numberLabel.lineBreakMode = .byWordWrapping
        numberLabel.numberOfLines = 0
        
        
        header.addSubview(numberLabel)
 
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        print("VIEWWILLAPPEAR")
        
        
        if PFUser.current() == nil{
            
            // No current user
            
            print("NO")
            print("HERE2")
            let vC = self.storyboard?.instantiateViewController(withIdentifier: "userAuthRoot")
            print("HERE3")
            vC?.modalPresentationStyle = UIModalPresentationStyle.custom
            print("HERE4")
            vC?.transitioningDelegate = self
            print("HERE5")
            self.present(vC!, animated: true, completion: nil)
            
            
        }else {
            
            // XYZ - Add queries to view will appear for goals refresh on return to this view
            loadInfo()
            
        }
        

        
        
        if otherSelectedUser == true {
            
            helpers().backButton(sender: self)
            
            
        } else {
            
            loadSavedSoFar()
            
        }
        
        if  self.contentToDisplay == .likedGoals {
            
            bottomBorderLine.frame = CGRect(x: tabItemWidth! , y:Int(tabContainerView.frame.height - 2), width: tabItemWidth!, height: 2)
            
        } else {
            
            bottomBorderLine.frame = CGRect(x: 0 , y:Int(tabContainerView.frame.height - 2), width: tabItemWidth!, height: 2)
            
            
        }
        
        
        // Add lines
        
        
        bottomBorderLine.layer.cornerRadius = 0.5
        bottomBorderLine.backgroundColor = UIColor(red:0.20, green:0.68, blue:0.89, alpha:1.0)
        
        
        
    }
    
    
    
    
    
    
    
    
    func getLikedGoals (currentUser: PFUser)
    {
        likedgoals.removeAll(keepingCapacity: true)
        
        
        
        
        let likedgoalsQuery = PFQuery(className: "likes")
        
        
        likedgoalsQuery.includeKey("likeGoalParent")
        likedgoalsQuery.includeKey("likeGoalParent.goalAuthor")
        likedgoalsQuery.includeKey("goalAuthor")
        likedgoalsQuery.includeKey("likeUserParent")
        likedgoalsQuery.includeKey("userGoalAllocations")
        likedgoalsQuery.includeKey("paymentSchedule")
        
        
        likedgoalsQuery.whereKey("likeUserParent", equalTo: currentUser)
        likedgoalsQuery.order(byDescending: "createdAt")
        likedgoalsQuery.includeKey("likeGoalParent")
        likedgoalsQuery.findObjectsInBackground { (likeobjects, error) in
            if error == nil {
                for like_ in likeobjects! {
                    if let goal_ = like_["likeGoalParent"] as? PFObject {
                        let goalObj = goalsClass(goal: goal_)
                        self.likedgoals.append(goalObj)
                    }}}
            
            self.likedLabel.text = String(self.likedgoals.count)
            self.tableView.reloadData()
        }}
    
    
    
    func getMyGoals (currentUser: PFUser) {
        myGoals.removeAll(keepingCapacity: true)
        let goalsQuery = PFQuery(className: "goals")
        goalsQuery.whereKey("goalAuthor", equalTo: currentUser)
        goalsQuery.includeKey("goalAuthor")
        goalsQuery.includeKey("userGoalAllocations")
        goalsQuery.includeKey("paymentSchedule")
        goalsQuery.findObjectsInBackground { (goalobjects, error) in
            if error == nil {
                for goal_ in goalobjects! {
                    let goalObj = goalsClass(goal: goal_)
                    self.myGoals.append(goalObj)
                }}
            else {print("random error")}
            
            self.goalsLabel.text = String(self.myGoals.count)
            self.tableView.reloadData()
        }
    }
    
    func getFollowed(currentUser: PFUser)
    {
        myFollowed.removeAll(keepingCapacity: true)
        let followersQuery = PFQuery(className: "follow")
        followersQuery.whereKey("follower", equalTo: currentUser)
        followersQuery.includeKey("following")
        
        followersQuery.whereKey("follower", equalTo: currentUser)
        followersQuery.order(byDescending: "createdAt")
        followersQuery.findObjectsInBackground { (followerobjects, error) in
            if error == nil {
                for follower_ in followerobjects! {
                    if let followerObj = follower_["following"] as? PFUser {
                        self.myFollowed.append((followerObj, true))
                    }}}
            
            self.followingLabel.text = String(self.myFollowed.count)
            print(self.myFollowed.count)
            self.tableView.reloadData()
        }}
    
    
    func getFollowers(currentUser: PFUser)
    {
        myFollowers.removeAll(keepingCapacity: true)
        let followersQuery = PFQuery(className: "follow")
        let followingQuery = PFQuery(className: "follow")
        
        followersQuery.whereKey("follower", equalTo: currentUser) // kai following others
        followingQuery.whereKey("following", equalTo: currentUser)  // ppl following kai
        
        followersQuery.order(byDescending: "createdAt")
        followingQuery.includeKey("follower")
        
        followingQuery.findObjectsInBackground { (followingobjects, error) in  //this is the peeps following Kai
            if error == nil {
                followersQuery.findObjectsInBackground{(followerobjects, error ) in //to check if Kai is already foll. kim
                    if error == nil {
                        var isFollowingBack = false
                        for following_ in followingobjects! {  //for every kim
                            isFollowingBack = false
                            for follower_ in followerobjects! {  // for kai's foll kim
                                if follower_["following"] as! PFUser == following_["follower"] as! PFUser {  // kim ==
                                    isFollowingBack = true
                                    if let followerObj = following_["follower"] as? PFUser {
                                        self.myFollowers.append((followerObj, true))
                                    }}}
                            if isFollowingBack == false {
                                let followerObj = following_["follower"] as? PFUser
                                self.myFollowers.append((followerObj!, false))
                            }
                        }
                    }
                    
                    self.followersLabel.text = String(self.myFollowers.count)
                    print(self.myFollowers.count)
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func createSecHeader () {
        
        //Set buttons
        
        let tab1String = "goal"
        let tab1StringPlural = "goals"
        tab1.setTitle(tab1String.uppercased(), for: UIControlState.normal)
        tab1.frame = CGRect(x: tab1Position!, y:35, width: tabItemWidth!, height: 35)
        tab1.tag = 0
        
        
        let tab2String = "like"
        let tab2StringPlural = "likes"
        tab2.setTitle(tab2StringPlural.uppercased(), for: UIControlState.normal)
        tab2.frame = CGRect(x:tab2Position!, y:35, width: tabItemWidth!, height: 35)
        tab2.tag = 1
        
        let tab3String = "follower"
        let tab3StringPlural = "followers"
        tab3.setTitle(tab3StringPlural.uppercased(), for: UIControlState.normal)
        tab3.frame = CGRect(x: tab3Position!, y:35, width: tabItemWidth!, height: 35)
        tab3.tag = 2
        
        let tab4String = "following"
        tab4.setTitle(tab4String.uppercased(), for: UIControlState.normal)
        tab4.frame = CGRect(x: tab4Position!, y:35, width: tabItemWidth!, height: 35)
        tab4.tag = 3
        
        let tabButtons = [tab1, tab2, tab3, tab4]
        
        for tab in tabButtons {
            
            
            tab.addTarget(self, action: #selector(tabAction), for: .touchUpInside)
            tab.tintColor = UIColor(red:0.54, green:0.54, blue:0.54, alpha:1.0)
            tab.titleLabel?.font = UIFont(name: "Proxima Nova Soft", size: 10)
            tab.contentHorizontalAlignment = UIControlContentHorizontalAlignment.center
            tab.contentVerticalAlignment = UIControlContentVerticalAlignment.bottom
            tab.titleLabel?.textAlignment = .center
            tab.titleLabel?.numberOfLines = 2
            tab.titleLabel?.lineBreakMode = .byWordWrapping
            tab.setTitleColor(UIColor(red:0.54, green:0.54, blue:0.54, alpha:1.0), for: UIControlState.normal)
            
        }
        
        
        
        // Set Number labels
        
        // UIColor(red:0.17, green:0.17, blue:0.17, alpha:1.0)
        
        
        goalsLabel.frame = CGRect(x: 0, y: 0, width: tabItemWidth!, height: 15)
        goalsLabel.text = "0"
        goalsLabel.textColor = .gray
        goalsLabel.font = UIFont(name: "Proxima Nova Soft", size: 14 )
        goalsLabel.textAlignment = .center
        
        
        likedLabel.frame = CGRect(x: 0, y: 0, width: tabItemWidth!, height: 15)
        likedLabel.text = String(likedgoals.count)
        likedLabel.textColor = .gray
        likedLabel.font = UIFont(name: "Proxima Nova Soft", size: 14 )
        likedLabel.textAlignment = .center
        
        
        followersLabel.frame = CGRect(x: 0, y: 0, width: tabItemWidth!, height: 15)
        followersLabel.text = "0"
        followersLabel.textColor = .gray
        followersLabel.font = UIFont(name: "Proxima Nova Soft", size: 14 )
        followersLabel.textAlignment = .center
        
        
        followingLabel.frame = CGRect(x: 0, y: 0, width: tabItemWidth!, height: 15)
        followingLabel.text = "0"
        followingLabel.textColor = .gray
        followingLabel.font = UIFont(name: "Proxima Nova Soft", size: 14 )
        followingLabel.textAlignment = .center
        
        bottomBorderLine.frame = CGRect(x: 0 , y:Int(tabContainerView.frame.height - 2), width: tabItemWidth!, height: 2)
        
        
        tab1.addSubview(goalsLabel)
        tab2.addSubview(likedLabel)
        tab3.addSubview(followersLabel)
        tab4.addSubview(followingLabel)
        
        
        tabContainerView.addSubview(tab1)
        tabContainerView.addSubview(tab2)
        tabContainerView.addSubview(tab3)
        tabContainerView.addSubview(tab4)
        tabContainerView.addSubview(bottomBorderLine)
        
        
        
    }
    
    
    func tabAction(sender: UIButton) {
        
        print("TAB ONE ACTION")
        
        let button = sender
        let tabIndex = sender.tag
        
        
        UIView.animate(withDuration: 0.3, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            
            self.bottomBorderLine.frame = CGRect(x: button.frame.origin.x, y: self.bottomBorderLine.frame.origin.y, width: self.bottomBorderLine.frame.width, height: self.bottomBorderLine.frame.height)
            
        })
        
        
        if tabIndex == 0 {
            
            // Goals user has liked
            
            contentToDisplay = .myGoals
            
        }  else if tabIndex  == 1 {
            
            // Users Goal
            
            contentToDisplay = .likedGoals
            
        } else if tabIndex == 2 {
            
            // Go to list of people that follow
            
            let vC = self.storyboard?.instantiateViewController(withIdentifier: "userList") as! userListViewController
            
            vC.viewTitle = "Follower"
            
            self.navigationController!.pushViewController(vC, animated: true)
            
//            vC.usersList = myFollowers as! [userListViewController.magicUser]
            //vC.usersList = myFollowers

            
        } else if tabIndex == 3{
            
            // Go to list of people that following
            
            let vC = self.storyboard?.instantiateViewController(withIdentifier: "userList") as! userListViewController
            
            vC.viewTitle = "Following"
            
            self.navigationController!.pushViewController(vC, animated: true)
            
//            vC.usersList = myFollowed as! [userListViewController.magicUser]
            //vC.usersList = myFollowed
            
        }
        
        tableView.reloadData()
        
    }
    
    
    
    func getProfileImage(currentUser: PFUser){
        
        if let profileimageURL = currentUser["userImagePath"] as? String {
            if let urlString =  URL(string: profileimageURL)! as? URL {
                URLSession.shared.dataTask(with: urlString ) { (data, response, error) in
                    if error != nil {
                    } else {
                        DispatchQueue.main.async {
                            self.profileImage.image = UIImage(data: data!)
                            
                            //                            self.headerBG.image = UIImage(data: data!)
                            
                        }
                    }}.resume()
            }}}
    
    
    
    
    
    func setupHeaderView(currentUser:PFUser) {
        
        //        var currentUser = PFUser.current()
        
        print(myFollowers)
        print(myFollowed)
        
        //Variables
        //Measurements
        
        header.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 240)
        tableView.contentInset = UIEdgeInsetsMake(header.frame.height, 0, 0, 0)
        header.backgroundColor = UIColor.white
        let headerWidth = header.frame.width
        let headerHeight = header.frame.height
        let headerWidthCenter = headerWidth / 2
        let headerHeightCenter = headerHeight / 2
        
        
        // headerbg
        
        headerBG.frame = header.frame
        headerBG.backgroundColor = .white
        headerBG.contentMode = .scaleAspectFill
        headerBG.layer.masksToBounds = true
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        //        headerBG.addSubview(blurEffectView)
        header.addSubview(headerBG)
        
        
        // Navbar
        
        
        if otherSelectedUser != true {
            
            var titleView = UIView()
            var nvHeight = self.navigationController?.navigationBar.frame.height
            titleView.frame = CGRect(x: 0, y: 0, width: 180, height: nvHeight!)
            
            //  Add Profile Image
            profileImage.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
            profileImage.layer.cornerRadius = 20
            profileImage.layer.borderColor = UIColor.white.cgColor
            profileImage.backgroundColor = UIColor.lightGray
            profileImage.layer.borderWidth = 2.0
            profileImage.clipsToBounds = true
            profileImage.contentMode = .scaleAspectFill
            titleView.addSubview(profileImage)
            
            userName.frame = CGRect(x: 50 , y: 0 , width: 120, height: nvHeight!)
            userName.font = UIFont(name: "Proxima Nova Soft", size: 16 )
            userName.textColor = .lightGray
            userName.textAlignment = .left
            userName.text = "..."
            userName.lineBreakMode = .byWordWrapping
            userName.numberOfLines = 0
            titleView.addSubview(userName)
            
            
            self.navigationItem.titleView = titleView
            
            
        } else {
            
            
            //  Add Profile Image
            profileImage.frame = CGRect(x: headerWidthCenter - 40, y: headerHeightCenter - 100, width: 80, height: 80)
            profileImage.layer.cornerRadius = 40
            profileImage.layer.borderColor = UIColor.white.cgColor
            profileImage.backgroundColor = UIColor.lightGray
            profileImage.layer.borderWidth = 3.0
            profileImage.clipsToBounds = true
            profileImage.contentMode = .scaleAspectFill
            header.addSubview(profileImage)
            
            // Add Profile Name
            let labelHalfWayPoint = headerWidthCenter - (headerWidth / 2) + 10
            let lineHeight = userName.font.lineHeight
            userName.frame = CGRect(x: labelHalfWayPoint , y: headerHeightCenter  , width: headerWidth - 20, height: 21)
            userName.font = UIFont(name: "Proxima Nova Soft", size: 20 )
            userName.textColor = .gray
            userName.textAlignment = .center
            userName.text = "..."
            userName.lineBreakMode = .byWordWrapping
            userName.numberOfLines = 0
            header.addSubview(userName)
            
            
        }
        
        
        
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
        //self.createSecHeader()
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        
        switch contentToDisplay {
            
        case .myGoals:
            
            let goals = myGoals.count
            
            return goals
            
        case .likedGoals:
            
            let liked = likedgoals.count
            
            return liked
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let indexRow = (indexPath as NSIndexPath).row
        
        
        switch contentToDisplay {
            
        case .myGoals:
            
            let vC = storyboard?.instantiateViewController(withIdentifier: "goalViewDetail") as! detailGoalViewController
            
            
            vC.goalObject = myGoals[indexRow]
            
            //vC.navigationController?.title = self.goalTitles[indexRow] as String
            vC.navigationController?.title = myGoals[indexRow].goalTitle
            
            
            
            print("TRANSITION2")
            
            self.show(vC, sender: self)
            
            
        case .likedGoals: break
            
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //self.createSecHeader()
        
        
        let indexRow = (indexPath as NSIndexPath).row
        
        
        switch contentToDisplay {
            
        case .myGoals:
            
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "goalAlloc", for: indexPath) as! goalAllocViewCell
            
            cell.goalTitle.text = myGoals[indexRow].goalTitle
            
//            myGoals[indexRow].userGoalAllocation()
//            myGoals[indexRow].goalPaymentSchedule()
            
            let makeDoubleInt = Int(myGoals[indexRow].goalTotalSaved!)
            cell.goalCurrentAmount.text = String(makeDoubleInt)
            cell.goalCurrentAmount.sizeToFit()
            
            
            let dateToGo = myGoals[indexRow].goalTimeLeft!
            
            let datetoGoString = "\(dateToGo)"
            cell.goalTimeLeft.text = datetoGoString
            
            let percNum = myGoals[indexRow].goalPercComplete
            
//            self.percAngle = (percNum! / 100) * 360
//            let perNumConvertInt = Int(percNum!)
//            let percString = String(perNumConvertInt)
//            cell.goalCompletionPercentage.text = "\(percString)%"
            
            cell.goalProgress.animate(fromAngle: 0, toAngle: self.percAngle!, duration: 2, completion: nil)
            
            //Measurements
            
            let width = self.tableView.frame.width
            let height = cell.frame.height
            
            //Gradient Overlay
            
            cell.overlayGradient.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
            cell.overlayGradient.locations = [0.0, 0.9]
            cell.overlayGradient.frame = CGRect(x: 0, y: 0, width: width, height: 300)
            cell.goalImage.layer.insertSublayer(cell.overlayGradient, at: 0)
            
            
            
            
            if let imageprofile1 = URL(string: myGoals[indexRow].goalImagePath!) {
                
                cell.goalImage.af_setImage(withURL: imageprofile1, placeholderImage: UIImage(named:"no-image-bg"), filter: nil,imageTransition: .crossDissolve(0.2), runImageTransitionIfCached: true, completion: nil)
                
            }
            
            
            
            
            
            
            return cell
            
            
        case .likedGoals:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "goal", for: indexPath) as! goalViewCell
            
            //Measurements
            
            let width = self.tableView.frame.width
            let height = cell.frame.height
            
            //Gradient Overlay
            
            cell.overlayGradient.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
            cell.overlayGradient.locations = [0.0, 0.9]
            cell.overlayGradient.frame = CGRect(x: 0, y: 0, width: width, height: 300)
            cell.goalImage.layer.insertSublayer(cell.overlayGradient, at: 0)
            
            //Configure outlets
            
            cell.goalAuthorName.setTitle(likedgoals[indexRow].goalAuthorName, for: .normal)
            
            
            
            if let authorprofile1 = URL(string: self.likedgoals[indexRow].goalAuthorImagePath!) {
                
                cell.goalAuthorProfile.af_setImage(for: UIControlState.normal, url: authorprofile1, placeholderImage: UIImage(named: "user-placeholder"), filter: nil, completion: nil)
                
            }
            
            
            if let imageprofile2 = URL(string: self.likedgoals[indexRow].goalAuthorImagePath!) {
                
                
                cell.goalAuthorProfile.af_setImage(for: UIControlState.normal, url: imageprofile2, placeholderImage: UIImage(named: "user-placeholder"), filter: nil, completion: nil)
                
                
                cell.goalImage.af_setImage(withURL: imageprofile2, placeholderImage: UIImage(named:"no-image-bg"), filter: nil,imageTransition: .crossDissolve(0.2), runImageTransitionIfCached: true, completion: nil)
                
            }
            
            
            cell.goalTitle.text = likedgoals[indexRow].goalTitle
            
            
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
            // XYZ2 Use UIColor extention
            sender.tintColor = UIColor.soraHeartRed()
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
}

