//
//  detailGoalViewController.swift
//  Mung
//
//  Created by Chike Chiejine on 05/10/2016.
//  Copyright © 2016 Color & Space. All rights reserved.
//

import UIKit
import Parse



// XYZ - Add delegate protocol to class
class detailGoalViewController: UITableViewController, backFromViewDelegate {
    
    @IBOutlet weak var rightBarButton: UIBarButtonItem!
    @IBOutlet weak var goalImage: UIImageView!
    @IBOutlet weak var goalTitle: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    @IBOutlet weak var commentsAmount: UIButton!
    @IBOutlet weak var likesAmount: UIButton!
    
    // Cell one
    
    @IBOutlet weak var goalProgress: KDCircularProgress!
    @IBOutlet weak var goalTotalSaved: UILabel!
    @IBOutlet weak var goalTimeLeft: UILabel!
    @IBOutlet weak var goalPercComplete: UILabel!
    
    // Cell two
    
    @IBOutlet weak var goalTargetAmount: UILabel!
    
    //Cell Three
    
    @IBOutlet weak var goalLatestDeposit: UILabel!
    
    var goalObject : goalsClass?
    var otherSelectedUser = false
    
    @IBOutlet var summaryCell: [UITableViewCell]!
    
    let overlayGradient = CAGradientLayer()
    
    @IBAction func moreButton(_ sender: Any) {
        
        
        if  goalObject?.goalAuthorObject?.objectId == PFUser.current()?.objectId {
            
            showActionSheet()
            
        } else {
            
            self.performSegue(withIdentifier: "detailGoalSetup", sender: self)
            
        }
        
//        if PFUser.current() == nil {
//        
//            self.performSegue(withIdentifier: "detailGoalSetup", sender: self)
//            
//            
//        } else {
//            
//            showActionSheet()
//        }
    }
    
    func backFromAction(goalObject: goalsClass?) {
        
        print("Back from editing")
        self.goalObject = goalObject!
        setUpDetail(goalobject: goalObject)
    }
    
