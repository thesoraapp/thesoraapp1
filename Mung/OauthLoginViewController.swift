//
//  OauthLoginViewController.swift
//  Mung
//
//  Created by Jake Dorab on 11/6/16.
//  Copyright © 2016 Color & Space. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import Alamofire
import SwiftyJSON
import Parse
import MBProgressHUD


class OauthLoginViewController: UIViewController, UIWebViewDelegate {
    
    var coreDataStack: CoreDataStack!

    @IBOutlet weak var webView: UIWebView!
    var spinningActivity = MBProgressHUD()
    
    @IBAction func cancelButton(_ sender: Any) {
        
    self.navigationController?.popViewController(animated: false)
        
    
    }
    
    
    //var coreDataStack: CoreDataStack!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = false
        
        
        print("VIEW WILL APPEAR")
        
        self.spinningActivity = MBProgressHUD.showAdded(to: self.view, animated: true)
        // spinningActivity?.labelText = ""
        self.spinningActivity.isUserInteractionEnabled = false

 
       // webView.isHidden = true
        URLCache.shared.removeAllCachedResponses()
        if let cookies = HTTPCookieStorage.shared.cookies {
            for cookie in cookies {
                HTTPCookieStorage.shared.deleteCookie(cookie)
            }
        }
        
        
        do {
            let request = try Instagram.Router.requestOauthCode.asURLRequest()
            
            print("AlamoTESTREQUEST")
            print(request)
            
            print("do load request")
            
            self.webView.loadRequest(request)
        } catch {
           print("someerror")
        }
            //let request = NSURLRequest(url: Instagram.Router.requestOauthCode.asURLRequest(), cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10.0)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "unwindToPhotoBrowser" && segue.destination is PhotoBrowserCollectionViewController) {
            let photoBrowserCollectionViewController = segue.destination as! PhotoBrowserCollectionViewController
//            if let user = sender?["user"] as? User {
//                photoBrowserCollectionViewController.user = user
//                
//            }
        }
    }
    
}

extension OauthLoginViewController {
    
    

    @objc(webView:shouldStartLoadWithRequest:navigationType:) func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        // debugPrint(request.URLString)
        
        print("ALAMOSHOULDWORK")
        print(Instagram.Router.redirectURI)
        print("ALAMOSHOULDWORKEND")
        
        
        
        print("ALAMOSHOULDWORKREQUESTURL")
        print(request.url!)
        print("ALAMOSHOULDWORKREQUESTURLEND")
        
        let redirectURIComponents = NSURLComponents(string: Instagram.Router.redirectURI)!
        let components = NSURLComponents(string: "\(request.url!)")
        
        print(redirectURIComponents)
        print(components)
        
        
        if components?.host == redirectURIComponents.host {
            
            print("ALAMOSHOULDWORK2")
            
            if let code = (components?.queryItems?.filter { $0.name == "code" })?.first?.value {
                print("ALAMOSHOULDWORK3")
                debugPrint(code)
                
                self.spinningActivity = MBProgressHUD.showAdded(to: self.view, animated: true)
                self.spinningActivity.isUserInteractionEnabled = false

                
                requestAccessToken(code: code)
                print("ALAMOSHOULDWORK3END")
                return false
            }
        }
        return true

        
        
    }

    
    func requestAccessToken(code: String) {
        let request = Instagram.Router.requestAccessTokenURLStringAndParms(code: code)
        
        
        print("Request.URLString")
        print(request.URLString)
        print("Request.URLStringEND")
        
        print("request.params")
        print(request.params)
        print("request.params")
        
        Alamofire.request(request.URLString, method: .post , parameters: request.params, encoding: URLEncoding.default).responseJSON {
               results in
            
                print("results")
                print(results)
                print("resultsEND")
            
                switch results.result {
                    case .success (let jsonObject):
                    //debugPrint(jsonObject)
                    let json = JSON(jsonObject)
            
                    if let accessToken = json["access_token"].string, let userID = json["user"]["id"].string {
                        


                      //  let user = NSEntityDescription.insertNewObject(forEntityName: "User", into: self.coreDataStack.context)
                        
                        
                   //     user.userID = userID
                   //     user.accessToken = accessToken
                   //     self.coreDataStack.saveContext()
                        
                        let userInsta = PFUser.query()
//                        print("TestHello123")
//                        
//                        print("jsonprofile_picturestring")
//                        print(json)
//                        print(json["user"]["profile_picture"].string!)
                        userInsta?.whereKey("userInstagramAccessToken", equalTo: accessToken )
                        userInsta?.findObjectsInBackground(block: { (curUser, error) in
                            
                            var parseUserName = String()
                            var usernameToLogin = String()
                            var passwordToLogin = String()
                            
                            if error == nil {
                                if curUser! == [] {
                                    //Instagram user does not exist. Create new user.
                                    
                                    //new username
                                    parseUserName = json["user"]["username"].string! + String(Int(arc4random_uniform(UInt32(1000))) + 1000)
                        
                                    let newUser = PFUser()
                                    newUser["userInstagramAccessToken"] = accessToken
                                    newUser["username"] = parseUserName
                                    newUser["userImagePath"] = json["user"]["profile_picture"].string!
                                    newUser["userFullName"] = json["user"]["full_name"].string!
                                    newUser["userInstagramUserName"] = json["user"]["username"].string!
                                    newUser["password"] = "InstagramUser"
                                    newUser.signUpInBackground(block: { (success, error) in
                                        if (success) {
                                            print("SAVEDSUCCESSFULLY")
                                            // The object has been saved.
                                        } else {
                                            // There was a problem, check error.description
                                        }
                                    })
                                }}
                                //login to get PFUser.Current
                            
                            if curUser! == [] {
                                usernameToLogin = parseUserName
                                passwordToLogin = "InstagramUser"
                            }
                            else {
                                usernameToLogin = curUser![0]["username"] as! String
                                passwordToLogin = "InstagramUser"
                            }
                            
                            PFUser.logInWithUsername(inBackground: usernameToLogin, password: passwordToLogin, block: { (user, error) -> Void in
                                
                                //spinningActivity?.isUserInteractionEnabled = false
                                
                                self.spinningActivity.isUserInteractionEnabled = true
                                self.spinningActivity.isHidden = true
                                
                                
                                if user != nil {
                                    
                                    print("Logged In")
                                    let vC = self.storyboard?.instantiateViewController(withIdentifier: "homeView")
                                    
                                    self.show(vC!, sender: self)
                                
                                } else {
                                    
//                                    let vC = self.storyboard?.instantiateViewController(withIdentifier: "userAuthViewController") as! userAuthViewController
//                                    
//                                    self.show(vC, sender: self)

                                    
                                    
                                    if let errorString = error?.localizedDescription {
                  
                                        
                                        
                                        self.spinningActivity.isUserInteractionEnabled = true
                                        self.spinningActivity.isHidden = true
                                        
                                        self.displayAlert("Login Error", message: errorString)
                                        
                                    } // Unwrap error
                                    
                                    
                                    
                                }
                                

                            
                            
                            })
                        })
                    }
               case .failure:
                    break;
                }
        }
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        
        
        
        
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
       
        print("WEB VIEW DID FINISH LOADING")
        
        self.spinningActivity.isUserInteractionEnabled = true
        self.spinningActivity.isHidden = true
        UIApplication.shared.endIgnoringInteractionEvents()
        
        
        
        webView.isHidden = false
        
    }
    
    
    // Display alerts
    
    
    func displayAlert(_ title: String,message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            
            // self.dismissViewControllerAnimated(true, completion: nil)
            
            alert.dismiss(animated: true, completion: nil)
            
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    

}
