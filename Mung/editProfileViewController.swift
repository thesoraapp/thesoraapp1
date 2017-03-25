//
//  editProfileViewController.swift
//  Mung
//
//  Created by Chike Chiejine on 13/02/2017.
//  Copyright © 2017 Color & Space. All rights reserved.
//

import UIKit
import Parse
import MBProgressHUD
import Alamofire
import AlamofireImage

class editProfileViewController: UITableViewController, UIViewControllerTransitioningDelegate, UITextFieldDelegate, backFromViewDelegate {
    
    var userObject = UserClass(userPFObject: nil, userPFUser: nil)
    
    @IBOutlet weak var profileImage: UIButton!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    @IBOutlet weak var emailIcon: UIImageView!
    @IBOutlet weak var userIcon: UIImageView!
    @IBOutlet weak var passwordIcon: UIImageView!
    
    var activeField: UITextField?
    
    
    func backFromAction(goalObject: goalsClass?) {
    }
    
    func profileBackFromAction(user: UserClass?) {
        self.userObject = user!
        setUp(user: user)
    }
    
    @IBAction func donebutton(_ sender: AnyObject) {
        
        self.view.endEditing(true)
        var currentUser = PFUser.current()
        
        userObject.fetchUserifPFUserChange(completion: {(newUserPFObj,error) in
            self.userObject.updateUserClassDB(userPFObject: newUserPFObj, objectID: (currentUser?.objectId)!, email: self.userObject.userEmail, username: self.userObject.username, userImagePath: self.userObject.userImagePath, completion: { error in
                if error == nil {
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "refreshToggled"), object: nil, userInfo: ["status": self.userObject])
                    
                    self.navigationController?.popToRootViewController(animated: true)
                }
            })
        })
    }
    
    @IBAction func backButton(_ sender: AnyObject) {
        
      self.navigationController?.popViewController(animated: true)
        
        
    }
    
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        setUp(user: userObject)
        self.navigationController?.navigationBar.isHidden = false
        
    }
    
    
    func setUp(user: UserClass?) {
        
        //Set up user profile image
        self.userObject = user!
        let urlImageURL = URL(string: self.userObject.userImagePath!)
        self.profileImage.af_setImage(for: UIControlState.normal, url: urlImageURL!, placeholderImage: UIImage(named: "user-placeholder"), filter: nil, completion: nil)
        // Username field
        self.usernameText.text = userObject.username
        // Email field
        self.emailText.text = userObject.userEmail
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        self.usernameText.becomeFirstResponder()
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImage.isEnabled = false
        helpers().roundCorners(element: self.profileImage)
        
        emailIcon.tintColor = UIColor.lightGray
        userIcon.tintColor = UIColor.lightGray
        passwordIcon.tintColor = UIColor.lightGray
    
        let tblView =  UIView(frame: CGRect.zero)
        tableView.tableFooterView = tblView
        
        // Set up textfields delegate
        self.emailText.delegate = self
        self.usernameText.delegate = self
     
        self.emailText.addTarget(self, action: #selector(self.didChangeText), for: .editingChanged)
        self.usernameText.addTarget(self, action: #selector(self.didChangeText), for: .editingChanged)
 
        self.usernameText.tag = 0
        self.emailText.tag = 1
   
        // Set up keyboard notifications
        
        NotificationCenter.default.addObserver(self, selector: #selector(editProfileViewController.keyboardDidShow(_:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(editProfileViewController.keyboardWillBeHidden(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        
        
    }
    
    
    func didChangeText(textField:UITextField) {
        
        if textField.tag == 0 {
            
            // Username field
            
           userObject.username = textField.text

            
        } else if textField.tag == 1 {
            
            // Email field
            
            userObject.userEmail = textField.text
            
        }
        
        if textField.text != "" && (textField.text?.characters.count)! > 5 {
            
            
            print("NOW TYPING")

        }
        
        if textField.text == "" {
            
            print("NOW EMPTY")
            

            
        }
        
        
        
    }
    
    
    
    func uploadAction() {
        
        showActionSheet()
        
        
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
            
            self.uploadAction()
            
            
        } else if (indexPath as NSIndexPath).row == 1 {
            
            usernameText.becomeFirstResponder()
            userIcon.tintColor = UIColor.soraBlue()
            emailIcon.tintColor = UIColor.soraGrey()
            passwordIcon.tintColor = UIColor.soraGrey()

            
        } else if (indexPath as NSIndexPath).row == 2 {
            
            
            emailText.becomeFirstResponder()
            emailIcon.tintColor = UIColor.soraBlue()
            userIcon.tintColor = UIColor.soraGrey()
            passwordIcon.tintColor = UIColor.soraGrey()

            
        } else if (indexPath as NSIndexPath).row == 3 {
            
            passwordIcon.tintColor = UIColor.soraBlue()
            emailIcon.tintColor = UIColor.soraGrey()
            userIcon.tintColor = UIColor.soraGrey()
            
            
        }
        
        
    }
    
    
    
    
    // Check textfield status and change accordingly
    
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        self.activeField = nil
        
        
        
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        print("BEGIN EDITING")
        
        self.activeField = textField
        
        if textField.tag == 0 {
            
            userIcon.tintColor = UIColor.soraBlue()
            emailIcon.tintColor = UIColor.soraGrey()
            passwordIcon.tintColor = UIColor.soraGrey()
            
        } else if textField.tag == 1 {
            
            emailIcon.tintColor = UIColor.soraBlue()
            userIcon.tintColor = UIColor.soraGrey()
            passwordIcon.tintColor = UIColor.soraGrey()
            
            
        }
        
    }


    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    func onActionComplete(goal: goalsClass) {
        // do something
    }
    
    // show action sheet
    fileprivate func showActionSheet() {
        
        // create controller with style as ActionSheet
        let alertCtrl = UIAlertController(title: "Upload a Goal Image", message: "Visualize this thing that you want, see it, feel it, believe in it.", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        // create button action
        let InstagramAction = UIAlertAction(title: "Instagram Upload", style: UIAlertActionStyle.default, handler: { (action) in
            
            var instaUpload = true
            
            self.view.endEditing(true)
            
            
            //            self.performSegue(withIdentifier: "instaUpload", sender: self)
            
            if let instaUploadController = self.storyboard?.instantiateViewController(withIdentifier:
                "gallery") as? PhotoBrowserCollectionViewController {
                
                
                // instaUploadController.delegate = self
                instaUploadController.delegate = self
                instaUploadController.userObject = self.userObject
                
                let navController = UINavigationController(rootViewController: instaUploadController)
                
                navController.modalPresentationStyle = UIModalPresentationStyle.custom
                navController.transitioningDelegate = self
                self.present(navController, animated: true, completion: nil)
                
                //                self.navigationController?.show(instaUploadController , sender: self)
                
            }
            
        })
        
        
        
        let libraryAction = UIAlertAction(title: "Choose from library", style: UIAlertActionStyle.default, handler: {(action) in
            
            var instaUpload = false
            self.imagePicker(isCamera: false)
            
            
        })
        
        
        
        let photoAction = UIAlertAction(title: "Take a photo", style: UIAlertActionStyle.default, handler: {(action) in
            
            
            print("camera Selected...")
            var instaUpload = false
            
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) == true {
                
                self.imagePicker(isCamera: true)
                
            } else{
                
                self.present(self.showAlert(Title: "Title", Message: "Camera is not available on this Device or accesibility has been revoked!"), animated: true, completion: nil)
                
            }
            
            
        })
        // let deleteAction = UIAlertAction(title: "Delete", style: UIAlertActionStyle.destructive, handler: nil)
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
        
        // add action to controller
        alertCtrl.addAction(InstagramAction)
        alertCtrl.addAction(libraryAction)
        alertCtrl.addAction(photoAction)
        // alertCtrl.addAction(deleteAction)
        alertCtrl.addAction(cancelAction)
        
        // show action sheet
        self.present(alertCtrl, animated: true, completion: nil)
    }
    
    
    
    
    
    
    
    
    
    
    
}




