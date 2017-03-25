//
//  goalsSetup3ViewController.swift
//  Mung
//
//  Created by Chike Chiejine on 02/01/2017.
//  Copyright © 2017 Color & Space. All rights reserved.
//

import UIKit
import Parse
import SCLAlertView
import Alamofire
import GameplayKit


class goalsSetup3ViewController: UITableViewController, UIGestureRecognizerDelegate {
    
    let kInfoTitle = "Authorize Payments"
    let kSubtitle = "Start investing today and get to your goals even quicker."
    
    var goalObject = goalsClass(goal: nil)
    
    var plaidAccessToken = "hellogoodbye"
    
    //var selectedGoal : PFObject?
    var editMode = false
    
    var duration = String()
    
    @IBOutlet weak var inputCellOne: UITableViewCell!
    
    @IBOutlet weak var blueTick: UIImageView!
    //XYZ 777
    
    @IBOutlet weak var goalSummary: UILabel!
    @IBOutlet weak var goalDeadline: UITextField!
    @IBOutlet weak var goalLabelButton: UIButton!
    @IBOutlet weak var goalStepper: GMStepper!
    
    @IBOutlet weak var goalTitle: UILabel!
    @IBOutlet weak var goalImageExample: UIImageView!
    @IBOutlet weak var exampleGoalCell: UITableViewCell!
    
    var goalCurDepositRate: Int?
    var goalTarget: Double?
    var goalEndDate: Date?
    var weeklySaveAmount: Double?
    
    var calActivityIndicator = UIActivityIndicatorView()
    var paymentsActivityIndicator = UIActivityIndicatorView()
    
    let overlayGradient = CAGradientLayer()
    
    var doneButton = UIButton()
    var authButton = UIButton()
    var progress = UIView()
    
    // Calender
    // Initiate tap geture recognizer object
    let tapGesture : UITapGestureRecognizer = UITapGestureRecognizer()
    var calendarOverlay = UIView()
    var calendar =  FSCalendar()
    var withCalendar = false
    var initData = false
    
