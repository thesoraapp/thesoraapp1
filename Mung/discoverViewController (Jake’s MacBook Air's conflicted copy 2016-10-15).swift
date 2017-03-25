//
//  discoverViewController.swift
//  Mung
//
//  Created by Chike Chiejine on 01/10/2016.
//  Copyright © 2016 Color & Space. All rights reserved.
//

import UIKit
import Parse
import Firebase
import FirebaseDatabase
import FirebaseAuth

class discoverViewController: UITableViewController {
    
    var dbRef:FIRDatabaseReference!
    //dbRef = FIRDatabase.database().reference()
    //dbRef = FIRDatabase.database().reference()
    
    
    
//    var goalImages = ["pic1.png", "pic2.png", "pic3.png", "pic4.jpg", "pic5.jpg"]
//    var goalTitles = ["Paris Summer Vacation", "Rose's College Fund", "Fashion Photography Equipment", "Summer 18 Gap Year Fund", "Pilot School" ]
//    var goalAuthorProfiles = ["pro1.jpg", "pro2.jpg", "pro3.jpg", "pro4.jpg", "pro5.jpg"]
//    var goalAuthorNames = ["Amani Roy", "Makenzie Crosby", "Jaslene Proctor", "Desmond Kramer", "Paige Richards"]
//    
 
    
    var goalImages = [UIImage]()
    var goalTitles = [String]()
    var goalAuthorProfiles = [UIImage]()
    var goalAuthorNames = [String]()

 
    var liked = false

    var didScroll = false
    


    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //dbRef = FIRDatabase.database().reference()

        for family: String in UIFont.familyNames
        {
            print("\(family)")
            for names: String in UIFont.fontNames(forFamilyName: family)
            {
                print("== \(names)")
            }
        }
        
        //print("hi3333")
        configureDatabaseforFirstLoad()
        
        
        //need to add IBAction
        updateGoalLikes(goalID: "chinatrip123")
        

    }
    
  /*
    func populateDummyData() {
        let dbRef = FIRDatabase.database().reference()
        
        
        
    }
    
   */
    
    func updateGoalLikes(goalID: String) {
        let dbRef = FIRDatabase.database().reference()
        
        //get current number of lies
        dbRef.child("goals").child(goalID).observeSingleEvent(of: .value, with: { (snapshot:FIRDataSnapshot) in
            let value = snapshot.value as? [String: AnyObject]
            var goalLikeCount = value?["goalLikeCount"] as! Int
        goalLikeCount += 1
            
        let childUpdates = ["/goals/\(goalID)/goalLikeCount": goalLikeCount]
        dbRef.updateChildValues(childUpdates)
        

        })
    }
    
    
    
    
    func prepareArraysforDiscover(enumerator: NSEnumerator) {
 
        let dbRef = FIRDatabase.database().reference()
        while let rest = enumerator.nextObject() as? FIRDataSnapshot {
            
            let lastKnownKeyDict =  rest.value as? [String: AnyObject]
            let goalUser = lastKnownKeyDict?["goalAuthor"] as? String
            print(goalUser)
            print("goaluser")
            goalAuthorNames.append(goalUser!)
            
            let goalTitle = lastKnownKeyDict?["goalName"] as? String
            goalTitles.append(goalTitle!)
    
            let goalImageKey = lastKnownKeyDict?["goalImage"] as? [String: AnyObject]
            let goalImageUrl = goalImageKey?["goalImage1"] as? String
            
            let goalImageUrl2 = URL(fileURLWithPath: goalImageUrl!)
            let imageData = UIImage()
            var request = URLRequest(url: goalImageUrl2)
            request.httpMethod = "GET"
            
            print("request")
            print(request)
            
            URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
//                print("datajake")
//                print(data!)
                let imageData = UIImage(data: data!)
                
                print("imageData1")
                print(imageData)
                self.goalImages.append(imageData!)
            }).resume()
            
            print("goalImages")
            print(goalImages)
            
            dbRef.child("users").child(goalUser!).observe(.value, with: { (snapshot:FIRDataSnapshot) in
                let value = snapshot.value as? [String: AnyObject]
                let userImageUrl = value?["userImage"] as? String
                let userImageUrl2 = URL(fileURLWithPath: userImageUrl!)
                let imageData = UIImage()
                var request = URLRequest(url: userImageUrl2)
                request.httpMethod = "POST"
                URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                    let imageData = UIImage(data: data!)
                    self.goalAuthorProfiles.append(imageData!)
                    })
            })
        }
        self.tableView.reloadData()
    }

    
    func getNextTenDiscoverGoals(lastKnownKeyDict: Double) {
        let dbRef = FIRDatabase.database().reference()
        dbRef.child("goals").queryOrdered(byChild: "goalLikeCount").queryStarting(atValue: lastKnownKeyDict).queryLimited(toLast: 10).observe(.value, with: { (snapshot:FIRDataSnapshot) in
            let enumerator = snapshot.children
            self.prepareArraysforDiscover(enumerator: enumerator)
        })
    }
    
    func configureDatabaseforFirstLoad() {
        let dbRef = FIRDatabase.database().reference()
        // start by fetching first 10 most liked goals and fetch another 10 for each scroll down
        dbRef.child("goals").queryOrdered(byChild: "goalLikeCount").queryLimited(toLast: 10).observeSingleEvent(of: .value, with: { (snapshot:FIRDataSnapshot) in
        let enumerator = snapshot.children
            
        self.prepareArraysforDiscover(enumerator: enumerator)
            
            //gets reference point for next 10 goals
            while let rest = enumerator.nextObject() as? FIRDataSnapshot {
                let lastKnownKeyDict =  rest.value as? [String: AnyObject]
                let lastKnownKey = lastKnownKeyDict?["goalLikeCount"] as? Double
            }
//                print("START PRINT")
//                print(self.goalTitles)
//                print(self.goalAuthorNames)
//                print(self.goalAuthorProfiles)
//            
//            print(self.goalImages)
//
                
                
            
        })

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
        return self.goalTitles.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        //Get Cell and Index
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "goal", for: indexPath) as! goalViewCell
        let indexRow = (indexPath as NSIndexPath).row
        
        //Measurements

        let width = self.tableView.frame.width
        let height = cell.frame.height
        
        //Gradient Overlay
        
        cell.overlayGradient.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        cell.overlayGradient.locations = [0.0, 0.9]
        cell.overlayGradient.frame = CGRect(x: 0, y: 0, width: width, height: 300)
        cell.goalImage.layer.insertSublayer(cell.overlayGradient, at: 0)
        
        //Configure outlets
        
        //print(goalImages)
        //print(goalTitles)
        
        cell.goalAuthorName.setTitle(goalAuthorNames[indexRow], for: .normal)
