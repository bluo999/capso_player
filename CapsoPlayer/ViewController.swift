//
//  ViewController.swift
//  CapsoPlayer
//
//  Created by admin on 8/6/18.
//  Copyright © 2018 CapsoVision. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var videoView: UIView!
    var player: AVPlayer!
    var playerLayer: AVPlayerLayer!
    
    let framesPerSecond = 5.0
    var isVideoPlaying = false
    var currentFrame = 1;
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var timeSlider: UISlider!
    
    @IBOutlet weak var serialNumberLabel: UILabel!
    @IBOutlet weak var frameLabel: UILabel!
    @IBOutlet weak var capsuleTimeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //https://v.cdn.vine.co/r/videos/AA3C120C521177175800441692160_38f2cbd1ffb.1.5.13763579289575020226.mp4
        let videoURL = URL(string: "https://v.cdn.vine.co/r/videos/AA3C120C521177175800441692160_38f2cbd1ffb.1.5.13763579289575020226.mp4")!
        player = AVPlayer(url: videoURL)
        player.currentItem?.addObserver(self, forKeyPath: "duration", options: [.new, .initial], context: nil)
        addTimeObserver()
        playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = .resize
        
        videoView.layer.addSublayer(playerLayer)
        
        self.serialNumberLabel.text = "SN: " + (jsonData["SN"] as! String)
        self.frameLabel.text = "Frame: " + String(currentFrame)
        self.capsuleTimeLabel.text = "Video Time: " + getVideoTimeFromFrame(frame: currentFrame)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        playerLayer.frame = videoView.bounds
    }
    
    func addTimeObserver() {
        let interval = CMTime(seconds: (1 / framesPerSecond), preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        let mainQueue = DispatchQueue.main
        _ = player.addPeriodicTimeObserver(forInterval: interval, queue: mainQueue, using: { [weak self]time in
            guard let currentItem = self?.player.currentItem else {return}
            self?.timeSlider.maximumValue = Float(CMTimeGetSeconds(currentItem.loadedTimeRanges[0].timeRangeValue.duration))
            self?.timeSlider.minimumValue = 0
            self?.timeSlider.value = Float(currentItem.currentTime().seconds)
            self?.currentTimeLabel.text = self?.getTimeString(from: currentItem.currentTime())
            self?.currentFrame = Int(currentItem.currentTime().seconds * (self?.framesPerSecond)!)
            self?.frameLabel.text = String(self!.currentFrame)
        })
    }
    
    @IBAction func playPressed(_ sender: UIButton) {
        if isVideoPlaying {
            player.pause()
            sender.setTitle("Play", for: .normal)
        }
        else {
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
        let time: CMTime = CMTimeMake(Int64(newTime * 1000), 1000)
        player.seek(to: time)
    }
    
    @IBAction func backwardsPressed(_ sender: Any) {
        let currentTime = CMTimeGetSeconds(player.currentTime())
        let secondsForward = 1.0 / framesPerSecond
        var newTime = currentTime - secondsForward
        
        if newTime < 0 {
            newTime = 0
        }
        let time: CMTime = CMTimeMake(Int64(newTime * 1000), 1000)
        player.seek(to: time)
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        player.seek(to: CMTimeMake(Int64(sender.value * 1000), 1000))
        if !isVideoPlaying {
            playButton.setTitle("Play", for: .normal)
            isVideoPlaying = !isVideoPlaying
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "duration", let duration = player.currentItem?.duration.seconds, duration > 0.0 {
            self.durationLabel.text = getTimeString(from: player.currentItem!.duration)
        }
    }
    
    func getTimeString(from time: CMTime) -> String {
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
    
    func getVideoTimeFromFrame(frame: Int) -> String {
        let frames = jsonData["FRAMES"]
        return (frames as! [String])[frame]
    }
}

