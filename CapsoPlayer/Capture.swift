//
//  Capture.swift
//  CapsoPlayer
//
//  Created by admin on 8/10/18.
//  Copyright © 2018 CapsoVision. All rights reserved.
//

import UIKit

class Capture {
    var image: UIImage?
    var frame: Int = 0
    var time: String = ""
    var mark: String = "" // could use enum
    var comment: String = ""
    
    init(image: UIImage, frame: Int, time: String, mark: String) {
        self.image = image
        self.frame = frame
        self.time = time
        self.mark = mark
    }
    
    convenience init(capture: Capture, comment: String) {
        self.init(image: capture.image!, frame: capture.frame, time: capture.time, mark: capture.mark)
        self.comment = comment
    }
}
