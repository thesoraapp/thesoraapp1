//
//  like.swift
//  Mung
//
//  Created by Jake Dorab on 2/7/17.
//  Copyright © 2017 Color & Space. All rights reserved.
//

import Foundation
import UIKit
import Parse
import MHPrettyDate

class likeClass {
    
    
    // Define how to fetch
    func fetchLikedGoals (perspective: PFObject?, indexStart: Int, indexEnd: Int, criteriaMap: [Bool], completion: @escaping ([goalsClass]?, Error?) -> Void)  {
        
        var goalsList = [goalsClass]()
        
        // setup quering
        
        let users = PFQuery(className: "User")
        let goals = PFQuery(className: "goals")
        let likes = PFQuery(className: "likes")
        
        
        /*
         criteriaMap : {
         
         0: byUserTopLikes:Bool
         1: byGlobal:Bool  // Just top liked goals irrespective of user
         2: byGlobalandUser:Bool // Top liked goals sorted by when user liked them... Used for discover page
         3: Just users goals sorted by creation date
         
         }
         
         */
        
        if criteriaMap[0] == true {
            if perspective != nil {
                self.fetchGoals(perspective: perspective, completion: { (goals, error) in
                    if goals! != [] {
                        
                        var trimmed : [PFObject]?
                        
                        if goals!.count < indexEnd {
                            let trimmed_ = goals?[indexStart..<goals!.count]
                            trimmed = Array(trimmed_!)
                        }
                        else {
                            let trimmed_ = goals?[indexStart..<indexEnd]
                            trimmed = Array(trimmed_!)
                        }
                        for goal_ in trimmed! {
                            let goalObj = goalsClass(goal: goal_)
                            goalsList.append(goalObj)
                            
                        }
                    }
                })
                if goalsList.count == (indexEnd - indexStart) {
                    completion(goalsList, nil)
                }
            }
            if goalsList.count < (indexEnd - indexStart) {
                self.fetchGoals(perspective: nil, completion: { (goals_, error) in
                    if goals_! != [] {
                        
                        var trimmed : [PFObject]?
                        
                        let neededCount = (indexEnd - indexStart) - goalsList.count
                        
                        if goals_!.count > neededCount {
                            let trimmed_ = goals_?[indexStart..<neededCount]
                            trimmed = Array(trimmed_!)
                        }
                        else if goals_!.count < indexEnd {
                            let trimmed_ = goals_?[indexStart..<goals_!.count]
                            trimmed = Array(trimmed_!)
                        }
                        else
                        {
                            let trimmed_ = goals_?[indexStart..<indexEnd]
                            trimmed = Array(trimmed_!)
                        }
                        for goal_ in trimmed! {
                            let goalObj = goalsClass(goal: goal_)
                            goalsList.append(goalObj)
                            
                        }
                        completion(goalsList, nil)
                    }
                })
            }
        }
        
        if criteriaMap[1] == true {
            
            goals.order(byAscending: "goalLikes")
            goals.findObjectsInBackground { (objects, error) in
                if error == nil {
                    
                    var trimmed : [PFObject]?
                    
                    if objects!.count < indexEnd {
                        let trimmed_ = objects?[indexStart..<objects!.count]
                        trimmed = Array(trimmed_!)
                    }
                    else {
                        let trimmed_ = objects?[indexStart..<indexEnd]
                        trimmed = Array(trimmed_!)
                    }
                    for goal_ in trimmed! {
                        let goalObj = goalsClass(goal: goal_)
                        goalsList.append(goalObj)
                    }
                    
                    completion(goalsList, nil)
                }
            }
        }
        
        
        if criteriaMap[2] == true {
            
            print("we get into likes")
            
            likes.includeKey("likeGoalParent")
            likes.whereKey("likeUserParent", equalTo: perspective)
            likes.findObjectsInBackground { (objects, error) in
                if error == nil {
                    
                    print("goalinLike")
                    print(objects)
                    
                    var trimmed : [PFObject]?
                    if objects! != [] {
                        
                        if objects!.count < indexEnd {
                            let trimmed_ = objects?[indexStart..<objects!.count]
                            trimmed = Array(trimmed_!)
                        }
                        else {
                            let trimmed_ = objects?[indexStart..<indexEnd]
                            trimmed = Array(trimmed_!)
                        }
                        for goal_ in trimmed! {
                            let goalObj = goalsClass(goal: goal_["likeGoalParent"] as! PFObject?)
                            goalsList.append(goalObj)
                            
                        }
                        
                        completion(goalsList, nil)
                    }
                }
            }
        }
        
        if criteriaMap[3] == true {
            
            goals.whereKey("goalAuthor", equalTo: perspective)
            goals.order(byAscending: "created_at")
            goals.findObjectsInBackground { (objects, error) in
                if error == nil {
                    var trimmed : [PFObject]?
                    if objects! != [] {
                        
                        if objects!.count < indexEnd {
                            let trimmed_ = objects?[indexStart..<objects!.count]
                            trimmed = Array(trimmed_!)
                        }
                        else {
                            let trimmed_ = objects?[indexStart..<indexEnd]
                            trimmed = Array(trimmed_!)
                        }
                        
                        
                        for goal_ in trimmed! {
                            let goalObj = goalsClass(goal: goal_)
                            goalsList.append(goalObj)
                            
                        }
                        completion(goalsList, nil)
                    }
                }
            }
        }
    }
    
    
    func updateLikes(userObj: PFUser, goalsClass_: goalsClass) {
        
        //update like count
        
        goalsClass_.goalObj?.incrementKey("goalLikes", byAmount: 1)
        goalsClass_.goalObj?.saveInBackground()
        
        //add relation
        let likes = PFObject(className: "likes")
        
        likes["likeGoalParent"] = goalsClass_.goalObj
        likes["likeUserParent"] = userObj
        
        likes.saveInBackground{(success, error) in
            if success == true {
                print(" saved to parse")
            } else {
                print("save failed: \(error)")
            }
        }
    }
    
    // TODO: Need to update to not return all goals from DB
    func fetchGoals(perspective: PFObject?, completion: @escaping ([PFObject]?, Error?) -> Void)  {
        
        var goalsList = [PFObject]()
        
        if perspective != nil {
            let likes = PFQuery(className: "goals")
            likes.includeKey("likeGoalParent")
            likes.whereKey("likeUserParent", equalTo: perspective)
            likes.order(byAscending: "createdAt")
            likes.findObjectsInBackground { (objects, error) in
                if error == nil {
                    if objects != nil {
                        for goal_ in objects! {
                            //let goalObj = goalsClass(goal: goal_["likeGoalParent"] as! PFObject?)
                            goalsList.append((goal_["likeGoalParent"] as! PFObject?)!)
                            
                        }
                        completion(goalsList, nil)
                    }
                }
            }
        } else {
            
            let goals = PFQuery(className: "goals")
            goals.order(byAscending: "createdAt")
            goals.findObjectsInBackground { (objects, error) in
                if error == nil {
                    if objects != nil {
                        for goal_ in objects! {
                            //let goalObj = goalsClass(goal: goal_["likeGoalParent"] as! PFObject?)
                            goalsList.append(goal_)
                            
                        }
                        completion(goalsList, nil)
                    }
                }
            }
        }
    }
}






