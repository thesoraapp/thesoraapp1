//
//  CollectionViewController.swift
//  Mung
//
//  Created by Jake Dorab on 2/21/17.
//  Copyright © 2017 Color & Space. All rights reserved.
//

// xyz.abc


import UIKit
import Parse

private let reuseIdentifier = "Cell"

class meViewController2: UICollectionViewController, UIViewControllerTransitioningDelegate {
    
    let offset_HeaderStop:CGFloat = 190.0
    var header = UIView()
    var indicator = UIActivityIndicatorView()
    
    var tabsInst = [UIButton]()
    let tabIndicator = UIView()
    var tabPressed = Int()
    var tabCountsInst = [Int]()
    var tabsContainerView = UIView()
    let tabClass = tabSegments()
    var indexRow = Int()
    
    

    var meTabs = ["Goal", "Liked", "Following", "Followers"]
    
    var currentUser : PFObject?
    var currentUserClass =  UserClass(userPFObject: nil, userPFUser: PFUser.current())
    var otherSelectedUser = false
    
    enum tablesForTabs {
        case  meGoals, meLikedGoals
    }
    var contentToDisplay: tablesForTabs = .meGoals
    var switchDetailData = false
    
    var meGoals = [goalsClass?] ()
    var meLikedGoals = [goalsClass?] ()
    var myFollowers = [UserClass?] ()
    var imFollowing = [UserClass?] ()

    
    @objc func notificationFollow(notification: Notification) {
        if let userInfo = notification.userInfo, let status = userInfo["status"] as? Bool {
            getFollowing()
        } else {
            print("notification, no user info")
        }
    }
    @objc func notificationLike(notification: Notification) {
        if let userInfo = notification.userInfo, let status = userInfo["status"] as? Bool {
            getLikedGoals()
        } else {
            print("notification, no user info")
        }
    }
    @objc func notificationMeGoals(notification: Notification) {
        if let userInfo = notification.userInfo, let status = userInfo["status"] as? Bool {
            getMeGoals()
        } else {
            print("notification, no user info")
        }
    }
    
    @objc func notificationReloadView(notification: Notification) {
        self.collectionView?.reloadData()
    }
    
    
    @objc func notificationReloadProfile(notification: Notification) {
        if let userInfo = notification.userInfo, let status = userInfo["status"] as? UserClass {
    
            self.currentUserClass = status
            if status.objectId != nil {
                
                print("noticeme222")
                self.navigationController?.setNavigationBarHidden(false, animated: false)
                //self.header.subviews.removeAll()
                for view in self.header.subviews {
                    view.removeFromSuperview()
                }
                self.header.removeFromSuperview()
                headerSetup(tabsContainerView: self.tabsContainerView)
                getMeGoals()
                getLikedGoals()
                getFollowers()
                getFollowing()
            } else {
                
                print("noticeme111")
                
                self.navigationController?.viewControllers.remove(at: 1)
                self.navigationController?.setNavigationBarHidden(true, animated: false)
                
                for view in self.header.subviews {
                    view.removeFromSuperview()

                }
                
                self.header.removeFromSuperview()

                self.meGoals = []
                self.meLikedGoals = []
                self.myFollowers = []
                self.imFollowing = []
                tabSegments().updateCount(tabs: self.tabsInst, tabCounts: [0,0, 0,0])
                self.collectionView?.reloadData()
            }
            
        } else {
            print("notification, no user info")
        }
    }
    
 
    
    func getMeGoals() {
    
        if otherSelectedUser == false {
            print("PFUser.current()")
            print(PFUser.current())
            currentUser = PFUser.current()!
        }
        likeClass().fetchLikedGoals(perspective: currentUser, indexStart: 0, indexEnd: 10, criteriaMap: [false, false, false, true], completion: { myGoals, error in
            
            if (error == nil) && (myGoals != nil) {
                
                DispatchQueue.main.async {
                    self.meGoals = myGoals!
                    tabSegments().updateCount(tabs: self.tabsInst, tabCounts: [self.meGoals.count,nil, nil,nil])
                    
                    helpers().startActivityIndicator(sender: self, object: self.view, activityIndicator: self.indicator, start: false)
                    self.collectionView?.reloadData()
                }
            }
        })
    }
    
    func getLikedGoals() {
        if otherSelectedUser == false {
            currentUser = PFUser.current()!
        }
        likeClass().fetchLikedGoals(perspective: currentUser, indexStart: 0, indexEnd: 10, criteriaMap: [false, false, true, false], completion: { likedGoals, error in
            if (error == nil) && (likedGoals != nil) {
                DispatchQueue.main.async {
                    self.meLikedGoals = likedGoals!
                    tabSegments().updateCount(tabs: self.tabsInst, tabCounts: [nil, self.meLikedGoals.count,nil,nil])
                    self.collectionView?.reloadData()
                }
            }
        })
    }
    
