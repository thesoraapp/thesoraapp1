//
//  goal.swift
//  Mung
//
//  Created by Jake Dorab on 10/18/16.
//  Copyright © 2016 Color & Space. All rights reserved.
//

import Foundation
import UIKit
import Parse
import MHPrettyDate
import Alamofire

class goalsClass {
    
    var goalObj: PFObject?
    var objectId : String?
    var goalImagePath : String?
    var goalTitle : String?
    
    var goalAuthorObject: PFUser?
    var goalAuthorUserClass: UserClass?
    
    var goalAuthorId: String?
    var goalAuthorName : String?
    var goalAuthorImagePath : String?
    var goalLikeCount : Int?
    var goalCommentCount : Int?
    
    var goalTarget : Double?
    
    var curUserLikedBool : Bool?
    
    var goalCategory : String?
    var goalTags : [WSTag]?
    
    var goalImageFile : UIImage?
    
    
    var goalTotalSaved : Double?
    var goalSaveRate : Double?
    var goalEndDate : Date?
    var goalTimeLeft : String?
    
    var goalAmountRemain : Double?
    var goalPercComplete : Int?
    
    var paymentSchedule : [String: Any]?
    var lastPayment : Double?
    
    //    var delegate : updateDelegate?
    
    init( goal: PFObject? = nil ) {
        
        if goal == nil {
            self.goalObj = nil
            self.goalAuthorObject = nil
            self.goalAuthorUserClass = nil
            self.goalAuthorId = nil
            self.goalImagePath = nil
            self.goalTitle = nil
            self.goalLikeCount = nil
            self.goalCommentCount = nil
            self.curUserLikedBool = nil
            self.goalCategory = nil
            self.goalCategory = nil
            self.goalTags = nil
            self.goalSaveRate = nil
            self.goalTarget = nil
            self.goalImageFile = nil
            self.goalEndDate = nil
            self.goalTotalSaved = nil
            self.goalSaveRate = nil
            self.goalTimeLeft = nil
            self.goalAmountRemain = nil
            self.goalPercComplete = nil
            self.paymentSchedule = nil
            self.lastPayment = nil
            
            
        }
        else {
            
            self.goalObj = goal
            self.objectId = goal?.objectId
            
            self.goalAuthorObject = goal?["goalAuthor"] as! PFUser?
            //        self.goalAuthorUserClass = UserClass(user: goal?["goalAuthor"] as! PFObject)
            
            self.goalImagePath = goal?["goalImagePath"] as! String?
            self.goalTitle = goal?["goalTitle"] as! String?
            self.goalLikeCount = goal?["goalLikeCount"] as! Int?
            self.goalCommentCount = goal?["goalCommentCount"] as! Int?
            
            self.goalTarget = goal?["goalTarget"] as! Double?
            self.goalEndDate = goal?["goalEndDate"] as! Date?
            self.goalCategory = goal?["goalCategory"] as! String?
            
            
            
            
            do {
                try self.goalAuthorObject?.fetchIfNeeded()
                self.goalAuthorImagePath = self.goalAuthorObject!["userImagePath"] as? String
            } catch let exception {
                print("Exception: \(exception)")
            }
            
            
            self.goalAuthorName = self.goalAuthorObject!["userFullName"] as! String?
            
            
            let curDate = Date()
            let hoursRemain = self.goalEndDate!.hours(from: curDate)
            let daysRemain = self.goalEndDate!.days(from: curDate)
            let weeksRemain = self.goalEndDate!.weeks(from: curDate)
            let monthsRemain = self.goalEndDate!.months(from: curDate)
            let yearsRemain = self.goalEndDate!.years(from:curDate)
            
            
            if hoursRemain < 0 || daysRemain < 0{
                print("Goal reached today")
                self.goalTimeLeft = "GOAL COMPLETE"
            }
            if hoursRemain == 0 {
                print("Goal reached today")
                self.goalTimeLeft = "GOAL REACHED TODAY!"
            }
            if daysRemain == 0 {
                print("Goal reached today")
                self.goalTimeLeft = "GOAL REACHED TODAY!"
            }
            if (daysRemain > 0) && (weeksRemain == 0) {
                print("Goal reached this week")
                self.goalTimeLeft = "\(daysRemain) DAYS TO GO"
            }
            if (weeksRemain > 0) && (monthsRemain == 0) {
                print("Goal reached this week")
                self.goalTimeLeft = "\(weeksRemain) WEEKS  TO GO"
            }
            if (monthsRemain > 0) && (monthsRemain < 4) {
                print("Goal reached this week")
                self.goalTimeLeft = "\(monthsRemain) MONTHS AND \(weeksRemain) WEEKS  TO GO"
            }
            if (monthsRemain > 4) && (yearsRemain == 0) {
                print("Goal reached this week")
                self.goalTimeLeft = "\(monthsRemain) MONTHS TO GO"
            }
            if yearsRemain > 1 {
                print("Goal reached this week")
                self.goalTimeLeft = "\(yearsRemain) YEARS AND \(monthsRemain) MONTHS  TO GO"
            }
            
            
            
            
            
            
            //self.getCurUserLikedBool()
            
        }
    }
    
