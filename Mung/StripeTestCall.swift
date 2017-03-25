//
//  StripeTestCall.swift
//  Mung
//
//  Created by Jake Dorab on 12/24/16.
//  Copyright © 2016 Color & Space. All rights reserved.
//

import Foundation
import Parse
import UIKit
import WebKit
import Alamofire
import SwiftyJSON


class StripeTestCallViewController: UIViewController, UIWebViewDelegate, WKNavigationDelegate {
    
    @IBOutlet var containerView : UIView? = nil
    
    var webView: WKWebView!
    
    
    /* Define Plaid and Stripe Keys */
    
    var plaidSecret = "ca152607993354abddc89ab75e0a83"
    
    var plaidPublicKey = "f8cd9a6cb9e34bce6b79d4b7025f25"
    
    var plaidClientID = "58323031a753b969cf26fb75"
    
    /* Define Tokens for Testing Purposes */
    
    
    var stripeBankAccountToken = "btok_9ohpAOhunoNhdQ"
    
    var plaidAccessToken = "e616aca0b2310fd19d3d001c84988e91241cd4d0000a6eae14cc509150c417f719fc06eab3246c739b8715a6335764d3d4838eba1e97b9866497155b9618bc9d33f72565e11fc7a94f268dc741a9ee9f"
    
    var plaidAccountIDToken = "AOKOmYkgABUeVLDbewQXFDQQ9vALBxHMa9nYV"
    
    
    override func loadView() {
        self.webView = WKWebView()
        self.webView.navigationDelegate = self
        self.view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //checkStripCustExists()
        
        //createStripeCust(accountID: plaidAccountIDToken, access_token: plaidAccessToken, stripe_bank_account_token: stripeBankAccountToken)
        
        // expressed in cents $
        authorizeACH(amount: 50, date: "2016-11-24T14:52:55.874Z")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}


func authorizeACH(amount: Int, date: String) {
    
    getStripeCust(accountID: "AOKOmYkgABUeVLDbewQXFDQQ9vALBxHMa9nYV", access_token: "e616aca0b2310fd19d3d001c84988e91241cd4d0000a6eae14cc509150c417f719fc06eab3246c739b8715a6335764d3d4838eba1e97b9866497155b9618bc9d33f72565e11fc7a94f268dc741a9ee9f", stripe_bank_account_token: "btok_9ohpAOhunoNhdQ", completion: { stripeCustomerID, error in
        if error == nil {
            if let stripeCustomerID = stripeCustomerID {
                
                // We have a stripeCustomerID... do something useful
                print("stripeCustomerID")
                print(stripeCustomerID)
                print("stripeCustomerIDEND")
                
                // authorize the transaction
                var components = URLComponents()
                components.scheme = "http"
                components.host = "localhost"
                components.port = 8080
                components.path = "/StripeACHAuthorize"
                
                let amountACH = String(amount)
                
                // bankaccountID
                // ba_19V4PtAT33Vr00hhoVA4VPNM
                
                
                let dataFields = [
                    // "sandbox": false,
                    "amountACH": amountACH,
                    "currencyACH": "USD",
                    // "customerACH": stripeCustomerID!,
                    "customerACH": stripeCustomerID,
                    ] as! [String: String]
                
                print("dataFieldsACH")
                print(dataFields)
                
                components.queryItems = dataFields.map { (URLQueryItem(name: $0, value: $1) as URLQueryItem) }
                
                let url = URL(string: components.string!)
                var request = URLRequest(url: url!)
                
                request.httpMethod = "POST"
                _ =  Alamofire.request(request).responseString {
                    result in switch result.result {
                    case .success:
                        print("Success posted ACH")
                        
                        // Create Record of ACH Transaction
                        
                        let ACHAuthorizations = PFObject(className: "ACHAuthorizations")
                        
                        ACHAuthorizations["stripeCustId"] = stripeCustomerID
                        ACHAuthorizations["ACHAuthorizationDate"] = NSDate()
                        ACHAuthorizations["ACHAmount"] = amountACH
                        ACHAuthorizations["ACHComplete"] = false
                        ACHAuthorizations["ACHDispute"] = false
                        ACHAuthorizations["ACHDisputeReason"] = "nil"
                        
                        ACHAuthorizations.saveInBackground{(success, error) in
                            if(success) {
                                print("Saved ACH Authorization Record")
                            }
                        }
                        
                    case .failure:
                        print("Failure to post ACH :( ")
                        break
                    }}
            }}
    })}





func getStripeCust(accountID: String, access_token: String, stripe_bank_account_token: String,completion: @escaping (String?, Error?) -> Void) {
    
    let stripCustParse = PFQuery(className: "stripeCustomer")
    
    if let currentUser = PFUser.current() {
        stripCustParse.whereKey("parseUserID", equalTo: currentUser)
    }
    
    stripCustParse.findObjectsInBackground { (objects, error) in
        if error == nil && (objects! != []) {
            
            print("Found stripe customer")
            
            for stripCust in objects! {
                let stripeCustID = stripCust["stripeCustId"] as! String
                
                print("stripeCust")
                print(stripeCustID)
                //custID = stripeCustID
                completion(stripeCustID, nil)
            }
        }
        else {
            
            //var stripeCustomerID = "nil"
            
            var components = URLComponents()
            components.scheme = "http"
            components.host = "localhost"
            components.port = 8080
            components.path = "/StripeCustomerCredentials"
            
            let dataFields = [
                // "sandbox": false,
                "account_id": accountID,
                "access_token": access_token,
                "stripe_bank_account_token": stripe_bank_account_token
            ]
            
            print("Datafields")
            print(dataFields)
            
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
                    
                    print("SuccessRetrievedStripeCustomer")
                    print(jsonObject)
                    let stripeCustomerID = jsonObject
                    
                    // Save the the new Customer ID in mLAB
                    
                    let newStripeCustomer = PFObject(className: "stripeCustomer")
                    
                    newStripeCustomer["stripeCustId"] = stripeCustomerID
                    newStripeCustomer["parseUserID"] = PFUser.current()
                    newStripeCustomer.saveInBackground{(success, error) in
                        if(success) {
                            print("Saved New Customer")
                        }
                    }
                    
                    completion(stripeCustomerID, nil)
                    
                //print("Sucess")
                case .failure:
                    print("Failed to retrieve Stripe customer :( ")
                    completion(nil, NSError())
                    break
                }
            }
        }
    }
}
