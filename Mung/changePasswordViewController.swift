//
//  changePasswordViewController.swift
//  Mung
//
//  Created by Chike Chiejine on 23/02/2017.
//  Copyright © 2017 Color & Space. All rights reserved.
//

import UIKit
import Parse

class changePasswordViewController: UITableViewController, UITextFieldDelegate {
    
    var userObject = UserClass(userPFObject: nil, userPFUser: nil)
    
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var emailIcon: UIImageView!
    
    var activeField: UITextField?
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    
    @IBAction func saveAction(_ sender: Any) {
        
        
        
        self.view.endEditing(true)
        
        var currentUser = PFUser.current()
        
        // Save changed password here
        
        PFUser.requestPasswordResetForEmail(inBackground: emailText.text!)
        
        
    }
    
    
    
    
    
 
    override func viewDidLoad() {
        super.viewDidLoad()

        self.emailText.delegate = self
        self.emailText.addTarget(self, action: #selector(self.didChangeText), for: .editingChanged)
        
        self.tableView.tableFooterView = UIView()
        
        // Set up keyboard notifications
        
        NotificationCenter.default.addObserver(self, selector: #selector(changePasswordViewController.keyboardDidShow(_:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(changePasswordViewController.keyboardWillBeHidden(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.separatorInset = UIEdgeInsets.zero
        
        
    }
    
    
    func didChangeText(textField:UITextField) {
        
        
  
       
            // Password field
        
        if textField.text != "" && (textField.text?.characters.count)! > 6 {
            
            
            print("NOW TYPING")
            
            self.saveButton.isEnabled = true
            
            
            
        }
        
        if textField.text == "" {
            
            print("NOW EMPTY")
            
            
            
        }
        
        
        
    }

    
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        print("BEGIN EDITING")
        
        self.activeField = textField
        

        

    }
    
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt
        indexPath: IndexPath) {
        
        
    if (indexPath as NSIndexPath).row == 0 {
            
            
            emailText.becomeFirstResponder()
            emailIcon.tintColor = UIColor.soraBlue()
      
     
            
        }
        
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






}
