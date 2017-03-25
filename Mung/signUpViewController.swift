//
//  signUpViewController.swift
//  Mung
//
//  Created by Chike Chiejine on 15/10/2016.
//  Copyright © 2016 Color & Space. All rights reserved.
//

import UIKit
import Parse
import MBProgressHUD

class signUpViewController: UITableViewController, UITextFieldDelegate {
    
    var signupActive = true
    
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    @IBOutlet weak var emailIcon: UIImageView!
    @IBOutlet weak var userIcon: UIImageView!
    @IBOutlet weak var passwordIcon: UIImageView!
    
    @IBOutlet weak var login: UIButton!
    @IBOutlet weak var instagramButton: UIButton!
    
    // Segue variables
    
    var userSegueVal = String()
    var passwordSegueVal =  String()
    
    var activeField: UITextField?
    
    
    
    @IBAction func donebutton(_ sender: AnyObject) {
        
        activateSignUp()
        
    }
    
    @IBAction func loginButton(_ sender: AnyObject) {
        
        let vC = self.storyboard?.instantiateViewController(withIdentifier: "loginView") as! loginViewController
        vC.userSegueVal = self.usernameText.text!
        vC.passwordSegueVal = self.passwordText.text!
        self.navigationController?.pushViewController(vC, animated: true)
        
    }
    
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.isHidden = false
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        self.emailText.becomeFirstResponder()
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.usernameText.text = userSegueVal
        self.passwordText.text = passwordSegueVal
        
        login.setTitle("I already have an account.", for: UIControlState.normal)
        
        helpers().cornerRadius(element: instagramButton)
        
        doneButton.isEnabled = false
        
        let tblView =  UIView(frame: CGRect.zero)
        tableView.tableFooterView = tblView
        
        // Set up textfields delegate
        
        self.emailText.delegate = self
        self.usernameText.delegate = self
        self.passwordText.delegate = self
        
        self.emailText.tag = 0
        self.usernameText.tag = 1
        self.passwordText.tag = 2
        
        
        // Set up keyboard notifications
        
        NotificationCenter.default.addObserver(self, selector: #selector(signUpViewController.keyboardDidShow(_:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(signUpViewController.keyboardWillBeHidden(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        
        self.view.endEditing(true)
        
        
    }
    