    func getFollowers() {
        if otherSelectedUser == false {
            currentUser = PFUser.current()!
        }
        UserClass().getFollowers(perspective: currentUser, imFollowing: false, completion: { (usersList, error) in
            print("myGoals")
            
            if (error == nil) && (usersList != nil) {
                DispatchQueue.main.async {
                    self.myFollowers = usersList!
                    tabSegments().updateCount(tabs: self.tabsInst, tabCounts: [nil, nil,nil, self.myFollowers.count])
                    self.collectionView?.reloadData()
                }
            }
        })
        
    }
    
    func getFollowing() {
        if otherSelectedUser == false {
            currentUser = PFUser.current()!
        }
        UserClass().getFollowers(perspective: currentUser, imFollowing: true, completion: { (usersList, error) in
            if (error == nil) && (usersList != nil) {
                DispatchQueue.main.async {
                    self.imFollowing = usersList!
                    tabSegments().updateCount(tabs: self.tabsInst, tabCounts: [nil,nil,self.imFollowing.count, nil])
                    self.collectionView?.reloadData()
                }
            }
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
//        print("meViewController2Data.sharedInstance.getmeGoals()")
//        print(meViewController2Data.sharedInstance.getmeGoals())
        
        helpers().startActivityIndicator(sender: self, object: self.view, activityIndicator: indicator, position: "center", start: true)
        
        if (PFUser.current() == nil) && (self.otherSelectedUser == false)  {
            // No current user- Go to login view
            let vC = self.storyboard?.instantiateViewController(withIdentifier: "userAuth") as! userAuthViewController
            vC.modalPresentationStyle = UIModalPresentationStyle.custom
            vC.transitioningDelegate = self
            vC.statusBarShouldBeHidden = true
            let vcRoot = UINavigationController(rootViewController: vC)
            self.present(vcRoot, animated: true, completion: nil)
        }
        
        if  contentToDisplay == .meGoals {
            tabSegments().updateLinePosition(tab: tabsInst[0], tabIndicator: self.tabIndicator, tabIndex: 0)
        } else if contentToDisplay == .meLikedGoals {
            tabSegments().updateLinePosition(tab: tabsInst[1], tabIndicator: self.tabIndicator, tabIndex: 1)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("runrunrun")
    
        NotificationCenter.default.addObserver(self, selector: #selector(notificationMeGoals(notification:)), name: Notification.Name(rawValue: "meGoalsToggled"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(notificationLike(notification:)), name: Notification.Name(rawValue: "likedGoalsToggled"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(notificationFollow(notification:)), name: Notification.Name(rawValue: "followToggled"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(notificationReloadProfile(notification:)), name: Notification.Name(rawValue: "refreshToggled"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(notificationReloadView(notification:)), name: Notification.Name(rawValue: "reloadData"), object: nil)
        
        
 
        let tabClass = tabSegments()
        tabsInst = tabClass.createTabs(viewController: self, numberOfTabs: 4, tabStrings: meTabs)
        let tabIndicatorView = tabClass.createTabIndicator(tabs: tabsInst, currentTab: 0, tabIndicator: self.tabIndicator)
        self.tabsContainerView = tabClass.genContainerView(viewController: self, tabs: tabsInst, tabIndicator: tabIndicatorView)
        
        
    
        
        // Setup header
        if ((PFUser.current() != nil) || (self.otherSelectedUser == true)) {
            
            
            print("wearesettingupheader")
            print(self.otherSelectedUser)
            print(self.currentUser)
            
            
            // We should load these up from Discover view after everything has loaded in it. Declare these globally...
            
            
            
            headerSetup(tabsContainerView: self.tabsContainerView)
            self.meGoals = meViewController2Data.sharedInstance.getmeGoals()
            self.meLikedGoals = meViewController2Data.sharedInstance.getmeLikedGoals()
            self.myFollowers = meViewController2Data.sharedInstance.getmyFollowers()
            self.imFollowing = meViewController2Data.sharedInstance.getimFollowing()
            tabSegments().updateCount(tabs: self.tabsInst, tabCounts: [self.meGoals.count,self.meLikedGoals.count, self.myFollowers.count,self.imFollowing.count])

            
//            getMeGoals()
//            getLikedGoals()
//            getFollowers()
//            getFollowing()
        
//             if PFUser.current() != nil && (self.otherSelectedUser == false)  {
        }
//        
 
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        self.collectionView?.register(UINib(nibName: "MeGoalCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "meMeCell")
        self.collectionView?.register(UINib(nibName: "PublicGoalCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "mePublicCell")
        
        
        // Register cell classes
        //self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }
    
    
    func headerSetup(tabsContainerView: UIView) {
        
        print("PFUser.current()")
        print(PFUser.current())
        print(self.currentUser)
        
        if ((self.currentUser?.objectId == PFUser.current()?.objectId) || (self.currentUser == nil)) {
            header = meViewHeader().setupHeaderView(user: self.currentUserClass, header: self.header, otherSelectedUser: self.otherSelectedUser, viewController: self, tabs: tabsContainerView)
            
            
            print("thishappened")
            print("self.otherSelectedUser")
            print(self.otherSelectedUser)
//            self.currentUserClass = UserClass(userPFObject:  self.currentUser, userPFUser: nil)
//            header = meViewHeader().setupHeaderView(user: self.currentUserClass, header: self.header, otherSelectedUser: self.otherSelectedUser, viewController: self, tabs: tabsContainerView)
            
            
        } else {
//            if PFUser.current()
//            self.currentUserClass = UserClass(userPFObject:  self.currentUser, userPFUser: nil)
            
            self.currentUserClass = UserClass(userPFObject:  self.currentUser, userPFUser: nil)
            header = meViewHeader().setupHeaderView(user: self.currentUserClass, header: self.header, otherSelectedUser: self.otherSelectedUser, viewController: self, tabs: tabsContainerView)
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
        if let userList = segue.destination as? userListViewController {
            if self.tabPressed == 2 {
                // Go to list of people that follow
                userList.usersList = self.imFollowing
            } else if self.tabPressed == 3 {
                // Go to list of people that following
                userList.usersList = self.myFollowers
            }
        }
        
        if let detailView = segue.destination as? detailGoalViewController {
            
            
            if switchDetailData == false {
                

                detailView.goalObject = self.meGoals[self.indexRow]
                
            } else {
                
                if (self.meLikedGoals[self.indexRow]?.goalAuthorObject?.objectId == PFUser.current()?.objectId) {
                    
                    detailView.otherSelectedUser = false
                } else {
                    
                    detailView.otherSelectedUser = true
                }
                
                detailView.goalObject = self.meLikedGoals[self.indexRow]
            }
            
            
            
        }
        
        if let settings = segue.destination as? settingsViewController {

            settings.userObject = self.currentUserClass
        }
    }
 
    


    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        
        switch contentToDisplay {
        case .meGoals:
            let goalsCount = meGoals.count
            return goalsCount
            
        case .meLikedGoals:
            let likedCount = meLikedGoals.count
            return likedCount
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        self.indexRow = indexPath.row
        
        //XYZ444- Change data accordingly, BOOL values are set here and used in prepareforsegue
        switch contentToDisplay {
        case .meGoals:
            
            switchDetailData = false
            
        case .meLikedGoals:
            
            switchDetailData = true
          
        }

   
        self.performSegue(withIdentifier: "meMeCellSegue" , sender: self)
        
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        
        switch contentToDisplay {
            case .meGoals:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "meMeCell", for: indexPath) as! MeGoalCollectionViewCell
                if let goal_ = meGoals[indexPath.row] {
                    cell.goal = goal_
                } else{
                // do smthg
                }
                return cell
            
            case .meLikedGoals:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mePublicCell", for: indexPath) as! PublicGoalCollectionViewCell
                if let goal_ = meLikedGoals[indexPath.row] {
                    cell.goal = goal_
                    cell.goalCommentButton.addTarget(self, action: #selector(commentAction(_:)), for: .touchUpInside)
                } else{
                    // do smthg
                }
                return cell
        }
    }
    
    
    // MARK: - ScrollView Delegate
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y + header.bounds.height
        var headerTransform = CATransform3DIdentity

        // PULL DOWN ----------------
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
    
    @IBAction func commentAction(_ sender: Any) {
        self.performSegue(withIdentifier: "meComments", sender: self)
    }
    

    @IBAction func tabButtonPressed(sender: UIButton) {
        
        tabPressed = sender.tag
        tabSegments().updateLinePosition(tab: sender, tabIndicator: self.tabIndicator, tabIndex: sender.tag)
        
        if sender.tag == 0 {
            // Goals user has liked
            
            // clean up likedGoals -- Feb 23, 2016 "Makes most sense here." - Jake D.
            NotificationCenter.default.post(name: Notification.Name(rawValue: "likedGoalsToggled"), object: nil, userInfo: ["status": true])
            
            contentToDisplay = .meGoals
        }  else if sender.tag  == 1 {
            // Users Goal
            contentToDisplay = .meLikedGoals
        } else if sender.tag == 2 {
            // Go to list of people that follow
            performSegue(withIdentifier: "followersSegue", sender: self)
        } else if sender.tag == 3 {
            // Go to list of people that following
            performSegue(withIdentifier: "followersSegue", sender: self)
        }
        
        collectionView?.reloadData()
    }

}
