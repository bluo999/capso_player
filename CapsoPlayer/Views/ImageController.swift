//
//  ImageController.swift
//  CapsoPlayer
//
//  Created by admin on 8/8/18.
//  Copyright © 2018 CapsoVision. All rights reserved.
//

import UIKit
import Foundation

class ImageController: UIViewController {
    static let imageController = ImageController()
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func changeImage(newImage: UIImage) {
        print(newImage)
        imageView.image = newImage
    }
}
