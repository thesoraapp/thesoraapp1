//
//  commentsViewController.swift
//  Coined
//
//  Created by Chike Chiejine on 03/02/2016.
//  Copyright © 2016 Color & Space. All rights reserved.
//

import UIKit
import Parse
import MHPrettyDate
import Alamofire
import AlamofireImage

class commentsViewController: UIViewController, UITableViewDelegate, UITextViewDelegate, UIViewControllerTransitioningDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    
    var commentTextField: UITextView?
    var newCommentView: UIView?
    var author = PFUser.current()
    //var selectedGoal : PFObject?
    var goalObject = goalsClass(goal: nil)
    
    
    var indexRow = Int()
    
    let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }()
    
    var commentAuthorName = ["Jared Davidson", "Marlon Brando", "Che Guevara"]
    var commentAuthorImages = ["pro1", "pro2", "pro3"]
    var commentAuthor = [PFUser]()
    var commentDate = [Date]()
    var comment = [""]
    
    var maxHeight: CGFloat?
    var submitCommentButton: UIButton = UIButton()
    var keyboardYorigin: CGFloat?
    
    var indicator = UIActivityIndicatorView()
    
    var newCommentObject = ["user": PFUser.current(), "commentAuthor": PFUser(), "commentDate": Date(), "comment": String()] as [String : Any]
    
    
    @IBAction func goBack(_ sender: AnyObject) {
        
        if let navigationController = self.navigationController
        {
            navigationController.popViewController(animated: true)
        }
        
        print("GO BACK")
        
    }
    
    
    
    // Grab comments from Parse
    
    
    func grabComments(){
        
        
        let commentsQuery = PFQuery(className: "comments")
        commentsQuery.whereKey("Goal", equalTo: self.goalObject.goalObj)
        commentsQuery.addAscendingOrder("createdAt")
        commentsQuery.includeKey("author")
        commentsQuery.findObjectsInBackground { (objects, error) -> Void in
            
            if error == nil {
                
                self.commentAuthor.removeAll(keepingCapacity: true)
                self.commentDate.removeAll(keepingCapacity: true)
                self.comment.removeAll(keepingCapacity: true)
                
                
                if let comments  = objects {
                    
                    
                    for comment in comments {
                        
                        if let comment = comment["comment"] as? String {
                            
                            self.comment.append(comment)
                            
                        }
                        
                        if let author = comment["author"] as? PFUser {
                            
                            self.commentAuthor.append(author)
                            
                        }
                        
                        
                        self.commentDate.append(comment.createdAt!)
                        
                        
                    } //For loop
                    
                    
                } // IF let comments
                
                print("COMMMENT DETAILS")
                print(self.commentAuthor)
                print(self.comment)
                print(self.commentDate)
                helpers().startActivityIndicator(sender: self, object: self.view, activityIndicator: self.indicator, position: "top", start: false)
                self.tableView.reloadData()
                
                //                if self.commentAuthor.count != nil {
                //
                //                    self.tableView.reloadData()
                //
                //
                //                    if let lastIndex = IndexPath(row: self.comment.count - 1, section: 0) as? IndexPath{
                //
                //                    self.tableView.scrollToRow(at: lastIndex, at: UITableViewScrollPosition.bottom, animated: false)
                //
                //
                //                    }
                //
                //                }
                
                
                
            } // CHECK SUCCESS
            
            
            
            
            
            
        } //END QUERY
        
        
        
        
    }
    
    
    
    
    func configureTableView() {
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 260
    }
    
    
    
    
    //    func scrollDown(){
    //
    //
    //        let lastIndex = NSIndexPath(forRow: self.comment.count - 1, inSection: 0)
    //        self.tableView.scrollToRowAtIndexPath(lastIndex, atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
    //
    //    }
    
    
    func goBack() {
        
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        helpers().startActivityIndicator(sender:self, object: self.view, activityIndicator:indicator, position: "top", start: true)
        
        //print(self.selectedGoal)
        
        //
        //        let date1 = dateFromString(date: "2017/01/01", format: self.formatter.dateFormat)
        //        let date2 = dateFromString(date: "2017/01/02", format: self.formatter.dateFormat)
        //        let date3 = dateFromString(date: "2017/01/03", format: self.formatter.dateFormat)
        //
        //        commentDate = [date1, date2, date3]
        
        
        //        let comment1 = "Love the graded readers. Have really helped my reading."
        //        let comment2 = "I have written a review for the first volume, it applies to the 2nd volume as well. You won't regret. It's a lot of listening. I started vol. 2 recently. Enjoying the first long story. It's hours long! (mp3)"
        //        let comment3 = "Excellent book! Looking forward to buying the 2000 word reader."
        //
        //        comment = [comment1, comment2, comment3]
        
        
        var backButtonImage = UIImage(named: "arrow-icon")
        let newBackButton = UIBarButtonItem(image: backButtonImage, style: UIBarButtonItemStyle.plain, target: self, action: "goBack" )
        self.navigationItem.leftBarButtonItem = newBackButton
        
        
        configureTableView()
        //self.comment = self.commentTextField!.text
        
        // Set up keyboard notifications
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(commentsViewController.keyboardWillBeHidden(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(commentsViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        
        
        self.tableView.tableFooterView = UIView()
        
        
        
        let centerPosition = self.view.center
        let widthMeasure = self.view.frame.width
        let bottomOfView = self.view.frame.height - 170        // 58 50
        
        self.newCommentView = UIView(frame: CGRect(x: 0, y: bottomOfView, width: widthMeasure, height: 50))
        self.commentTextField = UITextView(frame:CGRect(x: 10, y: 10, width: widthMeasure - 90, height: 30))
        self.submitCommentButton = UIButton(frame: CGRect(x: widthMeasure - 70, y: 10, width: 60, height: 30))
        
        
        
        self.commentTextField!.backgroundColor = UIColor.white
        self.commentTextField!.textColor = UIColor.gray
        self.commentTextField!.text = ""
        self.commentTextField!.font = UIFont(name: "Helvetica Neue", size: 14)
        self.commentTextField!.layer.cornerRadius = 3
        self.commentTextField!.textColor = UIColor.lightGray
        self.commentTextField!.tag = 2
        self.commentTextField!.isScrollEnabled = true
        self.commentTextField!.keyboardType = .twitter
        
        
        self.submitCommentButton.setTitle("Post", for: UIControlState())
        
        self.submitCommentButton.isEnabled = false
        
        //
        //        self.submitCommentButton.backgroundColor = UIColor(red:0.01, green:0.68, blue:0.88, alpha:1.0) /* #056581 Blue*/
        
        
        self.submitCommentButton.backgroundColor = UIColor(red:0.79, green:0.80, blue:0.80, alpha:1.0)
        
        
        
        
        self.submitCommentButton.titleLabel!.font = UIFont(name: "MuseoSansRounded-700", size: 14)
        self.submitCommentButton.layer.cornerRadius = 3
        
        
        self.newCommentView!.backgroundColor = UIColor.white
        self.newCommentView!.layer.borderWidth = 1
        self.newCommentView!.layer.borderColor = UIColor(red:0.91, green:0.91, blue:0.91, alpha:1.0).cgColor
        self.newCommentView!.addSubview(submitCommentButton)
        self.newCommentView!.addSubview(self.commentTextField!)
        self.view.addSubview(newCommentView!)
        self.commentTextField!.delegate = self
        self.commentTextField?.autocorrectionType = .no
        
        
        tableView.keyboardDismissMode = .onDrag
        
        
        
        self.submitCommentButton.addTarget(self, action: #selector(commentsViewController.postAComment), for: UIControlEvents.touchUpInside)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        grabComments()
        
    }
    
    
    
    func lowerKeyboard(){
        
        
        
        print("SWIPE DOWN")
        
        
        
    }
    
    
    
    
    
    override func viewDidLayoutSubviews() {
        
        
        
        self.maxHeight = self.commentTextField!.font!.lineHeight * 6
        
        self.commentTextField!.sizeThatFits(CGSize(width: self.commentTextField!.frame.size.width, height: self.maxHeight!))
        
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        
    }
    
    
    func numberOfSectionsInTableView(_ tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        //        return self.commentAuthorName.count
        
        return self.commentAuthor.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as! commentCell
        
        // Get User profile image
        
        let author = self.commentAuthor[indexPath.row]
        
        if let imageprofile1 = URL(string: author["userImagePath"] as! String) {
            
            cell.userProfile.af_setImage(for: UIControlState.normal, url: imageprofile1, placeholderImage: UIImage(named: "user-placeholder"), filter: nil, completion: nil)
            
        }
        
        cell.userProfile.addTarget(self, action:#selector(authorProfile), for: UIControlEvents.touchUpInside)
        
        // Get comment authors username DONE!!!
        
        cell.userName.text = self.commentAuthor[indexPath.row].username
        
        
        // Get comment date
        
        let date = self.commentDate[indexPath.row]
        let prettyDate = MHPrettyDate.prettyDate(from: date, with: MHPrettyDateShortRelativeTime)
        cell.commentDate.text = prettyDate
        
        
        // Get comment
        
        cell.userComment.text = self.comment[indexPath.row] as String
        
        return cell
        
        
    }
    
    
    
    func authorProfile(sender: UIButton){
        
        // Get index from sender
        
        let indexRow = sender.tag
        
        // Stop activity indicator whilst user is being signed up
        let vC = self.storyboard?.instantiateViewController(withIdentifier: "profileView") as! meViewController
        
        vC.selectedUser = self.commentAuthor[indexRow]
        
        if self.commentAuthor[indexRow] != PFUser.current() {
            vC.otherSelectedUser = true
        }
        self.show(vC, sender: self)
        
        
    }
    
    
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        
        //        if textView.tag == 2 {
        //
        //            textView.text = ""
        //            textView.textColor = UIColor.grayColor()
        //        }
        
        
        let newY = self.view.frame.height - (keyboardHeight + textView.contentSize.height - 40)
        
        if let heightElevation = self.view.frame.height - keyboardHeight as? CGFloat {
            
            print("EDITINGBEGIN")
            
            UIView.animate(withDuration: 0.1, animations: { () -> Void in
                self.newCommentView!.frame.origin.y = newY
                
            })
            
            
            //                        if (self.commentTextField?.contentSize.height)!  > 33 {
            //                            print("HERETHIS")
            //
            //                            self.newCommentView?.frame.size = CGSize(width: newCommentViewWidth!, height: newCommentViewHeight! + 20)
            //                            self.newCommentView?.frame.origin.y =  newYPos
            //
            //                        }
            
            
        }
        
        
        
        if textView.text == "" {
            
            self.submitCommentButton.isEnabled = false
            
            self.submitCommentButton.backgroundColor = UIColor(red:0.79, green:0.80, blue:0.80, alpha:1.0)
            
        } else {
            
            
            self.submitCommentButton.isEnabled = true
            
            self.submitCommentButton.backgroundColor = UIColor(red:0.01, green:0.68, blue:0.88, alpha:1.0) /* #056581 Blue*/
            
        }
        
        
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if textView.text.isEmpty {
            
            textView.textColor = UIColor.lightGray
        }
        
        
        
    }
    
    var previousRect:CGRect = CGRect.zero
    var contentSize: CGFloat = 0
    
    
    
    func textViewDidChange(_ textView: UITextView) {
        
        if textView.text.isEmpty {
            textView.text = ""
            textView.textColor = UIColor.lightGray
        }
        
        print(self.commentTextField!.font!.lineHeight * 1)
        print(self.commentTextField!.font!.lineHeight)
        print(textView.font?.lineHeight)
        
        if textView.text == "" {
            
            print("NOTHING")
            
            self.submitCommentButton.isEnabled = false
            
            self.submitCommentButton.backgroundColor = UIColor(red:0.79, green:0.80, blue:0.80, alpha:1.0)
            
            
            
        }
        
        
        
        
        self.submitCommentButton.isEnabled = true
        
        self.submitCommentButton.backgroundColor = UIColor(red:0.01, green:0.68, blue:0.88, alpha:1.0) /* #056581 Blue*/
        
        
        print("NOW TYPING")
        
        // find length of the text...compare with width of UItextfield: if it greater then resize height, otherwise keep the same
        let currentHeight = self.commentTextField!.contentSize.height
        let commentFrameWidth = self.commentTextField?.frame.width
        
        self.commentTextField?.frame.size = CGSize(width: commentFrameWidth!, height: currentHeight)
        self.maxHeight = self.commentTextField!.font!.lineHeight * 6
        
        let newCommentViewWidth =  self.newCommentView?.frame.width
        let newY = self.view.frame.height - (keyboardHeight + textView.contentSize.height - 40)
        
        //- (keyboardHeight + currentHeight + 20 )
        
        contentSize = currentHeight
        
        print(textView.contentSize.height)
        let lineheight = CGFloat(16.31)
        
        if textView.contentSize.height  > 33 {
            
            self.newCommentView?.frame.size = CGSize(width: newCommentViewWidth!, height: currentHeight + 20)
            self.newCommentView?.frame.origin.y =  newY
            
        }
        
        
    }
    
    
    
    
    //    func updateLikes(userObj: PFObject, goalObj: PFObject) {
    //
    //        //update like count
    //
    //        goalObj.incrementKey("goalComments", byAmount: 1)
    //        goalObj.saveInBackground()
    //
    //        //add relation
    //        let likes = PFObject(className: "likes")
    //
    //        likes["likeGoalParent"] = goalObj
    //        likes["likeUserParent"] = userObj
    //
    //        likes.saveInBackground{(success, error) in
    //            if success == true {
    //                print(" saved to parse")
    //            } else {
    //                print("save failed: \(error)")
    //            }
    //        }
    //    }
    
    
    
    func postAComment(){
        
        
        if PFUser.current() == nil {
            
            
            let vC = self.storyboard?.instantiateViewController(withIdentifier: "userAuth") as! userAuthViewController
            vC.modalPresentationStyle = UIModalPresentationStyle.custom
            vC.transitioningDelegate = self
            vC.statusBarShouldBeHidden = true
            vC.cameFromInvest = true
            let vcRoot = UINavigationController(rootViewController: vC)
            self.present(vcRoot, animated: true, completion: nil)
            
            
            
            
            print("not loggd in")
            //            self.performSegue(withIdentifier: "commentsAuth" , sender: self)
            
        } else {
            
            
            if  self.commentTextField?.text == "" {
                
                
                print("Please leave a comment before sending")
                
                
            } else {
                
                
                
                let post = PFObject(className: "comments")
                
                let comment = self.commentTextField?.text
                post["comment"] = comment
                let author = PFUser.current()
                post["author"] = author
                
                
                
                //XYZ
                let goal = self.goalObject.goalObj
                
                post["Goal"] = self.goalObject.goalObj
                
                
                post.saveInBackground(block: { (success, error) -> Void in
                    
                    UIApplication.shared.endIgnoringInteractionEvents()
                    
                    if error == nil {
                        
                        
                        self.grabComments()
                        self.commentTextField?.text = ""
                        self.submitCommentButton.isEnabled = false
                        self.submitCommentButton.backgroundColor = UIColor(red:0.79, green:0.80, blue:0.80, alpha:1.0)
                        self.resignFirstResponder()
                        
                        
                        
                    } else {
                        
                        
                        
                    }
                    
                    
                })
                
                
                
                
            }}
        
    }
    
    var originalKeyBoardHeight = CGFloat()
    var keyboardHeight = CGFloat()
    
    
    func keyboardWillShow(_ notification: Notification) {
        
        
        
        
        
        
        if self.commentTextField!.text != "" {
            
            self.submitCommentButton.isEnabled = true
            
            self.submitCommentButton.backgroundColor = UIColor(red:0.01, green:0.68, blue:0.88, alpha:1.0) /* #056581 Blue*/
            
        }
        
        
        
        
        
        
        if let activeField = self.newCommentView, let keyboardSize = ((notification as NSNotification).userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            
            
            
            self.keyboardYorigin = keyboardSize.origin.y
            self.keyboardHeight = keyboardSize.size.height
            
            let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height + activeField.frame.height, right: 0.0)
            self.tableView.contentInset = contentInsets
            self.tableView.scrollIndicatorInsets = contentInsets
            
            
            var aRect = self.view.frame
            aRect.size.height -= keyboardSize.size.height
            
            
            if (!aRect.contains(activeField.frame.origin)) {
                
                print("NOT AT THE MOMENT")
                
                self.tableView.scrollRectToVisible(activeField.frame, animated: true)
            } else  {
                
                
                UIView.animate(withDuration: 0.1, animations: { () -> Void in
                    self.topConstraint.constant = -keyboardSize.size.height + 71
                })
                
                
            }
            
            
            
            
            
            
            
            
            
            
            //            activeField.frame.origin.y = heightElevation - 30
            
            //            var newY = contentSize - 30
            //
            //            if contentSize == 0 {
            //
            //                newY = 0
            //
            //            }
            //
            //
            //            if keyboardSize.size.height ==  236.0 {
            //
            //                activeField.frame.origin.y = heightElevation - 50 - newY
            //
            //
            //            }   else if  keyboardSize.size.height == 271.0  {
            //
            //
            //                activeField.frame.origin.y = heightElevation - 50 - newY
            //
            //            }
            //
            
            
            
            
        }
        
        
    }
    
    
    
    
    func keyboardWillBeHidden(_ notification: Notification) {
        
        
        let contentInsets = UIEdgeInsets.zero
        self.tableView.contentInset = contentInsets
        self.tableView.scrollIndicatorInsets = contentInsets
        
        //        UIView.animate(withDuration: 0.1, animations: { () -> Void in
        //            self.newCommentView!.frame.origin.y = self.view.frame.height - 98
        //            self.topConstraint.constant = 40
        ////            self.bottomConstraint.constant = 1000
        //        })
        
        
        let newY = self.view.frame.height - ( (self.commentTextField?.contentSize.height)! + 20 )
        
        if let heightElevation = self.view.frame.height - keyboardHeight as? CGFloat {
            
            print("EDITINGBEGIN")
            
            UIView.animate(withDuration: 0.1, animations: { () -> Void in
                self.newCommentView!.frame.origin.y = newY
                
            })
        }
        
        UIView.animate(withDuration: 0.1, animations: { () -> Void in
            
            self.topConstraint.constant =  0
            
        })
        
        
        
    }
    
    
    
    
    func registerForKeyboardNotifications()
    {
        //Adding notifies on keyboard appearing
        NotificationCenter.default.addObserver(self, selector: "keyboardWasShown:", name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(commentsViewController.keyboardWillBeHidden(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    
    func deregisterFromKeyboardNotifications()
    {
        //Removing notifies on keyboard appearing
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    
    
    
    
    
    
    
}
