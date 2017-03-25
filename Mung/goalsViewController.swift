//
//  goalsViewController.swift
//  Mung
//
//  Created by Chike Chiejine on 02/10/2016.
//  Copyright © 2016 Color & Space. All rights reserved.
//

import UIKit
import Parse


class goalsViewController: UITableViewController {
    
    @IBOutlet var addGoalBarButton: UIBarButtonItem!
    
    @IBAction func addGoalBarButton(_ sender: Any) {
        
        let vC = self.storyboard?.instantiateViewController(withIdentifier: "step1") as! goalsSetupViewController
        self.navigationController?.show(vC, sender: self)

    }
    
    // Data
    
    var goalImageURLs = [String]()
    var goalTitles = [String]()
    var goalTotalSaved = [Float]()
    var goalCurAlloc = [Int]()
    var goalRemainAmount = [Double]()
    var goalCurTimeLeft = [Double]()
    var goalPrettyTimeLeft = [String]()
    var goalEndDate = [Date] ()
    var goalCurDepositRate = [Int]()
    var goalPercComplete = [Double]()
    var prevGoal: PFObject?
    
    private var animationProgress: UInt8 = 0
    
    
    func closeButton(){
    
    
        navigationController?.setNavigationBarHidden(false, animated:true)
        var myBackButton:UIButton = UIButton(type: UIButtonType.custom)
        myBackButton.addTarget(self, action:#selector(dismissView), for: UIControlEvents.touchUpInside)
        myBackButton.setTitle("", for: UIControlState.normal)
        let image = UIImage(named: "add-icon.png")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        myBackButton.setImage(image, for: UIControlState.normal)
        myBackButton.setTitleColor(UIColor(red:0.54, green:0.54, blue:0.54, alpha:1.0), for: UIControlState.normal)
        myBackButton.sizeToFit()
        var myCustomBackButtonItem:UIBarButtonItem = UIBarButtonItem(customView: myBackButton)
        self.navigationItem.rightBarButtonItem  = myCustomBackButtonItem
    
    
    }

    
    func dismissView() {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    func  configureTableView() {
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 235

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        print("VIEWDIDAPPEAR")
        
         self.navigationController?.navigationBar.barTintColor = .white
        
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
 
        getUserGoalAlloc()
        
        tableView.tableFooterView = UIView()

        configureTableView()
        

    }
    
    func getUserGoals() {
        let userGoals = PFQuery(className: "goals")
        userGoals.whereKey("goalAuthor", equalTo: PFUser.current()!)
        userGoals.findObjectsInBackground { (goalObjects, error) in
            
            print("GOALS QUERY")
        
            if goalObjects != nil {
                
                print("GOALS QUERY SUCCESS")
                
                for goal_ in goalObjects! {
                    self.goalImageURLs.append(goal_["goalImagePath"] as! String)
                    self.goalTitles.append(goal_["goalTitle"] as! String)
                    
                }
            }
        }
    }
    
    func getUserGoalAlloc() {
        let userGoalAlloc = PFQuery(className:"userGoalAllocations")
        userGoalAlloc.whereKey("userName", equalTo: PFUser.current()!)
        userGoalAlloc.includeKey("userGoalID")
        userGoalAlloc.addDescendingOrder("createdAt")
        userGoalAlloc.findObjectsInBackground { (userGoalAllocs, error) in
            
            self.goalImageURLs.removeAll(keepingCapacity: true)
            self.goalTitles.removeAll(keepingCapacity: true)
            self.goalTotalSaved.removeAll(keepingCapacity: true)
            self.goalCurAlloc.removeAll(keepingCapacity: true)
            self.goalCurTimeLeft.removeAll(keepingCapacity: true)
            self.goalCurDepositRate.removeAll(keepingCapacity: true)
            
            if userGoalAllocs != nil {
                
                var goalTargetAmount = Double()
                var goalCurEndDate = Date()
                goalTargetAmount = 0.0
                
                if let userAllocs = userGoalAllocs! as? [PFObject] {
                    for goalAlloc_ in userAllocs {
                        if ((goalAlloc_["userGoalID"] as! PFObject) != self.prevGoal) {
                            self.goalTotalSaved.append(goalAlloc_["userGoalTotalSaved"] as! Float)
                            self.goalCurDepositRate.append(goalAlloc_["userGoalAllocDesignatedRate"] as! Int)
                            self.goalTotalSaved.append(goalAlloc_["userGoalTotalSaved"] as! Float)
                            
                            if let goals = goalAlloc_["userGoalID"] as? PFObject {
                                self.goalImageURLs.append(goals["goalImagePath"] as! String)
                                self.goalTitles.append(goals["goalTitle"] as! String)
                                goalTargetAmount = goals["goalTarget"] as! Double
                                goalCurEndDate = goals["goalEndDate"] as! Date
                            }
                            
                            self.goalEndDate.append(goalCurEndDate)
                            
                            let goalAmountRemain = goalTargetAmount - (goalAlloc_["userGoalTotalSaved"] as! Double)
                            
                            self.goalRemainAmount.append(goalAmountRemain)
                            
                            
                            
                            let goalpercComplete_ = (1 - (goalAmountRemain/goalTargetAmount)) * 100
                            self.goalPercComplete.append(goalpercComplete_)
                            
                            
                            //MHPrettyDate only works for dates in past
                            //let prettyDate = MHPrettyDate.prettyDate(from: goalCurEndDate, with: MHPrettyDateLongRelativeTime)
                            
                            let curDate = Date()
                            let hoursRemain = goalCurEndDate.hours(from: curDate)
                            let daysRemain = goalCurEndDate.days(from: curDate)
                            let weeksRemain = goalCurEndDate.weeks(from: curDate)
                            let monthsRemain = goalCurEndDate.months(from: curDate)
                            let yearsRemain = goalCurEndDate.years(from:curDate)
                            
                            
                            if hoursRemain == 0 {
                                print("Goal reached today")
                                self.goalPrettyTimeLeft.append("GOAL REACHED TODAY!")
                            }
                            if daysRemain == 0 {
                                print("Goal reached today")
                                self.goalPrettyTimeLeft.append("GOAL REACHED TODAY!")
                            }
                            if (daysRemain > 0) && (weeksRemain == 0) {
                                print("Goal reached this week")
                                self.goalPrettyTimeLeft.append("\(daysRemain) DAYS")
                            }
                            if (weeksRemain > 0) && (monthsRemain == 0) {
                                print("Goal reached this week")
                                self.goalPrettyTimeLeft.append("\(weeksRemain) WEEKS")
                            }
                            if (monthsRemain > 0) && (monthsRemain < 4) {
                                print("Goal reached this week")
                                self.goalPrettyTimeLeft.append("\(monthsRemain) MONTHS AND \(weeksRemain) WEEKS")
                            }
                            if (monthsRemain > 4) && (yearsRemain == 0) {
                                print("Goal reached this week")
                                self.goalPrettyTimeLeft.append("\(monthsRemain) MONTHS")
                            }
                            if yearsRemain > 1 {
                                print("Goal reached this week")
                                self.goalPrettyTimeLeft.append("\(yearsRemain) YEARS AND \(monthsRemain) MONTHS")
                            }
                        }
                        self.prevGoal = goalAlloc_["userGoalID"] as! PFObject
                    }
                }
            }
            self.tableView.reloadData()
        }
    }

    

    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        

        return goalTitles.count
            
        
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

            let cell = tableView.dequeueReusableCell(withIdentifier: "goalAlloc", for: indexPath) as! goalAllocViewCell
            let indexRow = indexPath.row
        
        
        cell.goalTitle.text = goalTitles[indexRow]
        
        let makeDoubleInt = Int(self.goalRemainAmount[indexRow])
        cell.goalCurrentAmount.text = String(makeDoubleInt)
        cell.goalCurrentAmount.sizeToFit()
        
        
        let dateToGo = self.goalPrettyTimeLeft[indexRow]
        let datetoGoString = "\(dateToGo) TO GO"
        cell.goalTimeLeft.text = datetoGoString
    
        let percNum = self.goalPercComplete[indexRow]
        let percAngle = (percNum / 100) * 360
        let perNumConvertInt = Int(percNum)
        let percString = String(perNumConvertInt)
//        cell.goalCompletionPercentage.text = "\(percString)%"
        
        
        cell.goalProgress.animate(fromAngle: 0, toAngle: percAngle, duration: 2, completion: nil)
    
            //Measurements
            
            let width = self.tableView.frame.width
            let height = cell.frame.height
        
            //Gradient Overlay
            
            cell.overlayGradient.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
            cell.overlayGradient.locations = [0.0, 0.9]
            cell.overlayGradient.frame = CGRect(x: 0, y: 0, width: width, height: 300)
            cell.goalImage.layer.insertSublayer(cell.overlayGradient, at: 0)
        
        
        
        
            let imageprofile1 = URL(string: self.goalImageURLs[indexRow] as! String)
        
            print(imageprofile1)
        
            URLSession.shared.dataTask(with: imageprofile1!, completionHandler: { (data, response, error) in
                if error != nil {
                    
                    print(error)
                    
                } else {
//                    
//                    "IMAGESUCCESS"
                    
                    DispatchQueue.main.async {
                        cell.goalImage.image = UIImage(data: data!)
                    }
                }

                
            }).resume()

        

            
            
            return cell

        
    }
    


    

}
