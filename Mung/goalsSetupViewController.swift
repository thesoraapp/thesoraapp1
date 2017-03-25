//
//  goalsSetupViewController.swift
//  Mung
//
//  Created by Chike Chiejine on 01/11/2016.
//  Copyright © 2016 Color & Space. All rights reserved.
//

import UIKit
import Parse

// UIColor(red:0.76, green:0.76, blue:0.76, alpha:1.0) - Next button grey

class goalsSetupViewController: UITableViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIViewControllerTransitioningDelegate {
    
    
    var goalObject = goalsClass(goal: nil)
    var progress = UIView()

    
    @IBOutlet private weak var categoryCollectionView: UICollectionView!
    
    @IBAction func cancelButton(_ sender: Any) {
        
        print("shouldDismiss")
        self.navigationController?.dismiss(animated: true, completion: nil)
        progress.removeFromSuperview()
        
        

    }
    
    @objc func notificationCancelAuth(notification: Notification) {
        if let userInfo = notification.userInfo, let status = userInfo["status"] as? Bool, let didCancel = userInfo["cameFromInvest"] as? Bool {
            if didCancel == true {
                print("WEPRINTEDDIDCANCEL")
                self.navigationController?.presentingViewController?.dismiss(animated: true, completion: nil)
            }
        } else {
            print("notification, no user info")
        }
    }
    
    var categoryName = ["Travel",
                        "Start-up",
                        "Fashion",
                        "Money",
                        "Hobbies"]
    
    var categoryImage = ["travel-icon",
                         "startup-icon",
                         "fashion-icon",
                         "money-icon",
                         "other-icon"]
    
    var selected = false
    let nextButton = UIButton()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let progress = helpers().progressBar(view: self, currentStep: 1, progressBar: self.progress, next: true)
        UIApplication.shared.windows[0].addSubview(progress)
        self.categoryCollectionView.allowsMultipleSelection = false
        self.tableView.tableFooterView = UIView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(notificationCancelAuth(notification:)), name: Notification.Name(rawValue: "authDismissToggled"), object: nil)
        
        if PFUser.current() == nil {
            let vC = self.storyboard?.instantiateViewController(withIdentifier: "userAuth") as! userAuthViewController
            vC.modalPresentationStyle = UIModalPresentationStyle.custom
            vC.transitioningDelegate = self
            vC.statusBarShouldBeHidden = true
            vC.cameFromInvest = true
            let vcRoot = UINavigationController(rootViewController: vC)
            self.present(vcRoot, animated: true, completion: nil)
        }

        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
        return categoryName.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        collectionView.allowsMultipleSelection = false
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath) as! goalCategoryViewCell
        cell.categoryName.text = self.categoryName[indexPath.item].uppercased()
        cell.categoryImage.image = UIImage(named: self.categoryImage[indexPath.item])
        
        
        if  goalObject.goalCategory != nil {
            if goalObject.goalCategory! as! String == self.categoryName[indexPath.item] {
                
                categoryCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: .top)
                
            } else {
                cell.isselected = false
                cell.greenTick.isHidden = true
                
            }
            
        } else {
            
            cell.isselected = false
            cell.greenTick.isHidden = true
            
            
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        collectionView.allowsMultipleSelection = false
        let cell = collectionView.cellForItem(at: indexPath)  as! goalCategoryViewCell
        
        
        
        
        //If category is not yet selected do....
        cell.greenTick.isHidden = false
        self.goalObject.goalCategory = self.categoryName[indexPath.item]
        cell.isselected = true
        
        //        self.performSegue(withIdentifier: "stepTwo", sender: self)
        
    }
    
    

    @IBAction func unwindToRootViewController(segue: UIStoryboardSegue) {
        print("Unwind to Root View Controller")
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        collectionView.allowsMultipleSelection = false
        let cell = collectionView.cellForItem(at: indexPath)  as! goalCategoryViewCell
        //If category is not yet selected do....
        cell.greenTick.isHidden = true
        self.goalObject.goalCategory = ""
        cell.isselected = false
        
        
    }
    
    
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let setup2 = segue.destination as? goalsSetup2ViewController {
            
            setup2.progress = helpers().progressBar(view: self, currentStep: 2, progressBar: self.progress, next: true)
            setup2.goalObject = self.goalObject
            
        }
   
    }
    
    
    
    
    
    
    
}