    func getCurUserLikedBool(completion: @escaping (Bool) -> Void) {
        
        if PFUser.current() != nil {
            let liked = PFQuery(className: "likes")
            liked.whereKey("likeUserParent", equalTo: PFUser.current()!)
            liked.whereKey("likeGoalParent", equalTo: self.goalObj)
            liked.findObjectsInBackground { (objects, error) in
                if objects! != [] {
                    completion(true)
                }
                else {
                    completion(false)
                }
            }
        }
        else {
            // do smthg
        }
    }
    
    /*
     
     func getCurUserLikedBool() {
     
     if PFUser.current() != nil {
     
     let liked = PFQuery(className: "likes")
     liked.whereKey("likeUserParent", equalTo: PFUser.current()!)
     liked.whereKey("likeGoalParent", equalTo: self.goalObj)
     liked.findObjectsInBackground { (objects, error) in
     
     print("errorinCurUserLikeBool")
     print(error)
     print(objects)
     
     if objects != nil {
     
     print("settingcurUserLikeBooltoTrue")
     
     self.curUserLikedBool = true
     }
     else {
     self.curUserLikedBool = false
     }
     }
     }
        else {
            self.curUserLikedBool = false
        }
        
    }
 
 */

    
    
    
    func retrieveGoalObj(goalID: String) {
        
        let goals = PFQuery(className: "goals")
        goals.whereKey("objectId", equalTo: goalID)
        goals.findObjectsInBackground { (objects, error) in
            
            if error == nil {
                
                self.objectId = objects?[0]["objectId"] as! String?
                self.goalAuthorObject = objects?[0]["_p_goalAuthor"] as! PFUser?
                self.goalImagePath = objects?[0]["goalImagePath"] as! String?
                self.goalTitle = objects?[0]["goalTitle"] as! String?
                self.goalLikeCount = objects?[0]["goalLikeCount"] as! Int?
                self.goalTarget = objects?[0]["goalTarget"] as! Double?
                self.goalEndDate = objects?[0]["goalEndDate"] as! Date?
                
                
                //                self.goalAuthorImagePath = self.goalAuthorObject!["userImagePath"] as! String?
                //                self.goalAuthorName = self.goalAuthorObject!["userFullName"] as! String?
                
                
                //                let goalAllocationObject = objects?[0]["_p_userGoalAllocations"] as! PFObject?
                //                self.goalTotalSaved = goalAllocationObject!["userGoalTotalSaved"] as! Double?
                //                self.goalSaveRate = goalAllocationObject!["userGoalAllocDesignatedRate"] as! Double?
                //
                //                if self.goalTarget != nil {
                //
                //                    self.goalAmountRemain = self.goalTarget! - self.goalTotalSaved!
                //                    self.goalpercComplete = (1 - (self.goalAmountRemain!/self.goalTarget!)) * 100
                //
                //                }
                
            }
        }
    }
    
    
    
