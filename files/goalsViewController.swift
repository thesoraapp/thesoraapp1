//
//  goalsViewController.swift
//  Mung
//
//  Created by Chike Chiejine on 02/10/2016.
//  Copyright © 2016 Color & Space. All rights reserved.
//

import UIKit

class goalsViewController: UITableViewController {
    
    @IBOutlet var addGoalBarButton: UIBarButtonItem!

    
    // Data
    
    var goalImages = ["pic1.png", "pic2.png"]
    var goalTitles = ["Hey","Huh"]
    
    
    
    
    func configureTableView() {
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 235
    }

    
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        tableView.tableFooterView = UIView(frame: CGRect.zero)

        configureTableView()
        

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
        
        if goalTitles.count == 0 {
            
            return 1
            
        } else {
        
        
        return goalTitles.count
            
            
        }
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        let indexRow = (indexPath as NSIndexPath).row

        if goalTitles.count == 0 {
            
            self.tableView.isScrollEnabled = false
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "getStarted", for: indexPath) as! noGoalsViewCell
            
            //            cell.getStartedButton.hidden = true
            cell.getStartedMessage.text = "You don’t have any investments yet."
            
            return cell
            

            
        } else {
        
            //Get Cell and Index
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "getStarted", for: indexPath) as! noGoalsViewCell
            let indexRow = (indexPath as NSIndexPath).row
//
//            //Measurements
//            
//            let width = self.tableView.frame.width
//            let height = cell.frame.height
//            
//            //Gradient Overlay
//            
//            cell.overlayGradient.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
//            cell.overlayGradient.locations = [0.0, 0.9]
//            cell.overlayGradient.frame = CGRect(x: 0, y: 0, width: width, height: 300)
//            cell.goalImage.layer.insertSublayer(cell.overlayGradient, at: 0)
//            
//            //Configure outlets
//            
//            cell.goalAuthorName.setTitle(goalAuthorNames[indexRow], for: .normal)
//            cell.goalAuthorProfile.setImage(UIImage(named: goalAuthorProfiles[indexRow]), for: .normal)
//            cell.goalTitle.text = goalTitles[indexRow]
//            cell.goalImage.image = UIImage(named: goalImages[indexRow])
//            
//            // Set button targets
//            
//            cell.likeGoal.addTarget(self, action:#selector(likeButton), for: UIControlEvents.touchUpInside)
//            cell.goalAuthorName.addTarget(self, action:#selector(authorProfile), for: UIControlEvents.touchUpInside)
//            cell.goalAuthorProfile.addTarget(self, action:#selector(authorProfile), for: UIControlEvents.touchUpInside)
//            cell.shareGoal.addTarget(self, action:#selector(shareGoal), for: UIControlEvents.touchUpInside)
//            
//            // Set Up button tags
//            
//            cell.goalAuthorName.tag = indexRow
//            cell.goalAuthorProfile.tag = indexRow
//            cell.shareGoal.tag = indexRow
            
            
//            
            return cell

 
            
        }
       
        

        
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
