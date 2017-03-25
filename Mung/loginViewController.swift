//
//  loginViewController.swift
//  Mung
//
//  Created by Chike Chiejine on 15/10/2016.
//  Copyright © 2016 Color & Space. All rights reserved.
//

import UIKit
import Parse
import MBProgressHUD

class loginViewController: UITableViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var userName: UITableViewCell!
    @IBOutlet weak var password: UITableViewCell!
    @IBOutlet weak var facebook: UITableViewCell!
    
    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    @IBOutlet weak var userIcon: UIImageView!
    @IBOutlet weak var passwordIcon: UIImageView!
    
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var instagramButton: UIButton!
    @IBOutlet weak var signUp: UIButton!
    
    // Segue variables
    
    var userSegueVal = String()
    var passwordSegueVal =  String()
    
    
    
    
    @IBAction func donebutton(_ sender: AnyObject) {
        
        if usernameText.text == "" && passwordText.text == "" {
            
            displayAlert("Login Error", message: "Please fill out your login details and try again.")
            
        } else {
            
            activateLogin()
            
            self.doneButton.isEnabled = true
            
            
        }
        
    }
    
    
    @IBAction func signUpButton(_ sender: AnyObject) {
        
        // CHANGE- Replace instantiate with segue
        
        let vC = self.storyboard?.instantiateViewController(withIdentifier: "signUpView") as! signUpViewController
        
        print(self.usernameText.text)
        print(self.passwordText.text)
        
        vC.userSegueVal = self.usernameText.text!
        vC.passwordSegueVal = self.passwordText.text!
        
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "RefreshDiscover"), object: nil, userInfo: ["status": true])
        
        self.navigationController?.pushViewController(vC, animated: true)
        
        
    }
    
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.isHidden = false
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        helpers().cornerRadius(element: instagramButton)
        
        signUp.setTitle("Don't have an account?", for: UIControlState.normal)
        
        
        
        doneButton.isEnabled = false
        
        let tblView =  UIView(frame: CGRect.zero)
        tableView.tableFooterView = tblView
        
        self.userName.separatorInset = UIEdgeInsets.zero
        self.userName.layoutMargins = UIEdgeInsets.zero
        self.password.separatorInset = UIEdgeInsets.zero
        self.password.layoutMargins = UIEdgeInsets.zero
        
        // Text delegate
        
        // Set up textfields delegate
        
        self.usernameText.delegate = self
        self.passwordText.delegate = self
        
        self.usernameText.tag = 0
        self.passwordText.tag = 1
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        self.usernameText.becomeFirstResponder()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        
        self.view.endEditing(true)
        
        
    }
    
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if (indexPath as NSIndexPath).row == 3 {
            
            
            tableView.separatorStyle = .none
            
        }
        
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
        if (indexPath as NSIndexPath).row == 0 {
            
            userName.becomeFirstResponder()
            userIcon.tintColor = UIColor(red:0.01, green:0.68, blue:0.88, alpha:1.0)
            passwordIcon.tintColor = UIColor(red:0.71, green:0.71, blue:0.71, alpha:1.0)
            
        } else if (indexPath as NSIndexPath).row == 1 {
            
            password.becomeFirstResponder()
            passwordIcon.tintColor = UIColor(red:0.01, green:0.68, blue:0.88, alpha:1.0)
            userIcon.tintColor = UIColor(red:0.71, green:0.71, blue:0.71, alpha:1.0)
        }
        
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        activateLogin()
        
        return true
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        print("BEGIN EDITING")
        
        if textField.tag == 0 {
            
            userIcon.tintColor = UIColor(red:0.01, green:0.68, blue:0.88, alpha:1.0)
            passwordIcon.tintColor = UIColor(red:0.71, green:0.71, blue:0.71, alpha:1.0)
            
        } else {
            
            passwordIcon.tintColor = UIColor(red:0.01, green:0.68, blue:0.88, alpha:1.0)
            userIcon.tintColor = UIColor(red:0.71, green:0.71, blue:0.71, alpha:1.0)
            
        }
        
        if usernameText.text != "" || passwordText.text  != "" {
            
            self.doneButton.isEnabled = true
            
        }
        
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if usernameText.text != "" || passwordText.text  != "" {
            
            self.doneButton.isEnabled = true
            
        }
        
        return true
        
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
    
    // Email test
    
    func isValidEmail(_ email:String) -> Bool {
        
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        let result = emailTest.evaluate(with: email)
        
        return result
        
    }
    
    
    func activateLogin(){
        
        // Validate User input
        
        var errorMessage = "Please try again later"
        
        
        let spinningActivity = MBProgressHUD.showAdded(to: self.view, animated: true)
        
        spinningActivity?.labelText = "Logging In"
        spinningActivity?.isUserInteractionEnabled = false
        
        
        if self.usernameText.text == "" || self.passwordText.text == "" {
            
            displayAlert("Log In Error", message: "Your E-mail, Username or Password is empty. Please check and try again.")
            
            spinningActivity?.isUserInteractionEnabled = true
            spinningActivity?.isHidden = true
            
            
        } /* else if !isValidEmail(email.text!) {
             
             
             displayAlert("E-mail Error", message: "There is something wrong with you e-mail address. please check and try again.")
             
         } */ else  {
            
            // AFTER validation stuff
            
            
            let userName = usernameText.text!
            let password = passwordText.text!
            
            
            
            
            PFUser.logInWithUsername(inBackground: userName, password: password, block: { (user, error) -> Void in
                
                
                spinningActivity?.isUserInteractionEnabled = false
                
                
                if user != nil {
                    
                    print("Logged In")
                    
                    spinningActivity?.isUserInteractionEnabled = true
                    spinningActivity?.isHidden = true
                    
                    
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "authDismiss"), object: nil, userInfo: ["status": true])
                    
                    
                    // Stop activity indicator whilst user is being signed up
                    //                    let vC = self.storyboard?.instantiateViewController(withIdentifier: "home")
                    //                    self.view.resignFirstResponder()
                    //                    self.view.endEditing(true)
                    //
                    //                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    //                    appDelegate.window?.rootViewController = vC
                    
                    
                    self.navigationController?.presentingViewController?.dismiss(animated: true, completion: nil)
                    
                    let newUser = UserClass(userPFObject: nil, userPFUser: PFUser.current())
                    
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "refreshToggled"), object: nil, userInfo: ["status": newUser])
                    
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "RefreshDiscover"), object: nil, userInfo: ["status": true])
                    
                    
                } else {
                    
                    
                    if let errorString = error?.localizedDescription {
                        
                        errorMessage = errorString
                        
                        
                        spinningActivity?.isUserInteractionEnabled = true
                        spinningActivity?.isHidden = true
                        
                        self.displayAlert("Login Error", message: errorMessage)
                        
                    } // Unwrap error
                    
                }
                
            })
            
        }
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    
    
    
    
    
    
}
