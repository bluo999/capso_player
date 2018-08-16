//
//  ImageController.swift
//  CapsoPlayer
//
//  Created by admin on 8/8/18.
//  Copyright © 2018 CapsoVision. All rights reserved.
//

import UIKit

class ImageController: TabViewController, UITextViewDelegate {
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.setTabVisibility(visibilities: [false, true, false])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        imageView.image = tabBar?.capturedImage?.image
        infoLabel.text = "Frame: " + String((tabBar!.capturedImage?.frame)!) + ", Time: " + (tabBar!.capturedImage?.time)! + ", Flag: " + (tabBar!.capturedImage?.mark)!
    }
    
    @IBAction func clickSaveButton(_ sender: UIButton) {
        if textView.text == "Comments" {
            textView.text = ""
        }
        let newCapture = Capture(capture: tabBar!.capturedImage!, comment: textView.text)
        tabBar!.captureArray.append(newCapture)
        tabBar?.selectedIndex = 0
        
        print("Capture Saved")
    }
    
    @IBAction func clickDiscardButton(_ sender: UIButton) {
        tabBar?.selectedIndex = 0
        
        print("Capture Discarded")
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Comments"
            textView.textColor = UIColor.lightGray
        }
    }
    
    func changeImage(newImage: UIImage) {
        print(newImage)
        imageView.image = newImage
    }
}