    func profileBackFromAction(user: UserClass?) {
        //Do nothing
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // Layout right bar button
        
        let rightBarButton = UIButton()
        //set image for button
        rightBarButton.setImage(UIImage(named: "add-icon.png"), for: UIControlState.normal)
        //add function for button
        rightBarButton.addTarget(self, action: #selector(moreButton(_:)), for: UIControlEvents.touchUpInside)
        //set frame
        rightBarButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let barButton = UIBarButtonItem(customView: rightBarButton)
        
        
        if  goalObject?.goalAuthorObject?.objectId != PFUser.current()?.objectId || PFUser.current() == nil{
            self.navigationItem.rightBarButtonItem = barButton
        }
        
        
  

        //Gradient Overlay
        
        helpers().addGradientLayer(element: goalImage, overlay: self.overlayGradient)
 
        // Table Footer
        
        helpers().tableFooter(sender: self.tableView)
        
        for cell in summaryCell {
            if cell.tag != 0 {
                cell.separatorInset = UIEdgeInsets.zero
                cell.layoutMargins = UIEdgeInsets.zero
                if self.otherSelectedUser == true {
                    if cell.tag != 1  {
                        cell.isHidden = true
                    }
                }
            }
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        setUpDetail(goalobject: self.goalObject)
    }
    

    func setUpDetail(goalobject: goalsClass? ) {
        if let imageprofile1 = goalobject?.goalImagePath {
            self.goalImage.af_setImage(withURL: URL(string: imageprofile1)!, placeholderImage: UIImage(named:"no-image-bg"), filter: nil,imageTransition: .crossDissolve(0.2), runImageTransitionIfCached: true, completion: nil)
        }
        
    
        self.amountLabel.text = "Goal Target"
        self.goalTitle.text = goalobject?.goalTitle
        self.navigationController?.navigationItem.title = goalobject?.goalTitle
   
        goalobject?.userGoalAllocation2(completion: { (error) in
            if error == nil {
                let formatter = NumberFormatter()
                formatter.minimumFractionDigits = 2
                if goalobject?.goalTotalSaved != nil {
                    let double = Double((goalobject?.goalTotalSaved!)!)
                    self.goalTotalSaved.text = formatter.string(from: double as NSNumber)
                }
                self.goalTimeLeft.text = goalobject?.goalTimeLeft
                if goalobject?.goalPercComplete != nil {
                    self.goalPercComplete.text = String(describing: (goalobject?.goalPercComplete!)!)
                }
            }
        })
        if otherSelectedUser != true {
            goalobject?.goalPaymentSchedule2(completion: { (error) in
                if error == nil {
                    let formatter = NumberFormatter()
                    formatter.minimumFractionDigits = 2
                    self.goalLatestDeposit.text = formatter.string(from: (goalobject?.lastPayment!)! as NSNumber)
                }
            })
        }
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 3  {
            //XYZ-STEPPER
            self.performSegue(withIdentifier: "detailGoal3", sender: self)
        }
        
        if indexPath.row == 4 {
            self.performSegue(withIdentifier: "historySegue", sender: self)
        }
    }

    

    @IBAction func likeButton(_ sender: UIButton) {
      likeTappedC(sender as! UIButton)
    }
    
    func likeTappedC(_ sender: UIButton) {
        sender.isEnabled = false
        goalObject?.toggleLike(completion: { liked, error in
            if error != nil {
                // Show error...
                // donY
            }
            if liked {
                let likedButton = UIImage(named: "filledHeart-icon.png")?.withRenderingMode(.alwaysTemplate)
                sender.tintColor = UIColor(red:0.90, green:0.04, blue:0.20, alpha:1)
                sender.setImage(likedButton, for: UIControlState.normal)
                
            } else {
                let likedButton = UIImage(named: "linedHeart-icon.png")
                sender.setImage(likedButton, for: UIControlState.normal)
            }
            sender.isEnabled = true
        })
    }
    
    
    @IBAction func likesAmountAction(_ sender: Any) {
        
        
    }
    
    @IBAction func commentsAmountAction(_ sender: Any) {
        
        self.performSegue(withIdentifier: "detailComments", sender: self)
        
    }
    
    
    @IBAction func commentButton(_ sender: UIButton) {
        self.performSegue(withIdentifier: "detailComments", sender: self)
    }
    

    @IBAction func shareGoal(_ sender: UIButton) {
        let indexRow = sender.tag
        let textToShare = "Swift is awesome!  Check out this website about it!"
        if let myWebsite = NSURL(string: "http://www.codingexplorer.com/")
        {
            let objectsToShare = [textToShare, myWebsite] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            self.present(activityVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func commentAction(_ sender: Any) {
        self.performSegue(withIdentifier: "detailComments", sender: self)
    }
    
    @IBAction func unwindToRootViewController(segue: UIStoryboardSegue) {
        print("Unwind to Root View Controller")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let comments = segue.destination as? commentsViewController {
            comments.goalObject = self.goalObject!
        }
        //XYZ-STEPPER
        // I inputed a fake goalTarget and weeklySaveAmount so editmode in goalsetup3 doesn't crash on me.
        if let changeTargetInGoal3 = segue.destination as? goalsSetup3ViewController {
            changeTargetInGoal3.editMode = true
            self.goalObject?.goalTarget = Double(800)
            changeTargetInGoal3.goalObject = self.goalObject!
            changeTargetInGoal3.weeklySaveAmount = Double(146.57)
        }
        
        if let historyView = segue.destination as? depositHistoryViewController {
            historyView.goalObject = self.goalObject!
        }
        if let goalsSetupController = segue.destination as? goalsSetup2ViewController {
            
            goalsSetupController.delegate = self
            goalsSetupController.editMode = true
            goalsSetupController.goalObject = self.goalObject!
            
        }
    }

}






extension detailGoalViewController: UIViewControllerTransitioningDelegate, UINavigationControllerDelegate {
    
    
    // show action sheet
    fileprivate func showActionSheet() {
        
        // create controller with style as ActionSheet
        let alertCtrl = UIAlertController()
        
        // create button action
        let editProfileAction = UIAlertAction(title: "Edit Goal Details", style: UIAlertActionStyle.default, handler: { (action) in
            
            self.performSegue(withIdentifier: "detailGoal2", sender: self)
            
        })
        
        let addGoalAction = UIAlertAction(title: "Start a New Goal", style: UIAlertActionStyle.default, handler: { (action) in
            
            self.performSegue(withIdentifier: "detailGoalSetup", sender: self)
            
        })
        
        func goBack(){
            dismiss(animated: true, completion: nil)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
        
        // add action to controller
        
        if  goalObject?.goalAuthorObject?.objectId == PFUser.current()?.objectId {
            alertCtrl.addAction(editProfileAction)
        }
        
        alertCtrl.addAction(addGoalAction)
        alertCtrl.addAction(cancelAction)
        
        // show action sheet
        self.present(alertCtrl, animated: true, completion: nil)
    }
}