    func updateGoalClassDB(objectID: String, goalAuthorObject: PFUser? = nil, goalImagePath: String? = nil,
                           goalTitle: String? = nil, goalLikeCount: Int? = nil, goalTarget: Double? = nil, goalCommentCount: Int? = nil,
                           goalEndDate: Date? = nil, completion: @escaping (Bool?) -> Void ) {
        
        
        
        
        print("UPDATEGOALCLASS")
        // XYZ - Addition to update function
        if goalTitle != nil {
            print("titledone")
            print(goalTitle!)
            self.goalTitle = goalTitle!
        }
        if goalImagePath != nil {
            print("imagedone")
            print(goalImagePath!)
            self.goalImagePath = goalImagePath!
        }
        
        
        
        let query = PFQuery(className: "goals")
        
        query.getObjectInBackground(withId: objectID) { (object, error) in
            if error == nil {
                
                if goalAuthorObject != nil {
                    object?["_p_goalAuthor"] = goalAuthorObject!
                }
                if goalTitle != nil {
                    object?["goalTitle"] = goalTitle!
                }
                if goalImagePath != nil {
                    object?["goalImagePath"] = goalImagePath!
                }
                if goalLikeCount != nil {
                    object?["goalLikeCount"] = goalLikeCount!
                }
                if goalCommentCount != nil {
                    object?["goalCommentCount"] = goalCommentCount!
                }
                if goalTarget != nil {
                    object?["goalTarget"] = goalTarget!
                }
                if goalEndDate != nil {
                    object?["goalTarget"] = goalEndDate!
                }
                
            }
            object?.saveInBackground(block: { (saved, error) in
                
                if error == nil && saved{
                    
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "meGoalsToggled"), object: nil, userInfo: ["status": true])
                    print(saved)
                    completion(true)
                    
                } else {
                    
                    print(error)
                    
                }
            })
        }
    }
    
    
    
    func saveGoalClassinDB(completion: @escaping (Bool?) -> Void ) {   //Use to create a brand new goal
        
        let goalObj = PFObject(className: "goals")
        
        goalObj["goalAuthor"] = self.goalAuthorObject
        goalObj["goalImagePath"] = self.goalImagePath
        goalObj["goalTitle"] = self.goalTitle
        goalObj["goalTarget"] = self.goalTarget
        goalObj["goalEndDate"] = self.goalEndDate
        goalObj["goalCategory"] = self.goalCategory
        //        goalObj["goalCategory"] = 0
        //        goalObj["goalSaveRate"] = self.goalSaveRate

        
        goalObj.saveInBackground { (success, error) in
            if success == true {
                completion(true)
                
                NotificationCenter.default.post(name: Notification.Name(rawValue: "meGoalsToggled"), object: nil, userInfo: ["status": true])
            }
        }
    }
    
    
    func userGoalAllocation2(completion: @escaping (Error?) -> Void) {
            let goalAlloc = PFQuery(className: "userGoalAllocations")
            goalAlloc.whereKey("userGoalID", equalTo: self.goalObj)
            goalAlloc.findObjectsInBackground { (objects, error) in
                if objects! != [] {
                    for obj in objects! {
                        self.goalTotalSaved = obj["userGoalTotalSaved"] as! Double?
                        self.goalSaveRate = obj["userGoalAllocDesignatedRate"] as! Double?
                        if self.goalTarget != nil {
                            self.goalAmountRemain = self.goalTarget! - self.goalTotalSaved!
                            self.goalPercComplete = Int(((1 - (self.goalAmountRemain!/self.goalTarget!)) * 100))
                        }
                    }
                    completion(nil)
                }
                else {
                    // TODO: Need to create an instance of an Error object here
                    completion(nil)
                }
            }
        }
    
    
      
    func goalPaymentSchedule2(completion: @escaping (Error?) -> Void) {
        let paymentScheduleObject = PFQuery(className: "paymentSchedule")
        paymentScheduleObject.whereKey("parseGoalID", equalTo: self.goalObj)
        paymentScheduleObject.findObjectsInBackground{ (objects, error) in
            if objects! != [] {
                for obj in objects! {
                    if let paymentSchedule_ = obj["paymentSchedule"] as? [String: Any] {
                        self.paymentSchedule = paymentSchedule_
                        
                        if let lastPayment = paymentSchedule_["payment001"] as? [String: Any] {
                            if let amount = lastPayment["paymentAmount"] as? Double {
                                self.lastPayment = amount
                                completion(nil)
                                //print("The amount is \(amount)")
                            }
                        }
                    }
                }
            }
        }
    }

    
                    