extension editProfileViewController:  UIImagePickerControllerDelegate,  UINavigationControllerDelegate {
    
    
    func imagePicker(isCamera: Bool){
        
        self.view.endEditing(true)
        
        let image = UIImagePickerController()
        image.delegate = self
        
        if isCamera == false {
            
            image.sourceType = .photoLibrary
            
        } else {
            
            image.sourceType = .camera
        }
        
        image.allowsEditing = false
        
        self.present(image, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        // We need to turn upload an image and return a URL
        
        //        self.userObject.userImagePath = image
        
        
        
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            if let imageData = UIImageJPEGRepresentation(image, 0.5) {
                multipartFormData.append(imageData, withName: "image", fileName: "testing.jpg", mimeType: "image/jpeg")
                // data: Data, withName name: String, fileName: String, mimeType: String
            }
        }, to: URL(string: "http://localhost:8080/add")!, /*method: .post, headers: [:], */encodingCompletion: { result in
            switch result {
            case .success:
                print("uploaded")
                
                
            case .failure(let error):
                print("upload error: \(error)")
            }
        })
        
        self.navigationController?.dismiss(animated: true, completion: nil)
        
        
    }
    
    
    //Show Alert
    
    
    func showAlert(Title : String!, Message : String!)  -> UIAlertController {
        
        let alertController : UIAlertController = UIAlertController(title: Title, message: Message, preferredStyle: .alert)
        let okAction : UIAlertAction = UIAlertAction(title: "Ok", style: .default) { (alert) in
            print("User pressed ok function")
            
        }
        
        alertController.addAction(okAction)
        alertController.popoverPresentationController?.sourceView = view
        alertController.popoverPresentationController?.sourceRect = view.frame
        
        return alertController
    }
    
    
    
    
    
    
    
}
