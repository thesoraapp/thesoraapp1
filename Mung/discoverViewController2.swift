
/*

//
//  discoverViewController2.swift
//  Mung
//
//  Created by Jake Dorab on 2/20/17.
//  Copyright © 2017 Color & Space. All rights reserved.
//

import UIKit
import Parse
import Alamofire
import AlamofireImage

class discoverViewController2: goalCollectionViewController {

    var currentUser : PFUser?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Fetch top goals
        
        var currentUser : PFUser?

        
        if PFUser.current() != nil {
            currentUser = PFUser.current()!
        }
        
        let likeC = likeClass()
        likeC.fetchLikedGoals(perspective: currentUser, indexStart: 0, indexEnd: 10, criteriaMap: [true, false, false], completion: { topGoals, error in
            
            
            if (error == nil) && (topGoals != nil) {
                
                // just to be safe needs to be on main thread (depends if fetchLikedGoals completion done on main thread)
    
                DispatchQueue.main.async {
                    self.goals = topGoals!
                }
                
            }
        })
        
        
    
    
    }

    /*
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        performSegue(withIdentifier: "discoverSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "discoverSegue", let destination = segue.destination as? goalCollectionViewController {
            destination.goals = [] // retrieved goals
        }
    }
 */
    
}
 
 */
