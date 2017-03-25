//
//  goalCollectionViewController.swift
//  Sora
//
//  Created by Jake Dorab on 2/20/17.
//  Copyright © 2017 Color & Space. All rights reserved.
//

// some random change

import UIKit
import Parse

private let reuseIdentifier = "goalCell"

class discoverCollectionViewController: UICollectionViewController {
    
    var goals = [goalsClass?]()
    var currentUser : PFUser?
    var refresh = UIRefreshControl()
    var indicator = UIActivityIndicatorView()
    var indexRow = Int()
    
    
    @objc func notificationRefreshDiscover(notification: Notification) {
        if let userInfo = notification.userInfo, let status = userInfo["status"] as? Bool {
            fetchDiscoverGoals()
        } else {
            print("notification, no user info")
        }
    }
    
    func fetchDiscoverGoals() {
        if PFUser.current() != nil {
            currentUser = PFUser.current()!
        }
        
        let likeC = likeClass()
        likeC.fetchLikedGoals(perspective: currentUser, indexStart: 0, indexEnd: 10, criteriaMap: [true, false, false, false], completion: { topGoals, error in
            
            if (error == nil) && (topGoals != nil) {
                DispatchQueue.main.async {
                    self.goals = topGoals!
                    self.refresh.endRefreshing()
                    helpers().startActivityIndicator(sender:self, object: self.view, activityIndicator:self.indicator, position: "top", start: false)
                    self.collectionView?.reloadData()
                }
            }
        })
    }
    
    @IBAction func commentAction(_ sender: UIButton) {
        self.performSegue(withIdentifier: "discoverComments", sender: self)
    }
    
    @IBAction func goToAuthorAction(_ sender: UIButton) {
        self.indexRow = sender.tag
        self.performSegue(withIdentifier: "discoverMeView", sender: self)
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(notificationRefreshDiscover(notification:)), name: Notification.Name(rawValue: "RefreshDiscover"), object: nil)
        
        fetchDiscoverGoals()
        
        helpers().startActivityIndicator(sender:self, object: self.view, activityIndicator:indicator, position: "top", start: true)
        
        // Add to Table View
        if #available(iOS 10.0, *) {
            collectionView?.refreshControl = refresh
        } else {
            collectionView?.addSubview(refresh)
        }
        self.collectionView?.alwaysBounceVertical = true
        refresh.addTarget(self, action: Selector("fetchDiscoverGoals"), for: UIControlEvents.valueChanged)
        refresh.backgroundColor = UIColor.clear
        refresh.tintColor = UIColor.lightGray
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Register cell classes
        // self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        self.collectionView?.register(UINib(nibName: "PublicGoalCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "mePublicCell")
        
        
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return goals.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.indexRow = indexPath.row
        self.performSegue(withIdentifier: "meDiscoverDetailSegue" , sender: self)
    }
    
    @IBAction func unwindToRootViewController(segue: UIStoryboardSegue) {
        print("Unwind to Root View Controller")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let detailView = segue.destination as? detailGoalViewController {
            detailView.goalObject = self.goals[self.indexRow]
            
            if PFUser.current() == nil {
                detailView.otherSelectedUser = true
            }
            
            if (self.goals[self.indexRow]?.goalAuthorObject?.objectId == PFUser.current()?.objectId) {
                
                
                detailView.otherSelectedUser = false
            } else {
                
                detailView.otherSelectedUser = true
            }
        }
        if let comments = segue.destination as? commentsViewController {
            comments.goalObject = self.goals[self.indexRow]!
        }
        
        if let userProfile = segue.destination as? meViewController2 {
            
            //                if self.goals[self.indexRow]?.goalAuthorObject != self.currentUser {
            if ((PFUser.current() == nil) || (self.goals[self.indexRow]?.goalAuthorObject?.objectId != PFUser.current()?.objectId)) {
                print("weareinsidnesettingselected")
                print(self.goals[self.indexRow]?.goalAuthorObject?.objectId)
                print(PFUser.current()?.objectId)
                userProfile.otherSelectedUser = true
            }
            userProfile.currentUser = self.goals[self.indexRow]?.goalAuthorObject
            //                }
        }
    }
    
    
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mePublicCell", for: indexPath) as! PublicGoalCollectionViewCell
        
        if let goal_ = goals[indexPath.row] {
            cell.goal = goal_
            cell.goalCommentButton.addTarget(self, action: #selector(commentAction(_:)), for: .touchUpInside)
            cell.goalAuthorImage.addTarget(self, action: #selector(goToAuthorAction(_:)), for: .touchUpInside)
            cell.goalAuthorImage.tag = indexPath.row
            
        } else {
            // do smthg
        }
        return cell
    }
    
    
    
    
    
    // MARK: UICollectionViewDelegate
    
    /*
     // Uncomment this method to specify if the specified item should be highlighted during tracking
     override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment this method to specify if the specified item should be selected
     override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
     override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
     
     }
     */
    
    
    
}
