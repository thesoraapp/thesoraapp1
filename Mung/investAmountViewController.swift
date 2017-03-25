//
//  investAmountViewController.swift
//  Mung
//
//  Created by Chike Chiejine on 18/10/2016.
//  Copyright © 2016 Color & Space. All rights reserved.
//

import UIKit


class investAmountViewController: UITableViewController {
    
    
    
    @IBOutlet weak var performanceTitle: UILabel!
    
    @IBOutlet weak var performance: UITableViewCell!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var graphRange: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 271

        let width = self.view.frame.width
        let height = self.performance.frame.height
        
        let topY = self.performanceTitle.frame.origin.y
        
//    
//        let graphView = ScrollableGraphView(frame: CGRect(x: 0, y: topY + 80, width: width, height: height - 45))
//        let data: [Double] = [4, 8, 15, 16, 23, 42, 23, 45, 56, 68, 72, 85]
//        let labels = ["one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "ten", "eleven"]
//        graphView.set(data: data, withLabels: labels)
//
//        self.performance.insertSubview(graphView, belowSubview: self.priceLabel)
//
//        addSubview(graphView)
//        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }



}
