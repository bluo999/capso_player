//
//  TabViewController.swift
//  CapsoPlayer
//
//  Created by admin on 8/10/18.
//  Copyright © 2018 CapsoVision. All rights reserved.
//

import UIKit

class TabViewController: UIViewController {
    
    var tabBar: BottomTabBarController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar = tabBarController as? BottomTabBarController
    }
    
    func setTabVisibility(visibilities: [Bool]) {
        let tabBarControllerItems = self.tabBarController?.tabBar.items
        var tab: UITabBarItem = UITabBarItem()
        
        if let arrayOfTabBarItems = tabBarControllerItems as AnyObject as? NSArray{
            for i in 0...visibilities.count-1 {
                tab = arrayOfTabBarItems[i] as! UITabBarItem
                tab.isEnabled = visibilities[i]
                if i == 2 { // Findings with Images (n)
                    tab.title = "Findings with Images (" + String((tabBar?.captureArray.count)!) + ")"
                }
            }
        }
    }
}
