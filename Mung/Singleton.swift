//
//  Global.swift
//  Mung
//
//  Created by Jake Dorab on 2/25/17.
//  Copyright © 2017 Color & Space. All rights reserved.
//


// xyz.abc

import Foundation
import Parse

final class meViewController2Data {
    
    // Can't init is singleton
    private init() {
        
        print("we are creating singleton!!")
        
        if PFUser.current() != nil {
            self.getMeGoals()
            self.getLikedGoals()
            self.getFollowers()
            self.getFollowing()
            self.LoggedIn = true
        } else {
            self.LoggedIn = false
        }
    }
    
    //MARK: Shared Instance
    
    static let sharedInstance: meViewController2Data = meViewController2Data()
    
    //MARK: Local Variable
    
    private var meGoals : [goalsClass?] = []
    private var meLikedGoals : [goalsClass?] = []
    private var myFollowers : [UserClass?] = []
    private var imFollowing : [UserClass?] = []
    private var LoggedIn : Bool?
    
    
    func getmeGoals() -> [goalsClass?] {
        return meGoals
    }
    
    func getmeLikedGoals() -> [goalsClass?] {
        return meLikedGoals
    }
    
    func getmyFollowers() -> [UserClass?] {
        return myFollowers
    }
    
    func getimFollowing() -> [UserClass?] {
        return myFollowers
    }
    
    func getLoggedIn() -> Bool? {
        return LoggedIn
    }

    
    func getMeGoals() {
        
        likeClass().fetchLikedGoals(perspective: PFUser.current(), indexStart: 0, indexEnd: 10, criteriaMap: [false, false, false, true], completion: { myGoals, error in
            
            if (error == nil) && (myGoals != nil) {
                DispatchQueue.main.async {
                    self.meGoals = myGoals!
                }
                NotificationCenter.default.post(name: Notification.Name(rawValue: "reloadData"), object: nil, userInfo: ["status": true])
            }
        })
    }
    
    func getLikedGoals() {
        likeClass().fetchLikedGoals(perspective: PFUser.current(), indexStart: 0, indexEnd: 10, criteriaMap: [false, false, true, false], completion: { likedGoals, error in
            if (error == nil) && (likedGoals != nil) {
                DispatchQueue.main.async {
                    self.meLikedGoals = likedGoals!
                }
                NotificationCenter.default.post(name: Notification.Name(rawValue: "reloadData"), object: nil, userInfo: ["status": true])
            }
        })
    }
    
    func getFollowers() {
        UserClass().getFollowers(perspective: PFUser.current(), imFollowing: false, completion: { (usersList, error) in
            if (error == nil) && (usersList != nil) {
                DispatchQueue.main.async {
                    self.myFollowers = usersList!
                }
                NotificationCenter.default.post(name: Notification.Name(rawValue: "reloadData"), object: nil, userInfo: ["status": true])
            }
        })
    }
    
    func getFollowing() {
        UserClass().getFollowers(perspective: PFUser.current(), imFollowing: true, completion: { (usersList, error) in
            if (error == nil) && (usersList != nil) {
                DispatchQueue.main.async {
                    self.imFollowing = usersList!
                }
                NotificationCenter.default.post(name: Notification.Name(rawValue: "reloadData"), object: nil, userInfo: ["status": true])
            }
        })
    }
}
