//
//  profileViewController.swift
//  Mung
//
//  Created by Chike Chiejine on 04/10/2016.
//  Copyright © 2016 Color & Space. All rights reserved.
//

import UIKit

class profileViewController: UIViewController {
    
    
    @IBOutlet weak var pageControl: UIPageControl!
    var pageViewController : UIPageViewController!

    @IBOutlet weak var containerView: UIView!
    
    var ProfileTabsViewController: profileTabsViewController?

    override func viewDidLoad() {
        super.viewDidLoad()

        pageControl.isHidden = true
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let tutorialPageViewController = segue.destination as? profileTabsViewController {
            self.ProfileTabsViewController = tutorialPageViewController
        }
    }
    
    @IBAction func didTapNextButton(_ sender: UIButton) {
        ProfileTabsViewController?.scrollToNextViewController()
    }
    
    /**
     Fired when the user taps on the pageControl to change its current page.
     */
    func didChangePageControlValue() {
        ProfileTabsViewController?.scrollToViewController(index: pageControl.currentPage)
    }

    

}


//extension profileViewController: profileTabsViewControllerDelegate {
//    
//    func ProfileTabsViewController(ProfileTabsViewController: profileTabsViewController,
//                                    didUpdatePageCount count: Int) {
//        pageControl.numberOfPages = count
//    }
//    
//    func ProfileTabsViewController(ProfileTabsViewController: profileTabsViewController,
//                                    didUpdatePageIndex index: Int) {
//        pageControl.currentPage = index
//    }
//    
//}
