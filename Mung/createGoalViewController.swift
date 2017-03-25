//
//  createGoalViewController.swift
//  Mung
//
//  Created by Chike Chiejine on 18/10/2016.
//  Copyright © 2016 Color & Space. All rights reserved.
//

import UIKit

class createGoalViewController: UITableViewController {
    
    
    
    
    
    
    
    
    
    
    @IBOutlet weak var profileViewImage: UIButton!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
   

        
        tableView.tableFooterView = UIView()
        self.tableView.separatorInset = UIEdgeInsets.zero
        self.tableView.layoutMargins = UIEdgeInsets.zero
        self.tableView.preservesSuperviewLayoutMargins = false
        
        profileViewImage.layer.cornerRadius = 40
        profileViewImage.contentMode = .scaleAspectFill
        profileViewImage.layer.masksToBounds = true
        
    }
    
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        //Create label and autoresize it
        let headerLabel = UILabel()
        headerLabel.font =  UIFont(name: "Proxima Nova Soft", size: 16 )!
        headerLabel.textColor = UIColor(red:0.17, green:0.17, blue:0.17, alpha:1.0)
        headerLabel.text = self.tableView(self.tableView, titleForHeaderInSection: 0)
        headerLabel.sizeToFit()
        
        //Adding Label to existing headerView
        let headerView = UIView()
        headerView.addSubview(headerLabel)
        
        return headerView
    }
    
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

 

}
