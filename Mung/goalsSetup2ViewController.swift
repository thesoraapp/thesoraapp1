//
//  goalsSetup2ViewController.swift
//  Mung
//
//  Created by Chike Chiejine on 02/11/2016.
//  Copyright © 2016 Color & Space. All rights reserved.
//

import UIKit
import Parse
import SCLAlertView
import Alamofire
import AlamofireImage


// UIColor(red:0.67, green:0.67, blue:0.67, alpha:1.0) // Light Grey
// UIColor(red:0.20, green:0.68, blue:0.89, alpha:1.0) //Light blue




class goalsSetup2ViewController: UITableViewController, UITextFieldDelegate, UIGestureRecognizerDelegate,UIViewControllerTransitioningDelegate, backFromViewDelegate  {
    
    // XYZ - Add delegate variable
    var delegate: backFromViewDelegate?
    

    
    @IBOutlet weak var connectBankButton: UIButton!
    @IBOutlet var popUpAlertView: UIView!
    var popUpAlertOverlay = UIView()

    @IBOutlet weak var padlockIcon: UIImageView!
    @IBOutlet weak var shieldIcon: UIImageView!
    
    
    @IBOutlet weak var exampleGoalCell: UITableViewCell!
    @IBOutlet weak var inputCellOne: UITableViewCell!
    @IBOutlet weak var inputCellTwo: UITableViewCell!
    @IBOutlet weak var inputCellThree: UITableViewCell!
    
    var inputCells: [UITableViewCell]?
    
    @IBOutlet weak var goalTitle: UILabel!
    @IBOutlet weak var goalImageExample: UIImageView!
    
    @IBOutlet weak var priceIcon: UIImageView!
    @IBOutlet weak var nameIcon: UIImageView!
    @IBOutlet weak var tagIcon: UIImageView!
    

    var goalObject = goalsClass(goal: nil)
    var editMode = false
    
    @IBOutlet weak var goalName: UITextField!
    @IBOutlet weak var goalCosts: UITextField!
    //    @IBOutlet weak var goalTags: UITextField!
    let toolBar = UIToolbar()
    var instaUpload = false
    var activeField: UITextField?
    var activeFieldCell: UITableViewCell?
    
//    var tags_array =  [String]()
//    let tagsField = WSTagsField()
    
    let overlayGradient = CAGradientLayer()
    let uploadButton = UIButton()
    var progress = UIView()
    
    var alreadyConnected : Bool?
    
 
    func backFromAction(goalObject: goalsClass?) {
        
        print("Back from editing")
        self.goalObject = goalObject!
        viewSetup(goalClass:goalObject)
    }
    
    func profileBackFromAction(user: UserClass?) {
        //Do nothing
    }
    
    
    
    
    @IBAction func closePopUpAction(_ sender: Any) {
    
        animatedOut(keep: true)

    }
    
    @IBAction func connectAccountNow(_ sender: Any) {
        
        
        helpers().progressBar(view: self, currentStep: 3, progressBar: self.progress, next: true)
        self.goalObject.goalAuthorObject = PFUser.current()
        animatedOut()
        self.performSegue(withIdentifier: "stepThree", sender: self)
    
    }
    
    
    
    @IBAction func nextButton(_ sender: Any) {
        
        if editMode != true {
            
            
            
           nextPreviousField()
            
        } else {
            
//            if let prevvC = storyboard?.instantiateViewController(withIdentifier: "goalViewDetail") as? detailGoalViewController {
//                
//
//            }

            if let objectId = self.goalObject.objectId! as? String {
                
                self.goalObject.updateGoalClassDB(objectID: objectId, goalImagePath: self.goalObject.goalImagePath, goalTitle: self.goalTitle.text, completion: { savedsuccess in
                    
                    self.delegate?.backFromAction(goalObject: self.goalObject)
                    
                    self.navigationController?.popToRootViewController(animated: true)
                    
                    })
                
            }
//            self.delegate?.backFromAction(goalObject: self.goalObject)
//            
//            self.navigationController?.popToRootViewController(animated: true)
            
        }
        
        
    }
    
    
    func goBack() {
        
        if editMode != true {

            let stepOne = self.storyboard?.instantiateViewController(withIdentifier: "step1") as! goalsSetupViewController
            stepOne.goalObject = self.goalObject
            self.navigationController?.popToViewController(stepOne, animated: true)
           
        } else {
            
            print("Cancel")
            self.navigationController?.popToRootViewController(animated: true)
//            self.navigationController?.dismiss(animated: true, completion: nil)
            
        }
        
    }
    
    
    // Initiate tap geture recognizer object
    let tapGesture : UILongPressGestureRecognizer = UILongPressGestureRecognizer()
    
    
    
