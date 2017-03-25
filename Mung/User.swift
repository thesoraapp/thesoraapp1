//
//  User.swift
//  Mung
//
//  Created by Jake Dorab on 2/7/17.
//  Copyright © 2017 Color & Space. All rights reserved.
//

import Foundation
import UIKit
import Parse
import MHPrettyDate

class UserClass {
    
    var userObj: PFObject?
    var objectId : String?
    var userPassword : String?
    var userEmail : String?
    var username : String?
    var userImagePath : String?
    var userFullName: String?
    var userInstagramAccessString: String?
    var userInstagramUserName : String?
    var userTotalSaved : Double?
    
    var isFollowedbyCurUser : Bool?
    
    init( userPFObject: PFObject? = nil, userPFUser: PFUser? = nil ) {
        
        if (userPFObject == nil) && (userPFUser == nil) {
            
            self.userObj = nil
            self.objectId = nil
            self.username = nil
            self.userPassword = nil
            self.userEmail = nil
            self.userImagePath = nil
            self.userFullName = nil
            self.userInstagramAccessString = nil
            self.userInstagramUserName = nil
            self.userTotalSaved = nil
            self.isFollowedbyCurUser = nil
            
        }
        else if (userPFObject != nil) && (userPFUser == nil) {
            
            self.userObj = userPFObject
            self.objectId = userPFObject?.objectId
            self.userPassword = userPFObject?["_hashed_password"] as! String?
            self.username = userPFObject?["username"] as! String?
            self.userEmail = userPFObject?["email"] as! String?
            self.userImagePath = userPFObject?["userImagePath"] as! String?
            self.userFullName = userPFObject?["userFullName"] as! String?
            self.userInstagramAccessString = userPFObject?["userInstagramAccessString"] as! String?
            self.userInstagramUserName = userPFObject?["userInstagramUserName"] as! String?
            self.userTotalSaved = userPFObject?["userTotalSaved"] as! Double?
            
        } else {
            
            self.userObj = userPFUser
            self.objectId = userPFUser?.objectId
            self.userPassword = userPFUser?["_hashed_password"] as! String?
            self.username = userPFUser?["username"] as! String?
            self.userEmail = userPFUser?["email"] as! String?
            self.userImagePath = userPFUser?["userImagePath"] as! String?
            self.userFullName = userPFUser?["userFullName"] as! String?
            self.userInstagramAccessString = userPFUser?["userInstagramAccessString"] as! String?
            self.userInstagramUserName = userPFUser?["userInstagramUserName"] as! String?
            self.userTotalSaved = userPFUser?["userTotalSaved"] as! Double?
            
            
        }
        
        
        //
        //
        //            // check if given user followed by current user
        //
        //            // Assume PFUser.current() is global
        //
        //            if PFUser.current() == nil || user == PFUser.current() {
        //                self.isFollowedbyCurUser = false
        //            }
        //            else {
        //
        //                let Query = PFQuery(className: "follow")
        //                Query.whereKey("following", equalTo: user)
        //                Query.whereKey("follower", equalTo: PFUser.current())
        //                Query.findObjectsInBackground { (object, error) in
        //                    if error == nil {
        //                        if object != nil {
        //                           self.isFollowedbyCurUser = true
        //                        }
        //                        else {
        //                           self.isFollowedbyCurUser = false
        //                        }
        //                    }
        //                }
        //            }
        //        }
    }
    