//        cell.goalAuthorProfile.setImage(UIImage(named: goalAuthorProfiles[indexRow]), for: .normal) 
        cell.goalTitle.text = goalTitles[indexRow]
        cell.goalImage.image = goalImages[indexRow]
        
        // Set button targets
        
        cell.likeGoal.addTarget(self, action:#selector(likeButton), for: UIControlEvents.touchUpInside)
        cell.goalAuthorName.addTarget(self, action:#selector(authorProfile), for: UIControlEvents.touchUpInside)
        cell.goalAuthorProfile.addTarget(self, action:#selector(authorProfile), for: UIControlEvents.touchUpInside)
        cell.shareGoal.addTarget(self, action:#selector(shareGoal), for: UIControlEvents.touchUpInside)
        
        // Set Up button tags
        
        cell.goalAuthorName.tag = indexRow
        cell.goalAuthorProfile.tag = indexRow
        cell.shareGoal.tag = indexRow
        
        
        
        return cell


    }
    
    
    
    //Like button target function 
    
    
    func likeButton(sender: UIButton){
        
     
        // Get index from sender
        
        let indexRow = sender.tag
        
        
        // Liked Status
        
        if liked == true {
            
            //  Current user is unliking
            
            liked = false
            
            //Set up normal button state
            
            let likedButton = UIImage(named: "linedHeart-icon.png")
            sender.setImage(likedButton, for: UIControlState.normal)
            
            
        } else {
            
            //  Current user is liking
            
            liked = true
            
            //Set up liked button state
            
            let likedButton = UIImage(named: "filledHeart-icon.png")?.withRenderingMode(.alwaysTemplate)
            sender.tintColor = UIColor(red:0.90, green:0.04, blue:0.20, alpha:1)
            sender.setImage(likedButton, for: UIControlState.normal)
            
            
        }
        
        
    }
    
    //Author profile target function
    
    
    func authorProfile(sender: UIButton){
        
        // Get index from sender
        
        let indexRow = sender.tag
    }
    
    // Share goal target function
    
    
    func shareGoal(sender: UIButton){
        
        // Get index from sender
        
        let indexRow = sender.tag
        

        let textToShare = "Swift is awesome!  Check out this website about it!"
        if let myWebsite = NSURL(string: "http://www.codingexplorer.com/")
        {
            let objectsToShare = [textToShare, myWebsite] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            //            //New Excluded Activities Code
            //            activityVC.excludedActivityTypes = [UIActivityTypeAirDrop, UIActivityTypeAddToReadingList]
            //            //
            
            self.present(activityVC, animated: true, completion: nil)
        
        }
        
        
    }
    
    
    
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

    
        print("I SELECTED!!!!!!!")
        
//    let vC = self.storyboard?.instantiateViewControllerWithIdentifier("userProfile") as!  userProfileTableViewController
//    
//    
//    
//    vC.selectedUserName = self.usernames[indexPath.row]
//    //vC.selectedUser = self.users[indexPath.row]
//    vC.isFollowing = self.isFollowing
//    vC.wishBoneCounter  =  self.otherUserWishBoneCounter
//    vC.userProfiles = self.userProfiles
//    
//    
//    self.navigationController?.pushViewController(vC, animated: true)
    
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