    func uploadAction() {
        
        showActionSheet()
        
        
    }
    
    
    // XYZ - Add delegate function
    func backFromAction(goalObject: goalsClass?) -> goalsClass? {
        
        self.goalObject = goalObject!
        viewSetup(goalClass:goalObject)
        
        return goalObject
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        helperFuns().checkIfLinkedAccount( completion : {connected, error in
            if error == nil {
                self.alreadyConnected = connected!
            
            }
        })
        
        // xyz - Add editmode to goal setup for already made goals
        if editMode != true {
            
//                        var backButtonImage = UIImage(named: "arrow-icon")
//                        let newBackButton = UIBarButtonItem(image: backButtonImage, style: UIBarButtonItemStyle.plain, target: self, action: "goBack" )
//                        self.navigationItem.leftBarButtonItem = newBackButton
            
        }else {
            
//            self.navigationController?.navigationBar = UINavigationBar()
            self.navigationItem.title = "Edit Goal Detail"
            self.inputCellTwo.isHidden = true
            
            let newBackButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: "goBack")
            self.navigationItem.leftBarButtonItem = newBackButton
            self.navigationItem.leftBarButtonItem!.image = nil
            self.navigationItem.rightBarButtonItem?.isEnabled = true
            self.navigationItem.rightBarButtonItem?.title = "Save"
            
        }
        
//        amountStepper.addTarget(self, action: #selector(self.stepperValueChanged), for: .valueChanged)
//        amountStepper.labelFont = UIFont(name: "HelveticaNeue-Light", size: 18)!
        
        
        let xPos = (view.bounds.width / 2) - 45
        let yPos = (exampleGoalCell.frame.height / 2) - 45
        
        //Gradient Overlay
        
        overlayGradient.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        overlayGradient.locations = [0.0, 0.9]
        overlayGradient.frame = CGRect(x: 0, y: 2, width: view.frame.width, height: exampleGoalCell.frame.height)

        
        // upload button
        