//
//        if let paymentSchedule_ = paymentScheduleObject["paymentSchedule"] as? [String: Any] {
//                self.paymentSchedule = paymentSchedule_
//
//                if let lastPayment = paymentSchedule_["payment001"] as? [String: Any] {
//                    if let amount = lastPayment["paymentAmount"] as? Double {
//                        self.lastPayment = amount
//                        //print("The amount is \(amount)")
//                    }
//                }
//            }
//        }


    
    func getUserGoals (perspective: PFUser?, completion: @escaping ([goalsClass]?, Error?) -> Void)  {
        
        var goalsList = [goalsClass]()
        goalsList.removeAll(keepingCapacity: true)
        
        let goalsQuery = PFQuery(className: "goals")
        goalsQuery.whereKey("goalAuthor", equalTo: perspective)
        goalsQuery.includeKey("goalAuthor")
        goalsQuery.includeKey("userGoalAllocations")
        goalsQuery.includeKey("paymentSchedule")
        
        goalsQuery.findObjectsInBackground { (objects, error) in
            if error == nil {
                if objects != nil {
                    for goal_ in objects! {
                        let goalObj = goalsClass(goal: goal_)
                        goalsList.append(goalObj)
                    }
                    completion(goalsList, nil)
                }
                else {
                    completion(nil, nil)
                }
            }
        }
    }
    
    
    func toggleLike(completion: @escaping (Bool, Error?) -> Void) {
        
        // Get index from sender
        //let indexRow = sender.tag
        var showLiked : Bool?
        
        if let currentUser = PFUser.current() {
            if currentUser == nil {
                
                // segue to Login (and dismiss when done)
            } else {
                self.getCurUserLikedBool(completion: { isLiked in
                    if isLiked == true {
                        let likedQuery = PFQuery(className: "likes")
                        likedQuery.whereKey("likeUserParent", equalTo: currentUser)
                        likedQuery.whereKey("likeGoalParent", equalTo: self.goalObj)
                        likedQuery.findObjectsInBackground { (goalobjects, error) in
                            print("goalobjects1.a")
                            print(goalobjects)
                            if goalobjects! != [] {
                                for goal_ in goalobjects! {
                                    goal_.deleteInBackground(block: { (success, error) in
                                        if success {
                                            completion(false, nil)
                                            return
                                        }
                                    })
                                }
                            }
                        }
                    } else {
                        let likeObj = PFObject(className: "likes")
                        likeObj["likeUserParent"] = currentUser
                        likeObj["likeGoalParent"] = self.goalObj
                        likeObj.saveInBackground(block: { (success, error) in
                            if success {
                                
                                NotificationCenter.default.post(name: Notification.Name(rawValue: "likedGoalsToggled"), object: nil, userInfo: ["status": true])
                                
                                completion(true, nil)
                                return
                            }
                        })
                    }
                })
            }
        }
    }
    
    
    func createPaymentSchedule(completion: @escaping (Bool?, Error?) -> Void) {
        var components = URLComponents()
        
        // modify to https when migrating to google cloud
        components.scheme = "http"
        components.host = "localhost"
        components.port = 8080
        components.path = "/createPaymentSchedule"
        
        // TODO Write getSaveAmount function in server side
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.A"
        let presentDate = dateFormatter.string(from: now)
        
        let dataFields = [
            // "sandbox": false,
            //"userID": PFUser.current()!.username,
            "userID": "qrnZdbT2rL",
            "goalID": self.objectId,
            "paymentRate": String(describing: self.objectId),
            "interval": "7",
            "firstPaymentDate": presentDate
        ]
        components.queryItems = dataFields.map { (URLQueryItem(name: $0, value: $1) as URLQueryItem) }
        let url = URL(string: components.string!)
        var request = URLRequest(url: url!)
        
        request.httpMethod = "POST"
        _ =  Alamofire.request(request).responseString {
            result in
            print("result")
            print(result)
            switch result.result {
            case .success(let object):
                if String(object) == "completed" {
                    print("Creating payment schedule")
                    completion(true, nil)
                }
                else {
                    completion(false, nil)
                }
            case .failure:
                print("some random error with creating payment schedule")
                completion(nil, NSError())
                break
            }
        }
    }

}


