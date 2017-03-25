//
//  goalsSetup3ViewController.swift
//  Mung
//
//  Created by Chike Chiejine on 05/11/2016.
//  Copyright © 2016 Color & Space. All rights reserved.
//

import UIKit
import Parse


// Next button green: UIColor(red:0.17, green:0.82, blue:0.25, alpha:1.0)

class goalsSetup3ViewController: UITableViewController, UITextFieldDelegate, UIGestureRecognizerDelegate {
    
    
    var goalObject = ["user": PFUser.current(), "goalCategory": String(), "goalTitle": String(), "goalImageUrl": String(), "goalImage": UIImage(), "goalTags": [WSTag](), "goalPrice": Double(), "goalDuration": String(), "risk": String()] as [String : Any]
    
    
    
    
    @IBOutlet weak var priceIcon: UIImageView!
    @IBOutlet weak var durationIcon: UIImageView!
    @IBOutlet weak var amountStepper: GMStepper!

    // @IBOutlet weak var weeksStepper: GMStepper!
    
    var yearsOption = ["0","1","2"]
    var monthsOption = ["0","1","2","3","4","5","6","7","8","9","10","11","12"]
    var weeksOption = ["0","1", "2", "3", "4"]
    var intervals = ["Weeks","Months", "Years"]
    var goalDurationString = ["years": String(),"months": String(), "weeks": String()]
    var duration: String = "Goal Deadline"
    var today = Date()
    var selectedFormat = String()
    var activeField: UITextField?
    var activeFieldCell: UITableViewCell?
    
    @IBOutlet weak var inputCellOne: UITableViewCell!
    @IBOutlet weak var inputCellTwo: UITableViewCell!
    
    @IBOutlet weak var goalCosts: UIView!
    @IBOutlet weak var goalsDuration: UITextField!
    @IBOutlet weak var downArrow: UIImageView!
    
    @IBOutlet weak var nextBarButton: UIBarButtonItem!
    
    // Initiate tap geture recognizer object
    let tapGesture : UITapGestureRecognizer = UITapGestureRecognizer()
    
    @IBOutlet weak var goalDuration: UILabel!
    
    var inputLabelOne = UILabel()
    var inputLabelTwo = UILabel()
    
    var underlineOne = UIView()
    var underlineTwo = UIView()
    var pickerView = UIPickerView()
    let pickerLabelView = UIView()
    let nextButton = UIButton()
    
    // Calender
    
    var calendarOverlay = UIView()
    
    var calendar =  FSCalendar()
    
