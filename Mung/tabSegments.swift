//
//  tabSegments.swift
//  Mung
//
//  Created by Chike Chiejine on 21/02/2017.
//  Copyright © 2017 Color & Space. All rights reserved.
//

import Foundation
import UIKit

class tabSegments  {
    
    func createTabs (viewController: UIViewController, numberOfTabs: Int, tabStrings: [String]) -> [UIButton] {
        var tabs = [UIButton]()
        for i in 0...(numberOfTabs-1) {
            let tab = self.createNewTab(viewController: viewController, numberOfTabs: numberOfTabs, tabPosition: i, tabString: tabStrings[i])
            tabs.append(tab)
        }
        return tabs
    }
    
    func createNewTab (viewController: UIViewController, numberOfTabs: Int, tabPosition: Int, tabString: String) -> UIButton {
        
        let newTab = UIButton()
        let countLabel = UILabel()
        let tabStringPlural = "\(tabString)s"
        
        let tabItemWidth = viewController.view.frame.width / CGFloat(numberOfTabs)
        newTab.tag = tabPosition
        let tabpos = tabItemWidth * CGFloat(tabPosition)
        newTab.frame = CGRect(x: tabpos, y:35, width: tabItemWidth, height: 35)
        
        newTab.setTitle(tabString.uppercased(), for: UIControlState.normal)

        if let viewController = viewController as? meViewController2 {
            newTab.addTarget(viewController, action: #selector(meViewController2.tabButtonPressed(sender:)), for: .touchUpInside)
        }
        
        newTab.tintColor = UIColor(red:0.54, green:0.54, blue:0.54, alpha:1.0)
        newTab.titleLabel?.font = UIFont(name: "Proxima Nova Soft", size: 10)
        newTab.contentHorizontalAlignment = UIControlContentHorizontalAlignment.center
        newTab.contentVerticalAlignment = UIControlContentVerticalAlignment.bottom
        newTab.titleLabel?.textAlignment = .center
        newTab.titleLabel?.numberOfLines = 2
        newTab.titleLabel?.lineBreakMode = .byWordWrapping
        newTab.setTitleColor(UIColor(red:0.54, green:0.54, blue:0.54, alpha:1.0), for: UIControlState.normal)
        
        countLabel.frame = CGRect(x: 0, y: 0, width: tabItemWidth, height: 15)
        countLabel.text = "0"
        countLabel.textColor = .gray
        countLabel.font = UIFont(name: "Proxima Nova Soft", size: 14 )
        countLabel.textAlignment = .center
        
        newTab.addSubview(countLabel)
        
        return newTab
    }
    
    func genContainerView(viewController: UIViewController, tabs: [UIButton], tabIndicator: UIView) -> UIView {
        let tabContainerView = UIView()
        tabContainerView.frame = CGRect(x: 0, y: 160, width: viewController.view.frame.width, height: 80)
        for tab in tabs {
            tabContainerView.addSubview(tab)
        }
        tabContainerView.addSubview(tabIndicator)
        return tabContainerView
    }
    
    func updateCount(tabs: [UIButton], tabCounts: [Int?]) {
        for i in 0...(tabs.count - 1) {
            if tabCounts[i] != nil {
                (tabs[i].subviews[1] as? UILabel)?.text = String(describing: tabCounts[i]!)
            }
        }
    }
    
    
    func createTabIndicator(tabs: [UIButton], currentTab: Int, tabIndicator: UIView) -> UIView {
      
        let tabYPos = tabs[0].frame.origin.y
        let tabItemWidth = tabs[0].frame.width
        tabIndicator.backgroundColor = UIColor(red:0.20, green:0.68, blue:0.89, alpha:1.0)
        if currentTab == 0 {
            tabIndicator.frame = CGRect(x: 0 , y: 78, width: tabItemWidth, height: 2)
        } else {
            tabIndicator.frame = CGRect(x: tabItemWidth , y:78, width: tabItemWidth, height: 2)
        }
        
        return tabIndicator

    }
    

    func updateLinePosition(tab: UIButton, tabIndicator: UIView, tabIndex: Int) {
        UIView.animate(withDuration: 0.3, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            tabIndicator.frame = CGRect(x: tab.frame.origin.x, y: tabIndicator.frame.origin.y, width: tabIndicator.frame.width, height: tabIndicator.frame.height)
        })
    }
}