        uploadButton.frame =  CGRect(x: xPos , y: yPos, width: 90, height: 90) //Center positioned
        uploadButton.addTarget(self, action:#selector(self.uploadAction), for: .touchUpInside)
        uploadButton.layer.cornerRadius = 45
        let buttonImage = UIImage(named: "upload-camera")
        uploadButton.setImage(buttonImage, for: .normal)
        uploadButton.backgroundColor = UIColor(red:0.00, green:0.00, blue:0.00, alpha:0.7)
        uploadButton.tintColor = .white
        uploadButton.isHidden = true
        exampleGoalCell.addSubview(uploadButton)
        
        //Set icon colour
        nameIcon.tintColor = UIColor(red:0.71, green:0.71, blue:0.71, alpha:1.0)
        //tagIcon.tintColor = UIColor(red:0.71, green:0.71, blue:0.71, alpha:1.0)
        priceIcon.tintColor = UIColor(red:0.71, green:0.71, blue:0.71, alpha:1.0)
        

        // Set up textfields delegate
        
        self.goalName.delegate = self
        self.goalCosts.delegate = self
        self.goalName.tag = 0
        self.goalCosts.tag = 1 
//        self.tagsField.tag = 1
        
        self.goalName.addTarget(self, action: #selector(self.didChangeText), for: .editingChanged)
        self.goalCosts.addTarget(self, action: #selector(self.didChangeText), for: .editingChanged)
        
        self.tableView.tableFooterView = UIView()
        
        
        // Setup pickerview toolbar
        
        inputCells = [inputCellOne, inputCellTwo]
        
        
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red:0.20, green:0.68, blue:0.89, alpha:1.0)
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action:#selector(self.nextPreviousField))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let nextButton = UIBarButtonItem(title: "Next", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.nextPreviousField))
        let prevButton = UIBarButtonItem(title: "Prev", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.nextPreviousField))
        prevButton.tag = 2
        nextButton.tag = 1
        doneButton.tag = 0
        
        toolBar.setItems([doneButton, spaceButton], animated: false)
        toolBar.isUserInteractionEnabled = true

        
        // Register keyboard notifications
        
        NotificationCenter.default.addObserver(self, selector: #selector(goalsSetup2ViewController.keyboardDidShow(_:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(goalsSetup2ViewController.keyboardWillBeHidden(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        // Setup Next Button
        
        // nextButton.setTitle("Next Step", for: UIControlState.normal)
        //nextButton.tintColor = UIColor(red:0.13, green:0.13, blue:0.13, alpha:1.0)
        //nextButton.isEnabled = false
        //nextButton.backgroundColor = UIColor(red:0.76, green:0.76, blue:0.76, alpha:1.0)
        //nextButton.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: 55)
        // nextButton.addTarget(self, action: #selector(self.nextButtonAction), for: UIControlEvents.touchUpInside)

        
        
        
        
        //
        //        // Add tag
        //
        //        let midCell = (inputOneHeight / 2) - 27
        //
        //        tagsField.inputAccessory = toolBar
        //        tagsField.backgroundColor = .clear
        //        tagsField.frame = CGRect(x: 79, y: midCell , width: inputOneWidth - 89, height: 35)
        //        tagsField.spaceBetweenTags = 10.0
        //        tagsField.placeholder = "Example: BASKETBALL NBA TEAMS"
        //        tagsField.font = UIFont(name: "Proxima Nova Soft", size: 14)
        //        tagsField.keyboardType = .twitter
        //        //   tagsField.text = UITextAutocapitalizationType.allCharacters
        //        tagsField.tintColor = UIColor(red:0.20, green:0.68, blue:0.89, alpha:1.0) //Light blue
        //        tagsField.textColor = .white
        //        tagsField.fieldTextColor = UIColor(red:0.20, green:0.68, blue:0.89, alpha:1.0) //Light blue
        //        tagsField.selectedColor = .white
        //        tagsField.selectedTextColor =  UIColor(red:0.06, green:0.44, blue:0.60, alpha:1.0) //Dark blue
        //
        //        self.inputCellThree.addSubview(tagsField)
        //
        //        // Events
        //
        //        tagsField.onDidChangeText = { _ in
        //
        //            self.goalObject.goalTags = self.tagsField.tags
        //
        //        }
        //
        //        tagsField.onDidBeginEditing = { _ in
        //
        //            self.activeFieldCell = self.inputCellThree
        //            self.underlineTwo.backgroundColor = UIColor(red:0.20, green:0.68, blue:0.89, alpha:1.0) //Light blue
        //
        //            self.tagIcon.tintColor = UIColor(red:0.20, green:0.68, blue:0.89, alpha:1.0) //Light blue
        //            //Set icon colour
        //            self.nameIcon.tintColor = UIColor(red:0.71, green:0.71, blue:0.71, alpha:1.0) // Gray
        //            self.priceIcon.tintColor = UIColor(red:0.71, green:0.71, blue:0.71, alpha:1.0) //Gray
        //        }
        //
        //
        //
        //        tagsField.onDidEndEditing = { _ in
        //
        //            self.activeFieldCell = nil
        //            self.underlineTwo.backgroundColor = UIColor(red:0.67, green:0.67, blue:0.67, alpha:1.0)
        //            self.tagIcon.tintColor = UIColor(red:0.71, green:0.71, blue:0.71, alpha:1.0) // Gray
        //        }
        //
        //
        //        tagsField.onDidAddTag = { _ in
        //
        //
        //
        //        }
        //
        //
        //        tagsField.onDidChangeHeightTo = { sender, height in
        //            print("HeightTo \(height)")
        //
        //             self.underlineTwo.frame = CGRect(x: 10, y: height + 60, width: inputOneWidth - 20 , height: 0.5)
        //
        //
        //            self.tableView.estimatedRowHeight = self.tableView.rowHeight + height + 60
        //            self.tableView.rowHeight = UITableViewAutomaticDimension
        //
        //
        //
        //        }
        //
        
        
        
    }
    
    
    var selectedIndex: Int = 0
    
    
    func nextPreviousField(){
    
            let icon = UIImageView()
            icon.image = UIImage(named:"sora-logo")
            icon.tintColor = .white
            self.view.endEditing(true)
        
 
            
            if self.alreadyConnected == true {
        
                self.performSegue(withIdentifier: "step2ChooseAccount", sender: self)
                
            } else {
            
                self.animatedIn()
                
            }
    }
    
    func proceedButton() {
        print("First button tapped")
 
        self.performSegue(withIdentifier: "stepThree", sender: self)
        
    }
    
    
    func setUpCell() {
        
        if activeFieldCell?.tag == 1 {
            
            print("DID SELECT 1")
            self.goalName.becomeFirstResponder()
       
            
        } else if activeFieldCell?.tag == 2  {
            
            print("DID SELECT 2")
            self.goalCosts.becomeFirstResponder()
            self.activeFieldCell = self.inputCellTwo
            priceIcon.tintColor  = UIColor(red:0.20, green:0.68, blue:0.89, alpha:1.0) //Light blue
            // tagIcon.tintColor = UIColor(red:0.71, green:0.71, blue:0.71, alpha:1.0)
            nameIcon.tintColor = UIColor(red:0.71, green:0.71, blue:0.71, alpha:1.0)
            
        } else if activeFieldCell?.tag == 3 {
            
            print("DID SELECT 3")
//            self.tagsField.beginEditing()
        }
    }
    
    
    
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        self.goalName.becomeFirstResponder()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        // Pepare popup
        
        self.padlockIcon.tintColor = .soraGreen()
        self.shieldIcon.tintColor = .soraGreen()
        helpers().cornerRadius(element: self.connectBankButton)
        self.popUpAlertOverlay.frame = UIApplication.shared.windows[0].frame
        self.popUpAlertOverlay.backgroundColor = UIColor(red:0.00, green:0.00, blue:0.00, alpha:0.8)
        UIApplication.shared.windows[0].addSubview(self.popUpAlertOverlay)
        self.popUpAlertOverlay.isHidden = true

        //Set icon colour
        nameIcon.tintColor = UIColor(red:0.71, green:0.71, blue:0.71, alpha:1.0)
        // tagIcon.tintColor = UIColor(red:0.71, green:0.71, blue:0.71, alpha:1.0)
        priceIcon.tintColor = UIColor(red:0.71, green:0.71, blue:0.71, alpha:1.0)
        
        
        viewSetup(goalClass: self.goalObject)
        
        
    }
    
