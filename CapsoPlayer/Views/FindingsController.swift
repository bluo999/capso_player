//
//  FindingsController.swift
//  CapsoPlayer
//
//  Created by admin on 8/10/18.
//  Copyright © 2018 CapsoVision. All rights reserved.
//

import UIKit

class FindingsController: TabViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        super.setTabVisibility(visibilities: [true, false, true])
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (tabBar?.captureArray.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CaptureCell
        let capture = tabBar?.captureArray[indexPath.row]
        let size = CGSize(width: 414, height: 74.5)
        cell.capsuleImage.image =  capture?.image?.resizeImageWith(newSize: size)
        cell.frameLabel.text = "Frame: " + String((capture?.frame)!)
        cell.timeLabel.text = "Time: " + String((capture?.time)!)
        cell.commentsView.text = capture?.comment
        
        // Make textView look like textField
        cell.commentsView.layer.cornerRadius = 5.0
        cell.commentsView.layer.borderColor = UIColor.lightGray.cgColor
        cell.commentsView.layer.borderWidth = 0.5
        cell.commentsView.clipsToBounds = true
        cell.commentsView.isEditable = true
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tabBar?.captureArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    /*func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            // handle delete (by removing the data from your array and updating the tableview)
        }
    }*/
    
    @IBAction func pressDelete(_ sender: UIButton) {
        
    }
}

extension UIImage{
    
    func resizeImageWith(newSize: CGSize) -> UIImage {
        let horizontalRatio = newSize.width / size.width
        let verticalRatio = newSize.height / size.height
        
        let ratio = max(horizontalRatio, verticalRatio)
        let newSize = CGSize(width: size.width * ratio, height: size.height * ratio)
        UIGraphicsBeginImageContextWithOptions(newSize, true, 0)
        draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
}
