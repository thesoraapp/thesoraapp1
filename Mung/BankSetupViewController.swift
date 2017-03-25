//
//  BankSetupViewController.swift
//  Mung
//
//  Created by Jake Dorab on 11/21/16.
//  Copyright © 2016 Color & Space. All rights reserved.
//

import Foundation
import Parse
import UIKit
import WebKit
import Alamofire
import SwiftyJSON

class BankSetupViewController: UIViewController, UIWebViewDelegate, WKNavigationDelegate {
    
    var goalObject = goalsClass(goal: nil)
    var progress = UIView()
    
    @IBOutlet var containerView : UIView? = nil
    var webView: WKWebView!
    
    /* Define Plaid and Stripe Keys */
    
    var plaidSecret = "ca152607993354abddc89ab75e0a83"
    var plaidPublicKey = "f8cd9a6cb9e34bce6b79d4b7025f25"
    var plaidClientID = "58323031a753b969cf26fb75"
    
    /* Define Tokens for Testing Purposes */
    override func loadView() {
        self.webView = WKWebView()
        self.webView.navigationDelegate = self
        self.view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // load the link url
        let linkUrl = generateLinkInitializationURL()
        let url = URL(string: linkUrl)
        let request = URLRequest(url:url! as URL)
        self.webView.load(request as URLRequest)
        self.webView.allowsBackForwardNavigationGestures = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func unwindToRootViewController(segue: UIStoryboardSegue) {
        print("Unwind to Root View Controller")
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if let step3 = segue.destination as? goalsSetup3ViewController {
            
            step3.progress = helpers().progressBar(view: self, currentStep: 4, progressBar:self.progress, next: true)
            step3.goalObject = self.goalObject
            
        } else if let stepTwo = segue.destination as? goalsSetup2ViewController {
            
            stepTwo.progress = helpers().progressBar(view: self, currentStep: 3, progressBar:self.progress, next: false)
            stepTwo.goalObject = self.goalObject
            
        }
    }
    
    
    
    
    // getUrlParams :: parse query parameters into a Dictionary
    func getUrlParams(_ url: URL) -> Dictionary<String, String> {
        var paramsDictionary = [String: String]()
        let queryItems = URLComponents(string: (url.absoluteString))?.queryItems
        queryItems?.forEach { paramsDictionary[$0.name] = $0.value }
        return paramsDictionary
    }
    
    // generateLinkInitializationURL :: create the link.html url with query parameters
    func generateLinkInitializationURL() -> String {
        let config = [
            "key": plaidPublicKey,
            "product": "connect",
            "longtail": "true",
            "selectAccount": "true",
            "env": "tartan",
            "clientName": "Mung",
            "webhook": "https://requestb.in",
            "isMobile": "true",
            "isWebview": "true"
        ]
        
        // Build a dictionary with the Link configuration options
        // See the Link docs (https://plaid.com/docs/link) for full documentation.
        var components = URLComponents()
        components.scheme = "https"
        components.host = "cdn.plaid.com"
        components.path = "/link/v2/stable/link.html"
        components.queryItems = config.map { (URLQueryItem(name: $0, value: $1) as URLQueryItem) }
        return components.string!
    }
    
    /*
     Stripe Flow
     
     1. Check if stripe-generated customer ID exhibits in mLab.
     If not, pass information into stripe to get cust ID and update in mLab.
     
     2. First request to stripe. Pass in:
     Plaid info (account ID, access token, stripe generated ID).
     
     3. Get customer ID, and save in mLab
     
     4. Any future ACH requests are done using the customer ID stored in mLab.
     */
    
    
    func createStripeCust(accountID: String, access_token: String,
                          stripe_bank_account_token: String) {
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
        let b =  Alamofire.request(request).responseString {
            result in
            switch result.result {
            case .success(let jsonObject):
                print("SuccessRetrievedStripeCustomer")
                print(jsonObject)
            case .failure:
                print("Failed to retrieve Stripe customer :( ")
                
            }
        }
    }
    
    func getTransactionsData(plaidAccessToken: String) -> Void {
        let config = [
            "client_id": plaidClientID,
            "secret": plaidSecret,
            //"access_token": json["access_token"].rawString() ?? "something_went_wrong"
            "access_token": plaidAccessToken
        ]
        
        let components = NSURLComponents(string: "https://tartan.plaid.com/connect")!
        
        components.queryItems = config.map { URLQueryItem(name: $0, value: $1) }
        
        let linkUrl2 = components.string!
        let url2 = NSURL(string: linkUrl2)
        var request2 = URLRequest(url:url2! as URL)
        request2.httpMethod = "GET"
        
        _ =  Alamofire.request(request2).responseJSON { result2 in
            
            switch result2.result {
            case .success(let jsonObject2):
                let tsData = JSON(jsonObject2)
                
                print("TransactionsData")
                print(tsData)
                
                print("bankgoalTitle")
                print(self.goalObject.goalTitle)
                
                print("bankgoalImagePath")
                print(self.goalObject.goalImagePath)
                
                self.performSegue(withIdentifier: "step4", sender: self)
                
            case .failure:
                print("Something went wrong with retrieving the transactions :(")
                break
            }
        }
    }
    
    
    
    func getSaveAmount(plaidAccessToken: String?, bankID: String?, completion: @escaping (Double?, Error?) -> Void) {
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
        print("STEPINTOGETSAVEAMOUNT")
        request.httpMethod = "POST"
        _ =  Alamofire.request(request).responseString {
            result in
            print("result")
            print(result)
            switch result.result {
            case .success(let jsonObject):
                print("GETTINGWEEKLYSAVEAMOUNT")
                let weeklySaveAmount = Double(jsonObject)
                completion(weeklySaveAmount, nil)
            case .failure:
                print("someerrorwithgetsaveamount")
                completion(nil, NSError())
                break
            }
        }
    }
    
    
    
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping ((WKNavigationActionPolicy) -> Void)) {
        
        let linkScheme = "plaidlink";
        let actionScheme = navigationAction.request.url?.scheme;
        let actionType = navigationAction.request.url?.host;
        let queryParams = getUrlParams(navigationAction.request.url!)
        
        if (actionScheme == linkScheme) {
            switch actionType {
                
            case "connected"?:
                // Close the webview
                //self.dismiss(animated: true, completion: nil)
                
                // Parse data passed from Link into a dictionary
                // This includes the public_token as well as account and institution metadata
                print("Public Token: \(queryParams["public_token"])");
                print("Account ID: \(queryParams["account_id"])");
                print("Institution type: \(queryParams["institution_type"])");
                print("Institution name: \(queryParams["institution_name"])");
                
                
                // Plaid ccount details
                
                let publicToken = queryParams["public_token"] ?? ""
                let accountID = queryParams["account_id"] ?? ""
                
                
                let config = [
                    "client_id": "58323031a753b969cf26fb75",
                    "secret": "ca152607993354abddc89ab75e0a83",
                    "public_token": publicToken,
                    "account_id": accountID
                ]
                
                print("PublicTokenFINAL")
                
                /*
                 e616aca0b2310fd19d3d001c84988e91986176436aa1f7f81661fca67a3093bcaf01d646b1f27f4698d524a83a6c5cadce9e184b02f0a5c7c7f10e72f339e8c3
                 
                 */
                
                print(publicToken)
                
                print("AccountIDFINAL")
                
                /*
                 
                 631RRwA3pBsYP3Lp8rE3I7jjoVwvqAswJjNq8
                 
                 */
                
                print(accountID)
                
                
                var components = URLComponents()
                components.scheme = "https"
                components.host = "tartan.plaid.com"
                components.path = "/exchange_token"
                components.queryItems = config.map { (URLQueryItem(name: $0, value: $1) as URLQueryItem) }
                
                if let url = URL(string: components.string!)! as? URL {
                    var request = URLRequest(url:url)
                    
                    request.httpMethod = "POST"
                    let b =  Alamofire.request(request).responseJSON {
                        
                        result in
                        switch result.result {
                        case .success(let jsonObject):
                            let plaidTokens = JSON(jsonObject)
                            
                            print("PlaidTokensABC")
                            print(jsonObject)
                            
                            plaidTokens["account_id"]
                            print(plaidTokens["access_token"].rawString() ?? "somethingwentwrong")
                            
                            // should first check if customer ID exists before creating new cust.
                            
                            self.createStripeCust(accountID: accountID, access_token: plaidTokens["access_token"].rawString() ?? "somethingwentwrong", stripe_bank_account_token: plaidTokens["stripe_bank_account_token"].rawString() ?? "somethingwentwrong")
                            
                            
                            //                            self.getTransactionsData(plaidAccessToken: plaidTokens["access_token"].rawString() ?? "somethingwentwrong")
                            
                            
                            helperFuns().getBankMetaData(completion: {accesstokens, bankIDs, stuff, error in
                                print("RateGetBankMetaData")
                            })
                            
                            self.getSaveAmount(plaidAccessToken: plaidTokens["access_token"].rawString() ?? "somethingwentwrong", bankID: plaidTokens["account_id"].rawString() ?? "somethingwentwrong", completion: { weeklysaveamount, error in
                                
                                print("did call transition to goal setup 3")
                                
                                let nextvC = self.storyboard?.instantiateViewController(withIdentifier: "step3") as! goalsSetup3ViewController
                                nextvC.goalObject = self.goalObject
                                nextvC.weeklySaveAmount = weeklysaveamount
                                self.show(nextvC, sender: self)
                            })
                        case .failure:
                            print("Something went wrong with retrieving Plaid tokens :( ")
                            break
                        }
                    }
                }
                
                
                break
            case "exit"?:
                
                // Close the webview
                // self.dismiss(animated: true, completion: nil)
                
                // Parse data passed from Link into a dictionary
                // This includes information about where the user was in the Link flow
                // any errors that occurred, and request IDs
                print("URL: \(navigationAction.request.url?.absoluteString)")
                // Output data from Link
                print("User status in flow: \(queryParams["status"])");
                // The requet ID keys may or may not exist depending on when the user exited
                // the Link flow.
                print("Link request ID: \(queryParams["link_request_id"])");
                print("Plaid API request ID: \(queryParams["link_request_id"])");
                break
                
            default:
                print("Link action detected: \(actionType)")
                break
            }
            
            decisionHandler(.cancel)
        } else if (navigationAction.navigationType == WKNavigationType.linkActivated &&
            (actionScheme == "http" || actionScheme == "https")) {
            // Handle http:// and https:// links inside of Plaid Link,
            // and open them in a new Safari page. This is necessary for links
            // such as "forgot-password" and "locked-account"
            UIApplication.shared.openURL(navigationAction.request.url!)
            decisionHandler(.cancel)
        } else {
            print("Unrecognized URL scheme detected that is neither HTTP, HTTPS, or related to Plaid Link: \(navigationAction.request.url?.absoluteString)");
            decisionHandler(.allow)
        }
    }
}