    @IBAction func unwindToRootViewController(segue: UIStoryboardSegue) {
        print("Unwind to Root View Controller")
    }
    
    
    
    func animatedIn(){
    
        self.popUpAlertView.layer.cornerRadius = 10
        self.popUpAlertView.center = self.view.center
//        self.popUpAlertView.center.y = self.view.center.y 
        self.popUpAlertView.isHidden = true
        self.popUpAlertOverlay.addSubview(self.popUpAlertView)
    
        
        UIView.animate(withDuration: 0.4, animations: {
            self.popUpAlertView.isHidden = false
            self.popUpAlertOverlay.isHidden = false
        }, completion: nil)

    }
    
    

    
    func animatedOut(keep: Bool = false){
        

        
        UIView.animate(withDuration: 0.4, animations: {
            self.popUpAlertView.isHidden = true
            self.popUpAlertOverlay.isHidden = true
        }) {(Bool) in
            
            
            if keep != true {
            
                self.popUpAlertView.removeFromSuperview()
                self.popUpAlertOverlay.removeFromSuperview()
                
            }
        
            
        }
        
    }
    
    
    
    
    func viewSetup(goalClass: goalsClass?) {
        
        // Show goal title
        
        if goalClass?.goalTitle != "" {
            
            self.goalTitle.text =  goalClass?.goalTitle
            
        }
        
        
        
        
        UIView.animate(withDuration: 0.5, animations: {
            self.uploadButton.isHidden = false
            
        })
        
        // Show uploaded goal image
        
        
        if goalClass?.goalImagePath != "" {
            
            self.uploadButton.backgroundColor = UIColor(red:0.00, green:0.00, blue:0.00, alpha:0.4)
            
            
            if let imageURL = goalClass?.goalImagePath {
                
                
                print("IMAGE AVAILABLE")
                let xPos = view.bounds.width - 80
                let yPos = exampleGoalCell.frame.height - 80
                
                if uploadButton.frame.height != 70 {
                    
                    UIView.animate(withDuration: 0.3, animations: {
                        self.uploadButton.isHidden = false
                        self.uploadButton.frame =  CGRect(x: xPos , y: yPos, width: 70, height: 70) //Bottom right positioned
                        self.uploadButton.layer.cornerRadius = 35
                        
                    })
                    
                }
                
                self.goalImageExample.layer.insertSublayer(overlayGradient, at: 8)
                self.goalImageExample.af_setImage(withURL:URL(string: imageURL )!, placeholderImage: UIImage(named:"no-image-bg"), filter: nil,imageTransition: .crossDissolve(0.2), runImageTransitionIfCached: true, completion: nil)
                
                
                
            }
            
        }   else {
        
            
            self.goalImageExample.image = UIImage(named:"no-image-bg")
            
        }
        
        

        
        
        
        //        self.goalObject.goalTitle = self.goalObject["goalTitle"]
        //        self.goalObject["goalTags"] = self.goalObject["goalTags"]
        self.goalName.text = goalClass?.goalTitle
        
        
        // Commented out WSTags
        //   self.tagsField.addTags(self.goalObject.goalTags ?? [WSTag])
        
    }
    
    
    
