//
//  helperFuns.swift
//  Mung
//
//  Created by Jake Dorab on 2/11/17.
//  Copyright © 2017 Color & Space. All rights reserved.
//

import Foundation
import UIKit
import Parse
import MHPrettyDate
import Alamofire

extension Double {
    /// Rounds the double to decimal places value
    func roundTo(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

extension Date {
    func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd yyyy"
        return dateFormatter.string(from: self)
    }
}


class helperFuns {
    
    func getImageData (urlString: String?, completion: @escaping (UIImage?, Error?) -> Void)  {
        if urlString != nil {
            if let urlString_ =  URL(string: urlString!)! as? URL {
                URLSession.shared.dataTask(with: urlString_) { (data, response, error) in
                    if error == nil {
                        DispatchQueue.main.async {
                            completion(UIImage(data: data!), nil)
                        }
                    }
                    else {
                        completion(nil, NSError())
                    }
                    }.resume()
            }
        } else {
            completion(nil, nil)
        }
    }
    
    
    func checkIfLinkedAccount (completion: @escaping (Bool?, Error?) -> Void) {
        let TQuery = PFQuery(className: "bankTokens")
        TQuery.whereKey("parseUserID", equalTo: PFUser.current() )
        TQuery.findObjectsInBackground { (objects, error) in
            if objects! != [] {
                completion(true, nil)
            } else {
                completion(false, nil)
            }
        }
    }
    
    
    func getBankMetaData (completion: @escaping ([String]?, [String]?, Any?, Error?) -> Void) {
        
        print("we are in getbankmetadata")
        
        var components = URLComponents()
        // modify to https when migrating to google cloud
        components.scheme = "http"
        components.host = "localhost"
        components.port = 8080
        components.path = "/getBankMetaData2"
        
        var AccessTokens = String()
        var AccountIds = String()
        
        AccessTokens = ""
        AccountIds = ""
        
        var AccessTokensList = [String]()
        var BankIDsList = [String]()
        
        let TQuery = PFQuery(className: "bankTokens")
        TQuery.whereKey("parseUserID", equalTo: PFUser.current() )
        TQuery.findObjectsInBackground { (objects, error) in
            print("objectsUniverse")
            print(objects)
            
            if objects! != [] {
                var TokenList : [(String,String)]
                
                let BankIDs = objects?[0]["bankIDs"] as? [String:Any]
                
                for (key, value) in BankIDs! {
                    let value1 = value as? [String:String]
                    let access_token = value1?["access_token"]
                    let account_id = value1?["account_id"]
                    
                    AccessTokensList.append(access_token!)
                    BankIDsList.append(account_id!)
                    
                    if AccessTokens == "" {
                        AccessTokens = AccessTokens + String(describing: access_token!)
                        AccountIds = AccountIds + String(describing: account_id!)
                    } else {
                        AccessTokens = AccessTokens + "," + String(describing: access_token!)
                        AccountIds = AccountIds + "," + String(describing: account_id!)
                    }
                }
                let dataFields = [
                    // "sandbox": false,
                    "plaidAccessTokens": AccessTokens,
                    "bankIDs" : AccountIds
                ]
                
                
                //                "bankID3": {
                //                    "access_token": "e616aca0b2310fd19d3d001c84988e91986176436aa1f7f81661fca67a3093bcaf01d646b1f27f4698d524a83a6c5cadce9e184b02f0a5c7c7f10e72f339e8c3",
                //                    "account_id": "631RRwA3pBsYP3Lp8rE3I7jjoVwvqAswJjNq8"
                //                }
                
                
                components.queryItems = dataFields.map { (URLQueryItem(name: $0, value: $1) as URLQueryItem) }
                let url = URL(string: components.string!)
                var request = URLRequest(url: url!)
                request.httpMethod = "POST"
                _ =  Alamofire.request(request).responseString {
                    result in
                    print("result")
                    print(result)
                    
                    
                    switch result.result {
                    case .success(let jsonObject):
                        
                        // Bank Data Array
                        
                        print("jsonObjectMasteroftheUniverse")
                        print(jsonObject)
                        
                        completion(AccessTokensList,BankIDsList , jsonObject, nil)
                        
                        
                    case .failure:
                        print("someerrorwithgetsaveamount")
                        completion(nil, nil, nil, nil)
                        break
                    }
                }
            }
        }
    }
    
    
    func getSaveAmount(plaidAccessToken: String, bankID: String, completion: @escaping (Double?, Error?) -> Void) {
        var components = URLComponents()
        // modify to https when migrating to google cloud
        components.scheme = "http"
        components.host = "localhost"
        components.port = 8080
        components.path = "/getSaveAmount1"
        
        // TODO Write getSaveAmount function in server side
        print("plaidAccessToken")
        print(plaidAccessToken)
        
        let dataFields = [
            // "sandbox": false,
            "plaidAccessToken": plaidAccessToken,
            "bankID" : bankID
        ]
        components.queryItems = dataFields.map { (URLQueryItem(name: $0, value: $1) as URLQueryItem) }
        let url = URL(string: components.string!)
        var request = URLRequest(url: url!)
        print("STEPINTOGETSAVEAMOUNTHelperFuns1.a")
        request.httpMethod = "POST"
        _ =  Alamofire.request(request).responseString {
            result in
            print("resultHelperFuns1.a")
            print(result)
            switch result.result {
            case .success(let jsonObject):
                print("GETTINGWEEKLYSAVEAMOUNT")
                let weeklySaveAmount = Double(jsonObject)
                completion(weeklySaveAmount, nil)
            //print("Sucess")
            case .failure:
                print("someerrorwithgetsaveamount")
                completion(nil, NSError())
                break
            }
        }
    }
    
    
    func convertTargetDate (targetDate: Date) -> String {
        let curDate = Date()
        
        var prettyTargetDate = String()
        
        let hoursRemain = targetDate.hours(from: curDate)
        let daysRemain = targetDate.days(from: curDate)
        let weeksRemain = targetDate.weeks(from: curDate)
        let monthsRemain = targetDate.months(from: curDate)
        let yearsRemain = targetDate.years(from:curDate)

        print("daysRemain")
        print(daysRemain)
        print("weeksRemain")
        print(weeksRemain)
        print("monthsRemain")
        print(monthsRemain)
        
        
        if (daysRemain > 0) && (weeksRemain == 0) {
            if daysRemain == 1 {
                prettyTargetDate = "\(daysRemain) day"
            }
            else {
                prettyTargetDate = "\(daysRemain) days"
            }
        }
        
        else if (weeksRemain > 0) && (daysRemain < 14) {
            if daysRemain == 1 {
                prettyTargetDate = "1 week and \(daysRemain - 7) day"
            }
            else {
                prettyTargetDate = "1 week and \(daysRemain - 7) days"
            }
        }
        else if (weeksRemain > 0) && (monthsRemain == 0) {
            print("Goal reached this week")
            prettyTargetDate = "\(weeksRemain) weeks"
        
        }
        else if (monthsRemain > 0) && (monthsRemain < 4) {
            let numWeeksLeft = weeksRemain - monthsRemain * 4
            if monthsRemain == 1 {
                if numWeeksLeft == 0 {
                    prettyTargetDate = "\(monthsRemain) month"
                }
                else {
                    if numWeeksLeft == 1 {
                        prettyTargetDate = "\(monthsRemain) month and \(numWeeksLeft) week"
                    } else {
                        prettyTargetDate = "\(monthsRemain) month and \(numWeeksLeft) weeks"
                    }
                }
            } else {
                if numWeeksLeft == 0 {
                    prettyTargetDate = "\(monthsRemain) months"
                }
                else {
                    if numWeeksLeft == 1 {
                        prettyTargetDate = "\(monthsRemain) months and \(numWeeksLeft) week"
                    } else {
                        prettyTargetDate = "\(monthsRemain) months and \(numWeeksLeft) weeks"
                    }
                }
            }
        }
        else if (monthsRemain > 4) && (yearsRemain == 0) {

            prettyTargetDate = "\(monthsRemain) months"
        }
        else if yearsRemain > 1 {
            print("Goal reached this week")
            let numMonthsLeft = yearsRemain*12 - monthsRemain
            if numMonthsLeft == 1 {
                prettyTargetDate = "\(yearsRemain) years and \(numMonthsLeft) month"

            } else {
                prettyTargetDate = "\(yearsRemain) years and \(numMonthsLeft) months"
            }
        }
        return prettyTargetDate
    }
}