    let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }()
    
    let gregorian: NSCalendar! = NSCalendar(calendarIdentifier:NSCalendar.Identifier.gregorian)
    

    
    // Go back
    
    
    func goBack() {
        
        let stepTwo = self.storyboard?.instantiateViewController(withIdentifier: "step2") as! goalsSetup2ViewController
        stepTwo.goalObject = self.goalObject
        self.navigationController?.show(stepTwo, sender: self)
        
    }
    
    
    // function - increase count when screen tapped.
    func increaseCount(){
        
        print("TAPPED")
        self.view.endEditing(true)
        self.calendarOverlay.isHidden = true
        var windowCount = UIApplication.shared.windows.count
        
        
        
        UIView.animate(withDuration: 0.2, delay: 0, options: UIViewAnimationOptions.curveEaseIn, animations: {
            
            
            
            self.nextButton.frame = CGRect(x: self.nextButton.bounds.origin.x, y: self.view.bounds.height - self.nextButton.bounds.height , width: self.nextButton.bounds.size.width, height: self.nextButton.bounds.size.height)
            self.view.addSubview(self.nextButton)
            
        }, completion: {(true) in
            
            
            //                    self.view.endEditing(true)
            
            
        })
        
        self.calendar.removeFromSuperview()

        
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        amountStepper.addTarget(self, action: #selector(self.stepperValueChanged), for: .valueChanged)
        //weeksStepper.addTarget(self, action: #selector(self.weeksValueChanged), for: .valueChanged)
        //weeksStepper.labelFont = UIFont(name: "ProximaNovaSoft-Bold", size: 16)!
        amountStepper.labelFont = UIFont(name: "ProximaNovaSoft-Bold", size: 16)!
        
        priceIcon.tintColor = UIColor(red:0.71, green:0.71, blue:0.71, alpha:1.0) // Gray
        durationIcon.tintColor = UIColor(red:0.71, green:0.71, blue:0.71, alpha:1.0) //Grey
  
        
        // set tap gesture recognizer delegte
        self.tapGesture.delegate = self
        self.tapGesture.numberOfTapsRequired = 1
        // set tap gesture target
        self.tapGesture.addTarget(self, action: #selector(self.increaseCount))

        
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
   
//        calendar.isHidden = true
//        self.view.addSubview(calendar)
        
        
        // Back button
        
        var backButtonImage = UIImage(named: "arrow-icon")
        let newBackButton = UIBarButtonItem(image: backButtonImage, style: UIBarButtonItemStyle.plain, target: self, action: "goBack" )
        self.navigationItem.leftBarButtonItem = newBackButton
        
        // Next bar button
        
        nextBarButton.isEnabled = false
        
        // Set up textfields delegate
        
//        self.goalCosts.delegate = self
        self.goalsDuration.delegate = self
        self.goalCosts.tag = 0
        self.goalsDuration.tag = 1
//        self.goalCosts.addTarget(self, action: #selector(self.didChangeText), for: .editingChanged)
        self.goalsDuration.addTarget(self, action: #selector(self.didChangeText), for: .editingChanged)
//        self.goalsDuration.inputView = self.pickerView

        
        // Register keyboard notifications
        
        NotificationCenter.default.addObserver(self, selector: #selector(goalsSetup3ViewController.keyboardDidShow(_:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(goalsSetup3ViewController.keyboardWillBeHidden(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        self.downArrow.tintColor = UIColor.lightGray
        
        
        // Setup Next Button

        nextButton.setTitle("Next Step", for: UIControlState.normal)
        nextButton.tintColor = UIColor(red:0.13, green:0.13, blue:0.13, alpha:1.0)
        nextButton.isEnabled = false
        nextButton.backgroundColor = UIColor(red:0.76, green:0.76, blue:0.76, alpha:1.0)
        nextButton.frame = CGRect(x: 0, y: self.view.bounds.height - 119, width: self.view.frame.width, height: 55)
        nextButton.addTarget(self, action: #selector(self.nextButtonAction), for: UIControlEvents.touchUpInside)
   
        


        self.selectedFormat = "Weeks"
        self.tableView.tableFooterView = UIView()
        
        // Get positions
        let inputOneOriginY = self.goalCosts.frame.origin.y
        let inputOneOriginX = self.goalCosts.frame.origin.x
        let inputWidth = self.goalCosts.frame.width
        let inputOneHeight = self.inputCellOne.frame.height
        let inputTwoHeight = self.inputCellTwo.frame.height
        let inputOneWidth = self.view.bounds.width

       
        // Create underline
        underlineOne.frame = CGRect(x: 10, y: inputOneHeight - 4, width: inputOneWidth - 20, height: 0.5)
        underlineOne.backgroundColor = UIColor.lightGray
        //Add subviews
        self.inputCellOne.addSubview(underlineOne)
         underlineTwo.frame = CGRect(x: 10, y: inputTwoHeight - 4, width: inputOneWidth - 20, height: 0.5)
        underlineTwo.backgroundColor = UIColor.lightGray
        //Add subviews
        self.inputCellTwo.addSubview(underlineTwo)
        
        
        inputCellOne.tag = 0
        inputCellTwo.tag = 1
 
  
    }
    
    func weeksValueChanged(stepper: GMStepper) {
        
        let intValue = Int(stepper.value)
        let stringValue = String(intValue)
        let stepperLabel = "\(stringValue) Weeks"
        stepper.label.text = stepperLabel
        
        self.priceIcon.tintColor = UIColor(red:0.71, green:0.71, blue:0.71, alpha:1.0) // Gray
        self.durationIcon.tintColor = UIColor(red:0.20, green:0.68, blue:0.89, alpha:1.0) //Light blue
        
        
        if self.goalObject["goalPrice"] as! Double != 0.0 {
            
            // Next bar button
            nextBarButton.isEnabled = true
            self.nextButton.isEnabled = true
            self.nextButton.backgroundColor = UIColor(red:0.17, green:0.82, blue:0.25, alpha:1.0)
            
        }
        
        
    }
    
    func stepperValueChanged(stepper: GMStepper) {
        
        print(stepper.value, terminator: "")
        
        goalObject["goalPrice"] = stepper.value
        
        self.priceIcon.tintColor = UIColor(red:0.20, green:0.68, blue:0.89, alpha:1.0) //Light blue
        self.durationIcon.tintColor = UIColor(red:0.71, green:0.71, blue:0.71, alpha:1.0) // Gray
        
        if self.goalObject["goalDuration"] as! String != "" {
            
            // Next bar button
            nextBarButton.isEnabled = true
            self.nextButton.isEnabled = true
            self.nextButton.backgroundColor = UIColor(red:0.17, green:0.82, blue:0.25, alpha:1.0)
            
        }
        
        
        
    }
    
    func nextButtonAction(sender: UIButton) {
        
        let indexPath = sender.tag
        let nextvC = self.storyboard?.instantiateViewController(withIdentifier: "step4") as! goalsSetup4ViewController
        nextvC.goalObject = self.goalObject
        self.show(nextvC, sender: self)
        
    }
    
    func didChangeText(textField:UITextField) {
        
        if textField.tag == 0 {
            
            if let textFieldText = textField.text {
                
                self.goalObject["goalPrice"] = Int(textFieldText)
                
            }
            
        } else {
            
        self.goalObject["goalDuration"] = textField.text
            
        }
     
        if textField.text != "" {
            
            print("NOW TYPING")
            
            // Next bar button
            nextBarButton.isEnabled = true
            self.nextButton.isEnabled = true
            self.nextButton.backgroundColor = UIColor(red:0.17, green:0.82, blue:0.25, alpha:1.0)
            
        }
        
        if textField.text == "" {
            
            print("NOW EMPTY")
            // Next bar button
            nextBarButton.isEnabled = false
            self.nextButton.isEnabled = false
            self.nextButton.backgroundColor = UIColor(red:0.76, green:0.76, blue:0.76, alpha:1.0)
            
            
        }

 
        
    }
    


    
    
    override func viewWillAppear(_ animated: Bool) {
        
        print(goalObject)
        

        // let intValue = Int(self.weeksStepper.value)
        // let stringValue = String(intValue)
        // let stepperLabel = "\(stringValue) Weeks"
        // self.weeksStepper.label.text = stepperLabel
    
        
        if self.amountStepper.value != 0 && self.goalObject["goalDuration"] as! String != "" {
            
            // Next bar button
            nextBarButton.isEnabled = true
            self.nextButton.isEnabled = true
            self.nextButton.backgroundColor = UIColor(red:0.17, green:0.82, blue:0.25, alpha:1.0)
            
        }
        
        self.view.addSubview(self.nextButton)
        
        self.priceIcon.tintColor = UIColor(red:0.20, green:0.68, blue:0.89, alpha:1.0) //Light blue
        

        
        self.amountStepper.value = goalObject["goalPrice"] as! Double

        if self.goalObject["goalDuration"] as! String == ""{
            
            self.goalDuration.text = self.duration
            
        } else {

        self.duration = self.goalObject["goalDuration"] as! String
        
            self.goalDuration.text = self.duration
            
            
        }
        
        // #EDITING


        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        // self.goalCosts.becomeFirstResponder()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        priceIcon.tintColor = UIColor(red:0.71, green:0.71, blue:0.71, alpha:1.0) // Gray
        durationIcon.tintColor = UIColor(red:0.71, green:0.71, blue:0.71, alpha:1.0) //Grey
        self.nextButton.removeFromSuperview()
        self.calendar.removeFromSuperview()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    // MARK: - table view delegate and data source
    
    // how many component (i.e. column) to be displayed within picker view
    
    

    
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            
            cell.separatorInset = UIEdgeInsets.zero
            cell.indentationWidth = 0
            cell.layoutMargins = UIEdgeInsets.zero
            tableView.separatorStyle = .singleLine
            
        }
        
        tableView.separatorStyle = .none
        
        
    }
    
    
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("SELECTED")
        print(indexPath.row)
        
        self.view.endEditing(true)
        
        if  self.activeField?.tag == 0 {
            
            self.activeFieldCell = self.inputCellOne
            underlineOne.backgroundColor =  UIColor(red:0.20, green:0.68, blue:0.89, alpha:1.0) //Light blue
            self.activeField?.becomeFirstResponder()
            self.downArrow.tintColor =  UIColor(red:0.20, green:0.68, blue:0.89, alpha:1.0) //Light blue
            
        } else {
            
            self.activeFieldCell = self.inputCellTwo
            // underlineTwo.backgroundColor = UIColor.white
           // self.downArrow.tintColor = .white
            self.activeField?.becomeFirstResponder()
            
        }
        
        
    
        
        
        if indexPath.row == 2 {

            print("VIEWSHOULDMOVE000")
            self.calendarOverlay.isHidden = false
            self.goalsDuration.becomeFirstResponder()
            self.downArrow.tintColor = .white
            
            
            self.priceIcon.tintColor = UIColor(red:0.71, green:0.71, blue:0.71, alpha:1.0) // Gray
            self.durationIcon.tintColor = UIColor(red:0.20, green:0.68, blue:0.89, alpha:1.0) //Light blue

            
//            self.tableView.scrollRectToVisible((self.underlineTwo.frame), animated: true)
            
           

            
            
            UIView.animate(withDuration: 0.1, delay: 0, options: UIViewAnimationOptions.curveEaseIn, animations: {
                
                
                self.calendar.frame = CGRect(x: 0, y: self.view.bounds.height - self.calendar.bounds.height + self.nextButton.bounds.size.height + 10, width: self.view.bounds.width, height: self.calendar.bounds.height)
                

                self.nextButton.frame = CGRect(x: self.nextButton.bounds.origin.x, y: self.view.bounds.height - self.calendar.bounds.height + 10, width: self.nextButton.bounds.size.width, height: self.nextButton.bounds.size.height)

                var windowCount = UIApplication.shared.windows.count
                UIApplication.shared.windows[windowCount-1].addSubview(self.nextButton)
                UIApplication.shared.windows[windowCount-1].addSubview(self.calendar)
       
                
                
            }, completion: {(true) in
                
                
//                    self.view.endEditing(true)

                
            })
            
            
       
            
            
            
        }

        

    }
    





    
    // Check textfield status and change accordingly
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        self.activeField =  nil
        self.activeFieldCell = nil
        
        if  textField.tag == 0 {
            
            textField.resignFirstResponder()
            underlineOne.backgroundColor = UIColor.lightGray
            
        } else {
        
            print("SECOND TEXTFIELD")
            textField.resignFirstResponder()
            underlineTwo.backgroundColor = UIColor.lightGray
            self.downArrow.tintColor = UIColor.lightGray
            
        }
        
      
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if  textField.tag == 0 {
            
            self.activeFieldCell = self.inputCellOne
            underlineOne.backgroundColor = UIColor(red:0.20, green:0.68, blue:0.89, alpha:1.0) //Light blue
        } else {
            
            self.activeFieldCell = self.inputCellTwo
            underlineTwo.backgroundColor = UIColor(red:0.20, green:0.68, blue:0.89, alpha:1.0) //Light blue
            self.downArrow.tintColor = UIColor(red:0.20, green:0.68, blue:0.89, alpha:1.0) //Light blue
            
        }
        
        self.activeField = textField
        

        
    }
    
    

    func keyboardDidShow(_ notification: Notification) {
        
        print("Keyboard did show")
        print(self.activeField)
        
    
        
    
        if let activeField = self.activeFieldCell, let keyboardSize = ((notification as NSNotification).userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            
            var contentInsets = UIEdgeInsets()
       
            if activeField.tag == 0 {
            
                contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height + self.inputCellOne.frame.height + 100, right: 0.0)
                print(0)
                print(contentInsets)
                
            } else {
            
                contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height + self.inputCellTwo.frame.height + 100, right: 0.0)
                
            }
            
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
        
        
        // self.nextButton.removeFromSuperview()
        
    }
    
    
    
    
    func registerForKeyboardNotifications()
    {
        //Adding notifies on keyboard appearing
        NotificationCenter.default.addObserver(self, selector: "keyboardWasShown:", name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(goalsSetup3ViewController.keyboardWillBeHidden(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    
    func deregisterFromKeyboardNotifications()
    {
        //Removing notifies on keyboard appearing
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
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
    
    


}







extension goalsSetup3ViewController: FSCalendarDataSource, FSCalendarDelegate {
    
    

    
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
        self.duration = stringFromDate(date: date as NSDate, format: self.formatter.dateFormat)
        self.goalDuration.text = self.duration
        self.goalObject["goalDuration"] = self.duration
        
        
        if self.amountStepper.value != 0 {
            
            
            self.nextButton.isEnabled = true
            self.nextButton.backgroundColor = UIColor(red:0.17, green:0.82, blue:0.25, alpha:1.0)
            
        }
        
        
        
        
        
        print(self.goalObject["goalDuration"])
        
        if monthPosition == .previous || monthPosition == .next {
            calendar.setCurrentPage(date, animated: true)
            
        }
        
    }
    
    // Update your frame
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calendar.frame = CGRect(x: 0, y: self.view.frame.maxY - self.calendar.frame.height, width: bounds.width, height: bounds.height)
    }
    
    
    
}


