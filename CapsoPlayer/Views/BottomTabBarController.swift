//
//  BottomTabBarController.swift
//  CapsoPlayer
//
//  Created by admin on 8/10/18.
//  Copyright © 2018 CapsoVision. All rights reserved.
//

import UIKit

class BottomTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    var captureArray: [Capture] = []
    var capturedImage: Capture?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