    func didChangeText(textField:UITextField) {
        
        if textField.tag == 0 {
            
            self.goalObject.goalTitle = textField.text
            self.goalTitle.text = textField.text
            
        } else {
            
            self.goalObject.goalTarget = Double(textField.text!)
            
        }
        
//
//        
//        
//        if textField.text != "" && (textField.text?.characters.count)! > 5 {
//            
//            self.nextButton.isEnabled = true
//            self.nextButton.backgroundColor = UIColor(red:0.17, green:0.82, blue:0.25, alpha:1.0)
//            
//        }
//        
//        if textField.text == "" {
//            
//            self.nextButton.isEnabled = false
//            self.nextButton.backgroundColor = UIColor(red:0.76, green:0.76, blue:0.76, alpha:1.0)
//            
//        }
//        
//        
        
    }
    
    
    
    // Check textfield status and change accordingly
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        
        
        self.activeField =  nil
        self.activeFieldCell = nil
        
        if  textField.tag == 0 {
            
            textField.resignFirstResponder()
            nameIcon.tintColor = .soraGrey()
            
            
        } else {
            
            textField.resignFirstResponder()
            priceIcon.tintColor = .soraGrey()
            
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        textField.inputAccessoryView = toolBar
        
        if  textField.tag == 0 {
            
            self.activeFieldCell = self.inputCellOne
            nameIcon.tintColor = .soraBlue()
            priceIcon.tintColor = .soraGrey()
            
        } else if textField.tag == 1 {
            
            print("okay222")
            
            self.activeFieldCell = self.inputCellTwo
            // tagIcon.tintColor = UIColor(red:0.20, green:0.68, blue:0.89, alpha:1.0) //Light blue
            nameIcon.tintColor = .soraGrey()
            priceIcon.tintColor = .soraBlue()
            
        }
        
        self.activeField = textField
   
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let countdots = textField.text!.components(separatedBy: ".").count - 1
        var maxLength = 4
        
        if countdots > 0 {
            maxLength = 6
        }
        
        if textField.tag == 0 {
            
            return true
            
        } else {
        
            if countdots > 0 && string == "."
            {
                return false
            } else if (textField.text?.characters.count)! > maxLength {
            
                var newLength = (textField.text?.characters.count)! + string.characters.count - range.length
        
                return newLength <= maxLength
            } else {
                return true
            }
            
        }
        
    }
    

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        
        
        
        cell.separatorInset = UIEdgeInsets.zero
        cell.indentationWidth = 0
        cell.layoutMargins = UIEdgeInsets.zero
        
        //tableView.separatorStyle = .none
        
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.view.endEditing(true)
        
        if  self.activeField?.tag == 0 {
            
            self.activeFieldCell = self.inputCellOne
            self.activeField?.becomeFirstResponder()
            
        } else if self.activeField?.tag == 1 {
            
            self.activeFieldCell = self.inputCellTwo
            self.activeField?.becomeFirstResponder()
            
        } else {
            
//            self.activeFieldCell = self.inputCellTwo
            
        }
        
