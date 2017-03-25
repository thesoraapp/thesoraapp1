//
//  MeViewController.swift
//  Mung
//
//  Created by Chike Chiejine on 06/10/2016.
//  Copyright © 2016 Color & Space. All rights reserved.
//

import UIKit

class MeViewController: UIViewController {

    @IBOutlet weak var tweetsContainer: UIView!
    @IBOutlet weak var mediaContainer: UIView!
    @IBOutlet weak var likesContainer: UIView!
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func showcomponents(_ sender: AnyObject) {
        
        
        if sender.selectedSegmentIndex == 0 {
            
            UIView.animate(withDuration: 0.5, animations: { 
                
                self.tweetsContainer.alpha = 1
                self.mediaContainer.alpha = 0
                self.likesContainer.alpha = 0
                
            })
        } else if sender.selectedSegmentIndex == 1 {
            
            UIView.animate(withDuration: 0.5, animations: {
            
            self.tweetsContainer.alpha = 0
            self.mediaContainer.alpha = 1
            self.likesContainer.alpha = 0
                
            })
            
        } else {
            
            UIView.animate(withDuration: 0.5, animations: {
            
            self.tweetsContainer.alpha = 0
            self.mediaContainer.alpha = 0
            self.likesContainer.alpha = 1
            
            })
            
        }
        
        
        
    }
    
    
    
    

}