    func updateUserClassDB(userPFObject: PFObject? = nil, objectID: String, email: String? = nil, username: String? = nil, userImagePath: String? = nil,
                           userFullName: String? = nil, userInstagramAccessString: String? = nil, userInstagramUserName: String? = nil,
                           userTotalSaved: Double? = nil, completion: @escaping (Error?) -> Void ) {
        
        let query = PFQuery(className: "_User")
        
        query.getObjectInBackground(withId: objectID) { (object, error) in
            if error == nil {
                
                print("object1.a")
                print(object)
                if userPFObject != nil {
                    self.userObj = userPFObject
                    self.objectId = userPFObject?.objectId
                    self.userPassword = userPFObject?["_hashed_password"] as! String?
                    self.username = userPFObject?["username"] as! String?
                    self.userEmail = userPFObject?["email"] as! String?
                    self.userImagePath = userPFObject?["userImagePath"] as! String?
                    self.userFullName = userPFObject?["userFullName"] as! String?
                    self.userInstagramAccessString = userPFObject?["userInstagramAccessString"] as! String?
                    self.userInstagramUserName = userPFObject?["userInstagramUserName"] as! String?
                    self.userTotalSaved = userPFObject?["userTotalSaved"] as! Double?
                }
                
                
                if username != nil {
                    object?["username"] = username!
                    self.username = username!
                }
                if email != nil {
                    object?["email"] = email!
                    self.userEmail = email!
                }
                if userImagePath != nil {
                    object?["userImagePath"] = userImagePath!
                    self.userImagePath = userImagePath!
                }
                if userFullName != nil {
                    object?["userFullName"] = userFullName!
                    self.userFullName = userFullName!
                }
                if userInstagramAccessString != nil {
                    object?["userInstagramAccessString"] = userInstagramAccessString!
                    self.userInstagramAccessString = userInstagramAccessString!
                }
                if userInstagramUserName != nil {
                    object?["userInstagramUserName"] = userInstagramUserName!
                    self.userInstagramUserName = userInstagramUserName!
                }
                if userTotalSaved != nil {
                    object?["userTotalSaved"] = userTotalSaved!
                    self.userTotalSaved = userTotalSaved!
                }
                
                object?.saveInBackground(block: { (saved, error) in
                    if saved {
                        completion(nil)
                    } else {
                        // TODO: Create instance of custom Error object
                        //completion(nil)
                    }
                })
                
            }
        }
    }
    
    
    
    
    func fetchUserifPFUserChange (completion: @escaping ( PFObject?, Error?) -> Void)  {
        PFUser.current()?.fetchInBackground(block: { (userPFObject, error) in
            completion(userPFObject, nil)
        })
    }
    
    
    func saveUserClassinDB() {  //Use to create a brand new goal
        
        let userObj = PFObject(className: "User")
        
        userObj["username"] = self.username
        userObj["email"] = self.userEmail
        userObj["userImagePath"] = self.userImagePath
        userObj["userFullName"] = self.userFullName
        userObj["userInstagramAccessString"] = self.userInstagramAccessString
        userObj["userInstagramUserName"] = self.userInstagramUserName
        userObj["userTotalSaved"] = self.userTotalSaved
        
        userObj.saveInBackground()
        
    }
    
    
    func getFollowers (perspective: PFObject?, imFollowing: Bool, completion: @escaping ([UserClass]?, Error?) -> Void)  {
        
        var followList = [UserClass]()
        followList.removeAll(keepingCapacity: true)
        
        let Query = PFQuery(className: "follow")
        var key = String()
        if imFollowing {
            Query.whereKey("follower", equalTo: perspective)
            Query.includeKey("following")
            key = "following"
        } else {
            Query.whereKey("following", equalTo: perspective)
            Query.includeKey("follower")
            key = "follower"
        }
        Query.order(byDescending: "createdAt")
        Query.findObjectsInBackground { (objects, error) in
            if error == nil {
                if objects != nil {
                    for obj_ in objects! {
                        let userObj_ = UserClass(userPFObject: obj_[key] as! PFObject?)
                        followList.append(userObj_)
                    }
                }
            }
            completion (followList, nil)
        }
    }
    
    func isFollowed (givenUser: PFObject?, perspective: PFUser?, completion : @escaping (Bool?, Error?) -> Void) {
        let Query = PFQuery(className: "follow")
        Query.whereKey("following", equalTo: givenUser)
        Query.whereKey("follower", equalTo: perspective)
        
        Query.findObjectsInBackground { (objects, error) in
            if error == nil {
                if objects! != [] {
                    completion(true, nil)
                } else {
                    completion(false,nil)
                }
            }
        }
    }
    
    
    
    func toggleFollow(givenUser: PFObject?, perspective: PFUser?, completion: @escaping (Bool?, Error?) -> Void) {
        
        if let currentUser = PFUser.current() {
            if currentUser == nil {
                // segue to Login (and dismiss when done)
                
            } else {
                self.isFollowed(givenUser: givenUser, perspective: perspective, completion: { (isFollowed, error) in
                    if isFollowed == true {
                        let followQuery = PFQuery(className: "follow")
                        followQuery.whereKey("follower", equalTo: perspective)
                        followQuery.whereKey("following", equalTo: givenUser)
                        followQuery.findObjectsInBackground { (followObjs, error) in
                            if followObjs != nil {
                                for follow_ in followObjs! {
                                    follow_.deleteInBackground(block: { (success, error) in
                                        if success {
                                            NotificationCenter.default.post(name: Notification.Name(rawValue: "followToggled"), object: nil, userInfo: ["status": true])
                                            
                                            completion(false, nil)
                                            return
                                        }
                                    })
                                }
                            }
                        }
                    } else {
                        let followQuery = PFObject(className: "follow")
                        followQuery["follower"] = perspective
                        followQuery["following"] = givenUser
                        followQuery.saveInBackground(block: { (success, error) in
                            if success {
                                NotificationCenter.default.post(name: Notification.Name(rawValue: "followToggled"), object: nil, userInfo: ["status": true])
                                
                                completion(true, nil)
                                return
                            }
                        })
                    }
                })
            }
        }
    }
}