    let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }()
    
    let gregorian: NSCalendar! = NSCalendar(calendarIdentifier:NSCalendar.Identifier.gregorian)
    
    @IBAction func goalEndAction(_ sender: Any) {
        let windowCount = UIApplication.shared.windows.count
        UIApplication.shared.windows[windowCount-1].addSubview(calendarOverlay)
        UIApplication.shared.windows[windowCount-1].addSubview(self.calendar)
    }
    
    

    
    @IBAction func goBack(_ sender: Any) {
        
    }
    
    @IBAction func authoriseAction(_ sender: Any) {
        
        self.progress.removeFromSuperview()
        self.view.endEditing(true)
        let appearance = SCLAlertView.SCLAppearance(
            kCircleHeight: 48,
            kCircleIconHeight: 32,
            kTitleFont: UIFont(name: "Proxima Nova Soft", size: 20 )!,
            kTextFont: UIFont(name: "Proxima Nova Soft", size: 14 )!,
            kButtonFont: UIFont(name: "Proxima Nova Soft", size: 14 )!,
            showCloseButton: false,
            dynamicAnimatorActive: false
        )
        let icon = UIImageView()
        icon.image = UIImage(named:"sora-logo")
        icon.tintColor = .white
        let color = UIColor(red:0.20, green:0.68, blue:0.89, alpha:1.0)
        let alert = SCLAlertView(appearance: appearance)
        alert.addButton("Later") {
            print("Second button tapped")
            // Stop activity indicator whilst user is being signed up
            let vC = self.storyboard?.instantiateViewController(withIdentifier: "home")
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = vC
        }
        alert.addButton("Authorize", target:self, selector:#selector(userAuthorization))
        _ = alert.showCustom(kInfoTitle, subTitle: kSubtitle, color: color, icon: icon.image!)
    }
    
    
    
    func getSaveAmount(completion: @escaping (Double?, Error?) -> Void) {
        var components = URLComponents()
        // modify to https when migrating to google cloud
        components.scheme = "http"
        components.host = "localhost"
        components.port = 8080
        components.path = "/getSaveAmount"
        
        // TODO Write getSaveAmount function in server side
        print("plaidAccessToken")
        print(plaidAccessToken)
        
        let dataFields = [
            // "sandbox": false,
            "plaidAccessToken": self.plaidAccessToken
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
            //print("Sucess")
            case .failure:
                print("someerrorwithgetsaveamount")
                completion(nil, NSError())
                break
            }
        }
    }
    
    
    
    func userAuthorization() {
        
        // 1. Save goal
       // goalObject.saveGoalClassinDB()
        // 2. Create Payment Schedule
        
        //call create payment schedule
        goalObject.createPaymentSchedule(completion: { didCreate, error in
            if error == nil {
                print(didCreate)
                print("We successfully created the goal's Payment Schedule")
            }
        })
    }
    
    
    // function - increase count when screen tapped.
    func changeStepperFromCalendar(){
        // AFTER DATE IS SELECTED WITH CALENDER THIS FUNCTION IS TRIGGERED TO CHANGE STEPPER VALUE
        let curDate = Date()
        let newEndDate = self.calendar.selectedDate
        let currentCalendar = Calendar.current
        let start = currentCalendar.ordinality(of: .day, in: .era, for: curDate)
        let end = currentCalendar.ordinality(of: .day, in: .era, for: newEndDate)
        let weeksBetween = Double((end! - start!))/7.0
        print("self.goalObject.goalAmountRemain")
        print(self.goalObject.goalAmountRemain)
        
        self.goalLabelButton.setTitle(self.duration, for: .normal)
        
        //
        if (self.edgeCaseChecker(newStepperValue: nil, timeInterval: weeksBetween)) {
            
            // TODO: Date shouldn't change if this fail as it currently does
            print("we have passed Edge-Case Calendar Checker")
            
            if (self.goalObject.goalAmountRemain != nil) {
                let newRate = self.goalObject.goalAmountRemain! / weeksBetween
                let newRateRounded = Double(round(100*newRate)/100)
                self.goalStepper.value = newRateRounded
                
                let prettydate = helperFuns().convertTargetDate(targetDate: newEndDate)
                self.goalSummary.text = "You will reach $\(self.goalObject.goalTarget!) in \(prettydate) with weekly payments of $\(newRateRounded)"
                
            }
            
            // VALUE CHANGE
            self.withCalendar = true
            self.goalStepper.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            UIView.animate(withDuration: 1.0,
                           delay: 0,
                           usingSpringWithDamping: 0.1,
                           initialSpringVelocity: 4.0,
                           options: .allowUserInteraction,
                           animations: { [weak self] in
                            self?.goalStepper.transform = .identity }, completion: nil)
           
            
            
        }
        
        self.calendar.removeFromSuperview()
        self.calendarOverlay.removeFromSuperview()
        
        
        
    }
    
    
    func edgeCaseChecker(newStepperValue: Double?, timeInterval: (Double?)) -> Bool {
        
        var boolChecker = Bool()
        
        if newStepperValue != nil {
            if newStepperValue! > 2.0 || newStepperValue! < 1000.0 {
                boolChecker = true
            }
            else { boolChecker = false  }
            
            return true
            
        }else if timeInterval != nil {
            if timeInterval! > 1.5 && timeInterval! < 104 {
                boolChecker = true
            }
            
        } else {
            
            boolChecker = false
        }
        return boolChecker
    }
    
    
    func changeDatefromStepper(stepper: GMStepper) {
        if self.withCalendar == false && self.initData == false {
            // THIS CHANGES THE DATE AFTER THE STEPPER IS USED
            self.goalObject.goalSaveRate = stepper.value
            // ADD MORE DAYS
            let curDate = Date()
            var selectedDate = self.calendar.selectedDate
            let saveRate = self.goalObject.goalSaveRate
            let goalTarget = self.goalObject.goalTarget
            let goalDuration = goalTarget!/saveRate!
            let newSaveRate = stepper.value
            let newGoalDuration = (goalTarget!/newSaveRate)   //in weeks
            var newDate = curDate.addingTimeInterval(TimeInterval(newGoalDuration * 604800))
            
            
            //Edge cases
            
            // Goal Duration is less than 1.5 weeks -> response: "You might as well buy it now".
            
            // Goal Duration is greater than 2 years -> response: "Only allow up to 2 years"
            
            // Amount is less than $2 week -> response: "Require minimum of $2 per week"
            
            // Amount is greater than $1000 -> response: "Allow maximum of $1000 week"
            
            
            // If the applied stepper or calendar change takes it to an edge case, block the action and display msg.
            

            
            print("newDate1.a")
            print(newGoalDuration)
            print(newDate)
            
            //XYZ-STEPPER
            
            //  !!!!!!!!!!!!!!!!------------  Can't remember where this goes but I know its important:   self.withCalendar = false  ----------------!!!!!!!!!!!!!!!
            
            // Calculate a minimum- unique to each goal. This is how we "let the stepper know" and then use it for the ifElse statement below.
            var minimumValue = 2
            stepper.minimumValue = Double(minimumValue)
            
            if stepper.value <= stepper.minimumValue {
                
                print("EDGE")
                print("Stepper Limit")
                helpers().soraUserAlert(view: self, string: "Please input a greater weekly amount.")
                stepper.leftButton.isEnabled = false
                stepper.leftButton.backgroundColor = UIColor.soraHeartRed()
                stepper.label.isEnabled = false
                
                
            } else {
                
                if (self.edgeCaseChecker(newStepperValue: stepper.value, timeInterval:  newGoalDuration)) {
                    
                    print("NOEDGE")
                    
                    self.duration = stringFromDate(date: newDate as NSDate, format: self.formatter.dateFormat)
                    self.goalLabelButton.setTitle(self.duration, for: .normal)
                    
                    stepper.leftButton.isEnabled = true
                    stepper.leftButton.backgroundColor = UIColor(red:0.90, green:0.90, blue:0.90, alpha:1.0)
                    stepper.label.isEnabled = true
                    
                    self.goalLabelButton.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                    UIView.animate(withDuration: 2.0,
                                   delay: 0,
                                   usingSpringWithDamping: 0.2,
                                   initialSpringVelocity: 6.0,
                                   options: .allowUserInteraction,
                                   animations: { [weak self] in
                                    self?.goalLabelButton.transform = .identity }, completion: nil)
                    // VALUE CHANGE
                    self.calendar.setCurrentPage(newDate, animated: true)
                    self.calendar.select(newDate)
                    
                    let prettydate = helperFuns().convertTargetDate(targetDate: newDate)
                    self.goalSummary.text = "You will reach $\(self.goalObject.goalTarget!) in \(prettydate) with weekly payments of $\(newSaveRate)"
                    
                }
         
            }
            //XYZ-STEPPER-END

        } else {
            
            self.withCalendar = false
            
        }
    }
    
    func populateData() {
        
        // XYZ - Set current date to today
        let curDate = Date()
        calendar.setCurrentPage(curDate, animated: true)
        
        var numWeeks = Int()
        var saveRate = Double()
        
        print("maxWeeklySaveAmount")
        print(self.weeklySaveAmount)
        print(self.goalObject)
        print(self.weeklySaveAmount)
        
        if (self.goalObject.goalTarget! < self.weeklySaveAmount!) {
            
            // pick 2, 3, 4 weeks randomly
            let rand = GKMersenneTwisterRandomSource()          // the generator can be specified
            let randomDist = GKRandomDistribution(randomSource: rand, lowestValue: 1, highestValue: 100)
            let randInt = randomDist.nextInt()
            
            // 2 weeks savings
            if randInt < 50 {
                self.goalObject.goalSaveRate = self.goalObject.goalTarget! / 2
                numWeeks = 2
                print("goalObject.goalSaveRate1.a")
                print(self.goalObject.goalSaveRate)
            }
            else if (randInt < 90) {
                self.goalObject.goalSaveRate = self.goalObject.goalTarget! / 3
                numWeeks = 3
                print("goalObject.goalSaveRate2.a")
                print(self.goalObject.goalSaveRate)
            }
            else {
                self.goalObject.goalSaveRate = self.goalObject.goalTarget! / 4
                numWeeks = 4
                print("goalObject.goalSaveRate3.a")
                print(self.goalObject.goalSaveRate)
            }
        } else {
            //shave a portion of weekly save amount
            let rand = GKMersenneTwisterRandomSource()          // the generator can be specified
            let randomDist = GKRandomDistribution(randomSource: rand, lowestValue: 80, highestValue: 100)
            let percShave = Double(randomDist.nextInt()) / 100.0
            let saveRate = Double(self.weeklySaveAmount!) * percShave
            self.goalObject.goalSaveRate = saveRate
            numWeeks = Int(ceil(self.goalObject.goalTarget! / saveRate))
            print("goalObject.goalSaveRate")
            print(self.goalObject.goalSaveRate)
        }
        let goalStartDate = Date()
        let goalEndDate = Calendar.current.date(byAdding: .day, value: (numWeeks*7), to: goalStartDate)
        self.goalObject.goalEndDate = goalEndDate
        
        print("goalObject.goalEndDate")
        print(self.goalObject.goalEndDate)
        
        // populate calendar
        self.calendar.currentPage = self.goalObject.goalEndDate!
        self.calendar.select(self.goalObject.goalEndDate!)
        self.duration = stringFromDate(date: self.goalObject.goalEndDate! as NSDate, format: self.formatter.dateFormat)
        self.goalLabelButton.setTitle(self.duration, for: .normal)
        
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 2
        if self.goalObject.goalSaveRate != nil {
            let double = Double(self.goalObject.goalSaveRate!)
            let goalSaveRate = formatter.string(from: double as NSNumber)
            self.goalStepper.value =  Double(goalSaveRate!)!
        }
        
        
        if self.editMode {
            self.goalStepper.value =  Double(self.goalObject.goalSaveRate!)
            self.calendar.currentPage = self.goalObject.goalEndDate!
            self.calendar.select(self.goalObject.goalEndDate!)
            self.duration = stringFromDate(date: self.goalObject.goalEndDate! as NSDate, format: self.formatter.dateFormat)
            self.goalLabelButton.setTitle(self.duration, for: .normal)
        } else {
        }
        
        let prettydate = helperFuns().convertTargetDate(targetDate: goalEndDate!)
        
        self.goalSummary.text = "You will reach $\(self.goalObject.goalTarget!) in \(prettydate) with weekly payments of $\(self.goalObject.goalSaveRate!)"
        
        

        self.tableView.reloadData()
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initData = true
    
        self.populateData()
        
        self.blueTick.tintColor = UIColor.soraBlue()
        
        //Gradient Overlay
        overlayGradient.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        overlayGradient.locations = [0.0, 0.9]
        overlayGradient.frame = CGRect(x: 0, y: 2, width: view.frame.width, height: exampleGoalCell.frame.height)
        goalImageExample.layer.insertSublayer(overlayGradient, at: 8)
        
        // Amount Stepper
        goalStepper.addTarget(self, action: #selector(self.changeDatefromStepper), for: .valueChanged)
        goalStepper.labelFont = UIFont(name: "ProximaNovaSoft-Bold", size: 16)!
        
        // set tap gesture recognizer delegte
        self.tapGesture.delegate = self
        self.tapGesture.numberOfTapsRequired = 1
        // set tap gesture target
        self.tapGesture.addTarget(self, action: #selector(self.changeStepperFromCalendar))
        
        
        // Calender overlay
        calendarOverlay.frame = self.view.frame
        calendarOverlay.backgroundColor = UIColor(red:0.00, green:0.00, blue:0.00, alpha:0.8)
        calendarOverlay.isHidden = false
        // add tap gesture recognizer into view
        self.calendarOverlay.addGestureRecognizer(self.tapGesture)
        
        //Button
        doneButton.frame = CGRect(x: self.view.frame.width / 2 -  60, y: self.view.frame.height - 90, width: 120, height: 40)
        doneButton.backgroundColor = UIColor(red:0.20, green:0.68, blue:0.89, alpha:1.0)
        doneButton.tintColor = .white
        doneButton.titleLabel?.font =  UIFont(name: "Proxima Nova Soft", size: 16 )!
        doneButton.layer.cornerRadius = 5
        doneButton.setTitle("Done", for: UIControlState.normal)
        doneButton.isHidden = true
        doneButton.addTarget(self, action:#selector(self.changeStepperFromCalendar), for: UIControlEvents.touchUpInside)
        calendarOverlay.addSubview(doneButton)
        
        //Calender
        calendar.frame = CGRect(x: 15, y: self.view.frame.height / 2 - 150, width: self.view.bounds.width - 30, height: 300)
        calendar.layer.cornerRadius = 10
        calendar.layer.masksToBounds = true
        calendar.dataSource = self
        calendar.delegate = self
        calendar.backgroundColor = UIColor.white
        calendar.tintColor = UIColor(red:0.20, green:0.68, blue:0.89, alpha:1.0) //Light blue
        calendar.appearance.selectionColor = UIColor(red:0.20, green:0.68, blue:0.89, alpha:1.0) //Light blue
        calendar.appearance.headerTitleColor = UIColor(red:0.20, green:0.68, blue:0.89, alpha:1.0) //Light
        calendar.appearance.weekdayTextColor =  UIColor(red:0.13, green:0.13, blue:0.13, alpha:1.0) // Dark Gray
        calendar.appearance.subtitleDefaultColor = UIColor(red:0.13, green:0.13, blue:0.13, alpha:1.0) // Dark Gray
        calendar.appearance.headerTitleFont = UIFont(name: "Proxima Nova Soft", size: 18 )!
        calendar.appearance.subtitleFont = UIFont(name: "Proxima Nova Soft", size: 14 )!
        calendar.scopeGesture.isEnabled = false
        calendar.allowsMultipleSelection = false
        calendar.allowsSelection = true
        
        self.goalLabelButton.layer.cornerRadius = 5
        authButton.setTitle("Finish", for: UIControlState.normal)
        authButton.tintColor = UIColor(red:0.13, green:0.13, blue:0.13, alpha:1.0)
        authButton.isEnabled  = true
        authButton.backgroundColor = UIColor(red:0.20, green:0.68, blue:0.89, alpha:1.0) //Light blue
        authButton.frame = CGRect(x: 0, y: self.view.frame.height - 55, width: self.view.frame.width, height: 55)
        authButton.addTarget(self, action: #selector(self.authoriseAction), for: UIControlEvents.touchUpInside)
        
        
        
        
        
        // done with setup
        self.initData = false
        
        //    })
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.initData = true
        
        let windowCount = UIApplication.shared.windows.count
        UIApplication.shared.windows[windowCount-1].addSubview(authButton)
        
        if !(self.editMode) {
            
            self.goalTitle.text =  self.goalObject.goalTitle
            
            
            if self.goalObject.goalImagePath != nil {
                if let imageURL = self.goalObject.goalImagePath {
                    if  imageURL != nil {
                        print("IMAGE AVAILABLE")
                        self.goalImageExample.af_setImage(withURL:URL(string: imageURL )!, placeholderImage: UIImage(named:"no-image-bg"), filter: nil,imageTransition: .crossDissolve(0.2), runImageTransitionIfCached: true, completion: nil)
                    } else {
                        print("IMAGE NOT AVAILABLE")
                        self.goalImageExample.image = UIImage(named:"no-image-bg")
                    }
                }
            } else {
                if let image = self.goalObject.goalImageFile {
                    self.goalImageExample.image = image
                }
            }
            // END SETUP MODE
        } else {
            // EDIT MODE ACTIVE
//            helpers().backButton(sender: self)
            self.goalTitle.text = self.goalObject.goalTitle
            if let imageURL = self.goalObject.goalImagePath {
                self.goalImageExample.af_setImage(withURL:URL(string: imageURL )!, placeholderImage: UIImage(named:"no-image-bg"), filter: nil,imageTransition: .crossDissolve(0.2), runImageTransitionIfCached: true, completion: nil)
            }
            // END SETUP MODE
        }
        self.initData = false
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        authButton.removeFromSuperview()
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            cell.separatorInset = UIEdgeInsets.zero
            cell.indentationWidth = 0
            cell.layoutMargins = UIEdgeInsets.zero
            tableView.separatorStyle = .singleLine
        }
        tableView.separatorStyle = .none
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let stepOne = segue.destination as? goalsSetupViewController {
            stepOne.goalObject = self.goalObject
        } else if let stepTwo = segue.destination as? goalsSetup2ViewController {
            stepTwo.goalObject = self.goalObject
        } else if let stepThree = segue.destination as? goalsSetup3ViewController {
            stepThree.goalObject = self.goalObject
        }
        else if let bankSetup = segue.destination as? BankSetupViewController {
            
            bankSetup.progress = helpers().progressBar(view: self, currentStep: 4, progressBar:self.progress, next: false)
            bankSetup.goalObject = self.goalObject
            
            
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}





extension goalsSetup3ViewController: FSCalendarDataSource, FSCalendarDelegate {
    func minimumDate(for calendar: FSCalendar) -> Date {
        print("MIN")
        let today = calendar.today!
        let todayString = stringFromDate(date: today as NSDate, format: self.formatter.dateFormat)
        return self.formatter.date(from: todayString)!
    }
    
    func maximumDate(for calendar: FSCalendar) -> Date {
        print("MAX")
        return self.formatter.date(from: "2019/01/31")!
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        //XYZ-STEPPER
        let curDate = Date()
        let currentCalendar = Calendar.current
        let start = currentCalendar.ordinality(of: .day, in: .era, for: curDate)
        let end = currentCalendar.ordinality(of: .day, in: .era, for: date)
        let weeksBetween = Double((end! - start!))/7.0
        
        if weeksBetween < 2 {
            
            print("edgeCaseReachedHERE1111")
            print("stopSelection")
            helpers().soraUserAlert(view: self, string: "")
            doneButton.isHidden = true
     
        } else {
            
            print("allowSelection")
            helpers().soraUserAlert(view: self, remove: true)
            //#RECIEVEDATES
            doneButton.isHidden = false
            //self.goalObject.goalEndDate = self.duration
            self.goalObject.goalEndDate = date as Date
            self.duration = stringFromDate(date: date as Date as NSDate, format: self.formatter.dateFormat)
            

        }
        //XYZ-STEPPER-END
        
        
        
//        let comparison = date.compare(calendar.today!)
//        print(comparison)

        
        if monthPosition == .previous || monthPosition == .next {
            calendar.setCurrentPage(date as Date, animated: true)
        }
    }
    
    // Update your frame
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calendar.frame = CGRect(x: 0, y: self.view.frame.maxY - self.calendar.frame.height, width: bounds.width, height: bounds.height)
    }
}









