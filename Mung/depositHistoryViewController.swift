//
//  depositHistoryViewController.swift
//  Mung
//
//  Created by Chike Chiejine on 13/01/2017.
//  Copyright © 2017 Color & Space. All rights reserved.
//

import UIKit
import MHPrettyDate

class depositHistoryViewController: UITableViewController {
    
    var goalObject = goalsClass()
    
    var goals = [goalsClass?]()
    
    var paymentSchedule = [String:Any]()
    
    func goBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        var tableHeader = UIView()
        tableHeader.backgroundColor = .soraGrey()
        tableHeader.frame = CGRect(x: 0, y: 0, width: Int(self.view.frame.width), height: 30)
        var instructionsLabel = UILabel()
        instructionsLabel.text = "SWIPE TO CANCEL"
        instructionsLabel.font = UIFont(name: "Proxima Nova Soft", size: 12 )
        instructionsLabel.textColor = .white
        instructionsLabel.sizeToFit()
        let xPos = self.view.frame.width - instructionsLabel.frame.width - 20
        let yPos = tableHeader.center.y - 15
        instructionsLabel.frame = CGRect(x: xPos, y: yPos, width: instructionsLabel.frame.width, height: 30)
        tableHeader.addSubview(instructionsLabel)
        self.tableView.tableHeaderView = tableHeader
        
        var backButtonImage = UIImage(named: "arrow-icon")
        let newBackButton = UIBarButtonItem(image: backButtonImage, style: UIBarButtonItemStyle.plain, target: self, action: "goBack" )
        self.navigationItem.leftBarButtonItem = newBackButton
        self.tableView.tableFooterView = UIView()
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
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        print("selfpayment1.a")
        print(self.paymentSchedule)
        print(self.paymentSchedule.count)

        //        return 3
        return self.goalObject.paymentSchedule!.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "deposit", for: indexPath) as! depositCell
        
        let dateFormatter = DateFormatter()
        var scheduleDates = [String]()
        var paymentAmounts = [String]()
        
        let sortedArray = self.goalObject.paymentSchedule!.sorted {return $0.key < $1.key}
        for item_ in sortedArray {
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            let date_ = (item_.value as! [String:Any])["paymentDate"] as! String
            let date = dateFormatter.date(from:date_)
            paymentAmounts.append(String(describing:((item_.value as! [String:Any])["paymentAmount"])!))
            scheduleDates.append((date?.toString())!)
        }
        cell.depositTime.text = scheduleDates[indexPath.row]
        cell.depositAmount.text = paymentAmounts[indexPath.row]
        return cell
    }
    
    
    //XYZ444 - Add functionality to payment cells. User can canel or move (perhaps move can be something for a future release)
    override func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        let move = UITableViewRowAction(style: .normal, title: "Move") { action, index in
            print("more button tapped")
        }
        move.backgroundColor = .lightGray
        
        let cancel = UITableViewRowAction(style: .normal, title: "Cancel") { action, index in
            print("Cancel this payment")
        }
       
        cancel.backgroundColor = .soraBlue()
        
        return [move, cancel]
    }
    
    //XYZ444- To enable the above functionality
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    
}
