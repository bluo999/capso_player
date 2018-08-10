//
//  ViewController.swift
//  CapsoPlayer
//
//  Created by admin on 8/6/18.
//  Copyright © 2018 CapsoVision. All rights reserved.
//
//  TODO: end of video, dimensions
//

import UIKit
import AVFoundation

class VideoController: UIViewController {

    @IBOutlet weak var videoView: UIView!
    var player: AVPlayer!
    var playerLayer: AVPlayerLayer!
    /*
     https://v.cdn.vine.co/r/videos/AA3C120C521177175800441692160_38f2cbd1ffb.1.5.13763579289575020226.mp4
     */
    let videoURL = URL(string: "")!
    
    let framesPerSecond = 5.0
    var isVideoPlaying = false
    var currentFrame = 1
    var maxFrame = 1
    var atEnd = false
    
    var newImage: UIImage?
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var timeSlider: UISlider!
    
    @IBOutlet weak var serialNumberLabel: UILabel!
    @IBOutlet weak var frameLabel: UILabel!
    @IBOutlet weak var capsuleTimeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        player = AVPlayer(url: videoURL)
        player.currentItem?.addObserver(self, forKeyPath: "duration", options: [.new, .initial], context: nil)
        addTimeObserver()
        playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = .resize
        
        videoView.layer.addSublayer(playerLayer)
        
        maxFrame = (jsonData["FRAMES"] as! [String]).count - 1
        self.serialNumberLabel.text = "SN: " + (jsonData["SN"] as! String)
        updateCurrentFrame(frame: 1)
        
        NotificationCenter.default.addObserver(self, selector: #selector(VideoController.finishVideo), name: Notification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        playerLayer.frame = videoView.bounds
    }
    
    private func addTimeObserver() {
        let interval = CMTime(seconds: (1 / framesPerSecond), preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        let mainQueue = DispatchQueue.main
        _ = player.addPeriodicTimeObserver(forInterval: interval, queue: mainQueue, using: { [weak self]time in
            guard let currentItem = self?.player.currentItem else {return}
            
            self?.timeSlider.maximumValue = Float(CMTimeGetSeconds(currentItem.loadedTimeRanges[0].timeRangeValue.duration))
            self?.timeSlider.minimumValue = 0
            self?.timeSlider.value = Float(currentItem.currentTime().seconds)
            self?.currentTimeLabel.text = self?.getTimeString(from: currentItem.currentTime())
            self?.updateCurrentFrame(frame: Int(currentItem.currentTime().seconds * (self?.framesPerSecond)!) + 1)
        })
    }
    
    @IBAction func playPressed(_ sender: UIButton) {
        if isVideoPlaying {
            player.pause()
            sender.setTitle("Play", for: .normal)
        }
        else {
            if atEnd {
                player.seek(to: kCMTimeZero, toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero)
                atEnd = false
            }
            player.play()
            sender.setTitle("Pause", for: .normal)
        }
        
        isVideoPlaying = !isVideoPlaying
    }
    
    @IBAction func forwardPressed(_ sender: Any) {
        guard let duration = player.currentItem?.duration else {return}
        let currentTime = CMTimeGetSeconds(player.currentTime())
        let secondsForward = 1.0 / framesPerSecond
        var newTime = currentTime + secondsForward
        
        if newTime >= (CMTimeGetSeconds(duration) - secondsForward) {
            newTime = CMTimeGetSeconds(duration)
        }
        let time: CMTime = CMTimeMake(Int64(newTime * 100000), 100000)
        player.seek(to: time, toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero)
    }
    
    @IBAction func backwardsPressed(_ sender: Any) {
        let currentTime = CMTimeGetSeconds(player.currentTime())
        let secondsForward = 1.0 / framesPerSecond
        var newTime = currentTime - secondsForward
        
        if newTime < 0 {
            newTime = 0
        }
        let time: CMTime = CMTimeMake(Int64(newTime * 100000), 100000)
        player.seek(to: time, toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero)
        atEnd = false
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        let time: CMTime = CMTimeMake(Int64(sender.value * 100000), 100000)
        player.seek(to: time, toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero)
        if !isVideoPlaying {
            playButton.setTitle("Play", for: .normal)
            isVideoPlaying = !isVideoPlaying
        }
        atEnd = false
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "duration", let duration = player.currentItem?.duration.seconds, duration > 0.0 {
            self.durationLabel.text = getTimeString(from: player.currentItem!.duration)
        }
    }
    
    @IBAction func captureImage(_ sender: Any) {
        if isVideoPlaying {
            player.pause()
            playButton.setTitle("Play", for: .normal)
            isVideoPlaying = false
        }
        
        UIGraphicsBeginImageContextWithOptions(videoView.frame.size, false, UIScreen.main.scale)
        videoView.drawHierarchy(in: videoView.bounds, afterScreenUpdates: true)
        newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let tabBar = tabBarController as! BottomTabBarController
        tabBar.capturedImage = newImage!
        tabBar.frame = currentFrame
        tabBar.time = getVideoTimeFromFrame(frame: currentFrame)
    }
    
    private func getTimeString(from time: CMTime) -> String {
        let totalSeconds = CMTimeGetSeconds(time)
        let hours = Int(totalSeconds / 3600)
        let minutes = Int(totalSeconds / 60) % 60
        let seconds = Int(totalSeconds.truncatingRemainder(dividingBy: 60))
        
        if hours > 0 {
            return String(format: "%i:%02i:%02i", arguments: [hours, minutes, seconds])
        }
        else {
            return String(format: "%02i:%02i", arguments: [minutes, seconds])
        }
    }
    
    private func getVideoTimeFromFrame(frame: Int) -> String {
        let frames = jsonData["FRAMES"]
        return (frames as! [String])[frame - 1]
    }
    
    private func updateCurrentFrame(frame: Int) {
        self.currentFrame = frame;
        self.frameLabel.text = "Frame: " + String(frame) + " / " + String(maxFrame)
        self.capsuleTimeLabel.text = "Capsule Time: " + getVideoTimeFromFrame(frame: frame) + " / " + getVideoTimeFromFrame(frame: maxFrame)
    }
    
    @objc func finishVideo() {
        atEnd = true
        isVideoPlaying = false
        playButton.setTitle("Play", for: .normal)
    }
}

extension UIView {
    func addConstraintsWithFormat(_ format: String, views: UIView...) {
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = view
        }
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
}
