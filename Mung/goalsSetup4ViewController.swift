//
//  goalsSetup4ViewController.swift
//  Mung
//
//  Created by Chike Chiejine on 11/11/2016.
//  Copyright © 2016 Color & Space. All rights reserved.
//

import UIKit
import Parse

class goalsSetup4ViewController: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    
    //var goalObject = ["user": PFUser.current(), "goalCategory": String(), "goalTitle": String(), "goalImageUrl": String(), "goalImage": UIImage(), "goalTags": [WSTag](), "goalPrice": Double(), "goalDuration": String(), "risk": String()] as [String : Any]
    
    
    var goalObject = goalsClass(goal: nil)
    
    @IBOutlet weak var goalTitle: UILabel!
    @IBOutlet weak var goalImageExample: UIImageView!
    let overlayGradient = CAGradientLayer()
    
    // Goal duration pickerview variables
    
    var yearsOption = ["0","1","2"]
    var monthsOption = ["0","1","2","3","4","5","6","7","8","9","10","11","12"]
    var weeksOption = ["0","1", "2", "3", "4"]
    var intervals = ["Weeks","Months", "Years"]
    var goalDurationString = ["years": String(),"months": String(), "weeks": String()]
    var duration: String = "Select Duration"
    
    
    @IBOutlet weak var tickIcon: UIImageView!
    
    
    @IBOutlet weak var previewGoalCell: UITableViewCell!
    @IBOutlet weak var inputCellOne: UITableViewCell!
    @IBOutlet weak var inputCellTwo: UITableViewCell!
    // @IBOutlet weak var inputCellThree: UITableViewCell!
    
    
    // Calender
    
    var calendarOverlay = UIView()
    
    var calendar =  FSCalendar()
    
    let gregorian: NSCalendar! = NSCalendar(calendarIdentifier:NSCalendar.Identifier.gregorian)
    
    let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }()
    
    // Initiate tap geture recognizer object
    let tapGesture : UITapGestureRecognizer = UITapGestureRecognizer()
    
    
    // Risk pickerview variables
    
    var riskTypes = ["Low Risk","Medium Risk", "High Risk"]

    
    var durationPicker = UIPickerView()
    var paymentsPicker = UIPickerView()
    var riskPicker = UIPickerView()
    
    let pickerLabelView = UIView()
    let nextButton = UIButton()
    
    // var pickerViews: [UIPickerView] = [durationPicker, paymentsPicker, riskPicker]
  
    // @IBOutlet weak var numberOneLabel: UILabel!
    // @IBOutlet weak var numberTwoLabel: UILabel!
    
    @IBOutlet weak var selectMonths: UIButton!
    @IBOutlet weak var risk: UIButton!
    var activeButton: UIButton?

    
    @IBOutlet weak var selectMonthsField: UITextField!
    @IBOutlet weak var selectPaymentsField: UITextField!
    @IBOutlet weak var selectRiskField: UITextField!
    
    var activeField: UITextField?
    var activeFieldCell: UITableViewCell?
    var currentPicker: UIPickerView?
    
    
    func goBack() {
        
        let stepThree = self.storyboard?.instantiateViewController(withIdentifier: "step3") as! goalsSetup3ViewController
        stepThree.goalObject = self.goalObject
        self.navigationController?.show(stepThree, sender: self)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        //Gradient Overlay
        
        overlayGradient.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        overlayGradient.locations = [0.0, 0.9]
        overlayGradient.frame = CGRect(x: 0, y: 2, width: view.frame.width, height: previewGoalCell.frame.height)
        goalImageExample.layer.insertSublayer(overlayGradient, at: 8)
  
        
        
        // Calender overlay
        
        
        calendarOverlay.frame = self.view.frame
        calendarOverlay.backgroundColor = UIColor(red:0.00, green:0.00, blue:0.00, alpha:0.8)
        calendarOverlay.isHidden = true
        // add tap gesture recognizer into view
        self.calendarOverlay.addGestureRecognizer(self.tapGesture)
        self.view.addSubview(calendarOverlay)
        
        
        
        
        print(calendar.frame.height)
        calendar.frame = CGRect(x: 0, y: self.view.frame.height - calendar.frame.height , width: self.view.bounds.width, height: 300)
        calendar.dataSource = self
        calendar.delegate = self
        calendar.backgroundColor = UIColor.white
        calendar.scopeGesture.isEnabled = false
        calendar.allowsSelection = true

        
        
        
        
        var backButtonImage = UIImage(named: "arrow-icon")
        let newBackButton = UIBarButtonItem(image: backButtonImage, style: UIBarButtonItemStyle.plain, target: self, action: "goBack" )
        self.navigationItem.leftBarButtonItem = newBackButton
        
        
        inputCellOne.tag = 0
        inputCellTwo.tag = 1
        // inputCellThree.tag = 2
        
        //Textfield delegate
        
        self.selectMonthsField.delegate = self
        self.selectPaymentsField.delegate = self
        self.selectRiskField.delegate = self
        
        self.tableView.keyboardDismissMode = .onDrag
        
        // Register keyboard notifications
        
        NotificationCenter.default.addObserver(self, selector: #selector(goalsSetup4ViewController.keyboardDidShow(_:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(goalsSetup4ViewController.keyboardWillBeHidden(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        // set picker view delegate
        self.durationPicker.dataSource = self
        self.durationPicker.delegate = self
        
        self.riskPicker.delegate = self
        self.riskPicker.dataSource = self
        
        // Make number labels rounded
        
        //numberOneLabel.layer.cornerRadius = 15
        //numberOneLabel.layer.masksToBounds = true
        //numberTwoLabel.layer.cornerRadius = 15
        //numberTwoLabel.layer.masksToBounds = true
        
        selectMonths.layer.cornerRadius = 4
        // selectPayments.layer.cornerRadius = 4
        // risk.layer.cornerRadius = 4
        
        
        selectMonths.imageView?.contentMode = .left
        selectMonths.imageView?.layer.masksToBounds = true
        


        self.tableView.keyboardDismissMode = .onDrag
        
        
        // set picker view delegate

        
        let pickerHeight =  (self.view.frame.height / 3)
        self.durationPicker.frame = CGRect(x: 0, y: self.view.frame.height - pickerHeight - 60, width: self.view.frame.width, height: pickerHeight )
        //        self.pickerView.backgroundColor = UIColor(red:0.06, green:0.44, blue:0.60, alpha:0.3)
        self.durationPicker.backgroundColor = UIColor.white
        self.durationPicker.tintColor = .white
        
        self.riskPicker.frame = CGRect(x: 0, y: self.view.frame.height - pickerHeight - 60, width: self.view.frame.width, height: pickerHeight )
        self.riskPicker.backgroundColor = UIColor.white
        self.riskPicker.tintColor = .white
        
        
        // Set textview to picker view
        
        self.selectMonthsField.tag = 0
        self.selectPaymentsField.tag = 1
        self.selectRiskField.tag = 2
        
         self.selectMonthsField.isHidden = true
        self.selectPaymentsField.isHidden = true
        self.selectRiskField.isHidden = true
        
        self.selectMonthsField.inputView = self.durationPicker
        self.selectRiskField.inputView = self.riskPicker
        
        self.selectPaymentsField.addTarget(self, action: #selector(self.didChangeText), for: .editingChanged)
        
        //self.selectPaymentsField.inputView = self.paymentsPicker
        

        // Setup pickerview toolbar
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red:0.20, green:0.68, blue:0.89, alpha:1.0)
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.doneCancelPicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.doneCancelPicker))
        cancelButton.tag = 0
        doneButton.tag = 1
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        self.selectMonthsField.inputAccessoryView = toolBar
        self.selectPaymentsField.inputAccessoryView = toolBar
        self.selectRiskField.inputAccessoryView = toolBar
        
        // Set button tags
        
       selectMonths.tag = 0
       risk.tag = 2
        
        selectMonths.addTarget(self, action: #selector(self.summaryButtonActions), for: UIControlEvents.touchUpInside)
       // selectPayments.addTarget(self, action: #selector(self.summaryButtonActions), for: UIControlEvents.touchUpInside)
       risk.addTarget(self, action: #selector(self.summaryButtonActions), for: UIControlEvents.touchUpInside)
        

        self.tableView.tableFooterView = UIView()

    }
    

    
    func doneCancelPicker(sender: UIButton) {
        
        
        let selectedButtonImage = UIImage(named:"selectbutton.png")
        activeButton?.setBackgroundImage(selectedButtonImage, for: UIControlState.normal)
        
        self.view.endEditing(true)
        
        
        if sender.tag == 1 {
            
            print("SHOULD BE WORKING")
            
        }
        
        
        if self.activeButton == self.risk {
            
            print("RISKACTIVE")
            
            
//            if let risk = self.goalObject["risk"] as? String {
//            print(risk)
//                activeButton?.setTitle(risk, for: UIControlState.normal)
//                
            }
            
            
        }
        
    }

    
    func didChangeText(textField:UITextField) {
        

        
        
    }
    

    
    
    
 
    func summaryButtonActions(sender: UIButton) {
        
        var buttonId = sender.tag
        self.view.endEditing(true)
        print("CURRENTPICKER")
        print(self.currentPicker)
        
        activeButton = sender
        
        if buttonId == 0 {
            
       
            self.selectMonthsField.becomeFirstResponder()
            

            print("BUTTON 1")
            
        } else if buttonId == 1 {
            

            self.selectPaymentsField.becomeFirstResponder()
            

            print("BUTTON 2")
            
        } else {
            
     
            self.selectRiskField.becomeFirstResponder()
            

            print("BUTTON 3")
            
        }
        
   
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        print(self.goalObject)
        
        self.goalTitle.text =  self.goalObject.goalTitle

        
        if let imageURL = self.goalObject.goalImagePath {
        
            self.goalImageExample.af_setImage(withURL:URL(string: imageURL )!, placeholderImage: UIImage(named:"no-image-bg"), filter: nil,imageTransition: .crossDissolve(0.2), runImageTransitionIfCached: true, completion: nil)
        
        }
        
        


    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        self.nextButton.removeFromSuperview()
        self.pickerLabelView.removeFromSuperview()
        
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            
            cell.separatorInset = UIEdgeInsets.zero
            cell.indentationWidth = 0
            cell.layoutMargins = UIEdgeInsets.zero
            tableView.separatorStyle = .singleLine
            
        }
        
        tableView.separatorStyle = .none
        tableView.separatorColor = UIColor(red:0.06, green:0.44, blue:0.60, alpha:1.0)
        
        
    }
    
    

    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK: - picker view delegate and data source
    
    // how many component (i.e. column) to be displayed within picker view
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        switch pickerView {
            
        case durationPicker:
            
            return 3
            
        case riskPicker:
            
            return 1
            
        default:
           
            return 0
        }
      
    }
    
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        
//        switch pickerView {
//
////            case riskPicker:
//            
////                self.goalObject["risk"] = self.riskTypes[row]
//            
////            default: break
//            
//            
//        }
//
        
        
    }
    
    // How many rows are there is each component
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
    
        
        switch pickerView {
            
            case riskPicker:
            
                return  self.riskTypes.count
            
            default:
            
                return 0
        }

        

        
    }
    
    // title/content for row in given component
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        
        
        switch pickerView {
            
            case riskPicker:
            
                return  self.riskTypes[row]
            
            default:
            
                return "Invalid Row"
        }

  
    }

    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let stepOne = segue.destination as? goalsSetupViewController {
            stepOne.goalObject = self.goalObject
        } else if let stepTwo = segue.destination as? goalsSetup2ViewController {
            stepTwo.goalObject = self.goalObject
        } else if let stepThree = segue.destination as? goalsSetup3ViewController {
            stepThree.goalObject = self.goalObject
        } else if let stepFour = segue.destination as? goalsSetup4ViewController {
            stepFour.goalObject = self.goalObject
        }
    }




    
    
    
    // Check textfield status and change accordingly
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        let selectedButtonImage = UIImage(named: "selectbutton.png")
        activeButton?.setBackgroundImage(selectedButtonImage, for: UIControlState.normal)
        
        self.activeField =  nil
        self.activeFieldCell = nil
        textField.resignFirstResponder()
        

        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        let selectedButtonImage = UIImage(named: "selectedButton.png")
        activeButton?.setBackgroundImage(selectedButtonImage, for: UIControlState.normal)
        
        self.activeField = textField
        
        print(textField.tag)
        
        if textField.tag == 0 {
            
            print("ONE")
            self.activeFieldCell = self.inputCellOne
            
        } else if textField.tag == 1 {
            
            print("TWO")
            self.activeFieldCell = self.inputCellTwo

        } else {
            
            print("THREE")
            // self.activeFieldCell = self.inputCellThree
        }
        
        
    }
    
    
    

    func keyboardDidShow(_ notification: Notification) {
        
        print("Keyboard did show")
        print(self.activeButton)
        
        self.nextButton.removeFromSuperview()
        self.pickerLabelView.removeFromSuperview()
        

        
        if let activeField = self.activeFieldCell, let keyboardSize = ((notification as NSNotification).userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            
            print("CONTENTINSETS")
            
                let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height + activeField.frame.origin.y + activeField.frame.height, right: 0.0)
            
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
        
        let selectButtonImage = UIImage(named: "selectbutton.png")
        self.activeButton?.setBackgroundImage(selectButtonImage, for: UIControlState.normal)
        
        self.nextButton.removeFromSuperview()
        self.pickerLabelView.removeFromSuperview()
        
    }
    
    
    
    
    func registerForKeyboardNotifications()
    {
        //Adding notifies on keyboard appearing
        NotificationCenter.default.addObserver(self, selector: "keyboardDidShow:", name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(goalsSetup4ViewController.keyboardWillBeHidden(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    
    func deregisterFromKeyboardNotifications()
    {
        //Removing notifies on keyboard appearing
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
 
    
//}

    





extension goalsSetup4ViewController: FSCalendarDataSource, FSCalendarDelegate {
    
    
    
    
    func minimumDate(for calendar: FSCalendar) -> Date {
        
        print("MIN")
        
        return self.formatter.date(from: "2015/01/01")!
    }
    
    func maximumDate(for calendar: FSCalendar) -> Date {
        
        print("MAX")
        
        return self.formatter.date(from: "2016/10/31")!
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        //#EDITING2
        
        print(monthPosition)
        print(date)
        print(stringFromDate(date: date as NSDate, format: self.formatter.dateFormat))
        // self.goalDurationLabel.setTitle(stringFromDate(date: date as NSDate, format: self.formatter.dateFormat), for: UIControlState.normal)
        // self.goalsDuration.text = stringFromDate(date: date as NSDate, format: self.formatter.dateFormat)
        let stringDate = stringFromDate(date: date as NSDate, format: self.formatter.dateFormat)
        self.goalObject.goalEndDate = dateFromString(date: stringDate, format: self.formatter.dateFormat)
        
        self.nextButton.isEnabled = true
        self.nextButton.backgroundColor = UIColor(red:0.17, green:0.82, blue:0.25, alpha:1.0)
        
        
        if monthPosition == .previous || monthPosition == .next {
            calendar.setCurrentPage(date, animated: true)
            
        }
        
    }
    
    
    
    // Update your frame
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calendar.frame = CGRect(x: 0, y: self.view.frame.maxY - self.calendar.frame.height, width: bounds.width, height: bounds.height)
    }
    
    
    
}