    func keyboardDidShow(_ notification: Notification) {
        
        
        if let activeField = self.activeField, let keyboardSize = ((notification as NSNotification).userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            
            let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height, right: 0.0)
            self.tableView.contentInset = contentInsets
            self.tableView.scrollIndicatorInsets = contentInsets
            var aRect = self.view.frame
            aRect.size.height -= keyboardSize.size.height
            
            if (!aRect.contains(activeField.frame.origin)) {
                self.tableView.scrollRectToVisible(activeField.frame, animated: true)
            }
            
        }
        
        
    }
    
    func keyboardWillBeHidden(_ notification: Notification) {
        
        
        let contentInsets = UIEdgeInsets.zero
        self.tableView.contentInset = contentInsets
        self.tableView.scrollIndicatorInsets = contentInsets
    }
    
    
    func registerForKeyboardNotifications()
    {
        //Adding notifies on keyboard appearing
        NotificationCenter.default.addObserver(self, selector: #selector(signUpViewController.keyboardDidShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(signUpViewController.keyboardWillBeHidden(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    
    func deregisterFromKeyboardNotifications()
    {
        //Removing notifies on keyboard appearing
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.separatorInset = UIEdgeInsets.zero
        
        if (indexPath as NSIndexPath).row == 4 {
            
            
            tableView.separatorStyle = .none
            
        }
        
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (indexPath as NSIndexPath).row == 0 {
            
            emailText.becomeFirstResponder()
            emailIcon.tintColor = UIColor(red:0.01, green:0.68, blue:0.88, alpha:1.0)
            userIcon.tintColor = UIColor(red:0.71, green:0.71, blue:0.71, alpha:1.0)
            passwordIcon.tintColor = UIColor(red:0.71, green:0.71, blue:0.71, alpha:1.0)
            
        } else if (indexPath as NSIndexPath).row == 1 {
            
            usernameText.becomeFirstResponder()
            userIcon.tintColor = UIColor(red:0.01, green:0.68, blue:0.88, alpha:1.0)
            emailIcon.tintColor = UIColor(red:0.71, green:0.71, blue:0.71, alpha:1.0)
            passwordIcon.tintColor = UIColor(red:0.71, green:0.71, blue:0.71, alpha:1.0)
            
        } else if (indexPath as NSIndexPath).row == 2 {
            
            
            passwordText.becomeFirstResponder()
            passwordIcon.tintColor = UIColor(red:0.01, green:0.68, blue:0.88, alpha:1.0)
            emailIcon.tintColor = UIColor(red:0.71, green:0.71, blue:0.71, alpha:1.0)
            userIcon.tintColor = UIColor(red:0.71, green:0.71, blue:0.71, alpha:1.0)
            
        }
        
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        activateSignUp()
        
        return true
        
    }
    
    
    // Check textfield status and change accordingly
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        self.activeField = nil
        
        
        
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        print("BEGIN EDITING")
        
        self.activeField = textField
        
        if textField.tag == 0 {
            
            emailIcon.tintColor = UIColor(red:0.01, green:0.68, blue:0.88, alpha:1.0)
            userIcon.tintColor = UIColor(red:0.71, green:0.71, blue:0.71, alpha:1.0)
            passwordIcon.tintColor = UIColor(red:0.71, green:0.71, blue:0.71, alpha:1.0)
            
        } else if textField.tag == 1 {
            
            userIcon.tintColor = UIColor(red:0.01, green:0.68, blue:0.88, alpha:1.0)
            emailIcon.tintColor = UIColor(red:0.71, green:0.71, blue:0.71, alpha:1.0)
            passwordIcon.tintColor = UIColor(red:0.71, green:0.71, blue:0.71, alpha:1.0)
            
        } else if textField.tag == 2 {
            
            passwordIcon.tintColor = UIColor(red:0.01, green:0.68, blue:0.88, alpha:1.0)
            emailIcon.tintColor = UIColor(red:0.71, green:0.71, blue:0.71, alpha:1.0)
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    func activateSignUp(){
        
        // Validate User input
        
        if self.emailText.text == "" || self.passwordText.text == "" || self.usernameText.text == "" {
            
            displayAlert("Sign Up Error", message: "Your E-mail, Username or Password is empty. Please check and try again.")
            
        } else if !isValidEmail(emailText.text!) {
            
            displayAlert("E-mail Error", message: "There is something wrong with you e-mail address. please check and try again.")
            
        } else {
            
            // AFTER validation stuff
            
            var errorMessage = "Please try again later"
            
            // Check if sign up is happening
            
            if signupActive == true {
                
                // Hook Up an activity indicator
                let spinningActivity = MBProgressHUD.showAdded(to: self.view, animated: true)
                spinningActivity?.isUserInteractionEnabled = false
                UIApplication.shared.beginIgnoringInteractionEvents()
                
                // Set Up user
                
                let user = PFUser()
                
                user.username = usernameText.text
                user.email = emailText.text
                user.password = passwordText.text
                
                
                // Sign Up user
                
                user.signUpInBackground(block: { (success, error) -> Void in
                    
                    //Sign Up successful
                    
                    if error == nil {
                        
                        let currentUserStatus = PFUser.current()?.objectId
                        
                        if currentUserStatus != nil {
                            
                            // Stop activity indicator whilst user is being signed up
                            let vC = self.storyboard?.instantiateViewController(withIdentifier: "home")
                            self.resignFirstResponder()
                            
                            spinningActivity?.isUserInteractionEnabled = true
                            spinningActivity?.isHidden = true
                            UIApplication.shared.endIgnoringInteractionEvents()
                            
                            // Stop activity indicator whilst user is being signed up
                            
                            let appDelegate = UIApplication.shared.delegate as! AppDelegate
                            appDelegate.window?.rootViewController = vC
                            
                            
                        }
                        
                    } else {
                        
                        if let errorString = error?.localizedDescription {
                            
                            errorMessage = errorString
                            
                            self.displayAlert("Sign Up Error", message: errorString)
                            
                        }
                        
                        // Stop activity indicator whilst user is being signed up
                        
                        spinningActivity?.isUserInteractionEnabled = true
                        spinningActivity?.isHidden = true
                        UIApplication.shared.endIgnoringInteractionEvents()
                        
                        
                    } // End Sign Up
                    
                    
                    
                })
                
                
            } // END If Sign Up active == true - While sign up is happening
            
            
            
        } // Validation End
        
        
        
        
        
        
        
        
        
        
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