        if indexPath.row == 1 {
            
            print("DID SELECT 1")
            self.goalName.becomeFirstResponder()
            
        } else if indexPath.row == 2  {
            
            print("DID SELECT 2")
            self.goalCosts.becomeFirstResponder()
            self.activeFieldCell = self.inputCellTwo
            // tagIcon.tintColor = UIColor(red:0.71, green:0.71, blue:0.71, alpha:1.0)
    
        }else if indexPath.row == 3 {
            
            print("DID SELECT 3")
//            self.tagsField.beginEditing()
            
        }

    }
    
    
    
    
    
    
    func keyboardDidShow(_ notification: Notification) {
        
        if  self.goalName.text != "" {
            
//            self.nextButton.isEnabled = true
//            self.nextButton.backgroundColor = UIColor(red:0.17, green:0.82, blue:0.25, alpha:1.0)
            
        }
        
        
        if let activeField = self.activeFieldCell, let keyboardSize = ((notification as NSNotification).userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            
            
            let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height + self.inputCellOne.frame.height, right: 0.0)
            
            if self.editMode == false {
            
                self.tableView.contentInset = contentInsets
                self.tableView.scrollIndicatorInsets = contentInsets

            }
            
            var aRect = self.view.frame
            aRect.size.height -= keyboardSize.size.height
            
            if (!aRect.contains(activeField.frame.origin)) {
                
                    self.tableView.scrollRectToVisible(activeField.frame, animated: true)
            }
            
            
            //                self.view.addSubview(self.nextButton)
//            var windowCount = UIApplication.shared.windows.count
//            UIApplication.shared.windows[windowCount-1].addSubview(self.nextButton);
//            self.nextButton.frame = CGRect(x: self.nextButton.frame.origin.x, y: self.view.bounds.height - keyboardSize.height + 10, width: self.nextButton.frame.size.width, height: self.nextButton.frame.size.height)
            
            
            
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
        NotificationCenter.default.addObserver(self, selector: "keyboardWasShown:", name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(goalsSetup2ViewController.keyboardWillBeHidden(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    
    func deregisterFromKeyboardNotifications()
    {
        //Removing notifies on keyboard appearing
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        print("SEGUE")
        print(segue.destination)
        
        if let stepOne = segue.destination as? goalsSetupViewController {
            
            stepOne.progress = helpers().progressBar(view: self, currentStep: 2, progressBar:self.progress, next: false)
            stepOne.goalObject = self.goalObject
            
        } else if let stepTwo = segue.destination as? goalsSetup2ViewController {
            stepTwo.goalObject = self.goalObject
        } else if let stepThree = segue.destination as? goalsSetup3ViewController {
            stepThree.goalObject = self.goalObject
        }else if let bankSetup = segue.destination as? BankSetupViewController {
            
            bankSetup.progress = helpers().progressBar(view: self, currentStep: 3, progressBar: self.progress, next: true)
            bankSetup.goalObject = self.goalObject
            
        } else if let selectBank = segue.destination as? selectBankAccountViewController {
            
            selectBank.progress = helpers().progressBar(view: self, currentStep: 3, progressBar: self.progress, next: true)
            selectBank.goalObject = self.goalObject
        
        } else if let goalDetail = segue.destination as? detailGoalViewController {
            goalDetail.goalObject = self.goalObject
        } else if let instaUpload =  segue.destination as? PhotoBrowserCollectionViewController {
            instaUpload.goalObject = self.goalObject
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        //         Dispose of any resources that can be recreated.
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
                
                
                instaUploadController.delegate = self
                instaUploadController.goalObject = self.goalObject
                
                let navController = UINavigationController(rootViewController: instaUploadController)
                
                navController.modalPresentationStyle = UIModalPresentationStyle.custom
                navController.transitioningDelegate = self
                self.present(navController, animated: true, completion: nil)
   
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




extension goalsSetup2ViewController:  UIImagePickerControllerDelegate,  UINavigationControllerDelegate {
    
    
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
        
        print("IMAGE RECOVERED")
        print(image)
        self.goalObject.goalImageFile = image
        self.goalImageExample.image = image
        
        
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




//extension goalsSetup2ViewController:  UIImagePickerControllerDelegate,  UINavigationControllerDelegate {
//
//
//
//}
//
//










