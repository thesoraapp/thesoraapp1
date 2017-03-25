//
//  userListViewController.swift
//  Mung
//
//  Created by Chike Chiejine on 14/10/2016.
//  Copyright © 2016 Color & Space. All rights reserved.
//

import UIKit

class userListViewController: UITableViewController {
    
    var viewTitle = String()
    
    var goalAuthorProfiles = ["pro1.jpg", "pro3.jpg", "pro4.jpg"]
    var goalAuthorNames = ["Amani Roy", "Jaslene Proctor", "Desmond Kramer"]


    override func viewDidLoad() {
        super.viewDidLoad()

     
        self.navigationController?.navigationItem.title = viewTitle
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 300
        tableView.tableFooterView = UIView()
        
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
        return goalAuthorProfiles.count
    }

   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            
            let inviteCell = tableView.dequeueReusableCell(withIdentifier: "inviteUser", for: indexPath) as! inviteUserViewCell
            // CONFIG Button
            
            
            // Configure the cell...
            
            return inviteCell
            
        } else {
            
            let userCell = tableView.dequeueReusableCell(withIdentifier: "user", for: indexPath) as! userViewCell
            
            userCell.userName.text = goalAuthorNames[indexPath.row]
            userCell.userProfile.image = UIImage(named: goalAuthorProfiles[indexPath.row])
            userCell.followButton.addTarget(self, action: #selector(followUser), for: .touchUpInside)
            
            
            return userCell
            
        }
        

    }
    
    
    // Follow/ Unfollow user action
    
    func followUser(sender: UIButton){
        
        
        
        
        
    }
    
    
    
    
    
    

//    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        return UITableViewAutomaticDimension
//    }
//    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
