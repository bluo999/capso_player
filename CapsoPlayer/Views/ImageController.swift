//
//  ImageController.swift
//  CapsoPlayer
//
//  Created by admin on 8/8/18.
//  Copyright © 2018 CapsoVision. All rights reserved.
//

import UIKit
import Foundation

class ImageController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var infoLabel: UILabel!
    
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Make textView look like textField
        textView.layer.cornerRadius = 5.0
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.borderWidth = 0.5
        textView.clipsToBounds = true
        // Placeholder
        textView.text = "Comments"
        textView.textColor = UIColor.lightGray
        
        textView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let tabBar = tabBarController as! BottomTabBarController
        print(tabBar.capturedImage)
        imageView.image = tabBar.capturedImage
        infoLabel.text = "Frame: " + String(tabBar.frame) + ", Time: " + tabBar.time + ", Flag: NONE"
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Placeholder"
            textView.textColor = UIColor.lightGray
        }
    }
    
    func changeImage(newImage: UIImage) {
        print(newImage)
        imageView.image = newImage
    }
}
