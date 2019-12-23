//
//  VideoCollectionViewCell.swift
//  CollectionMedia
//
//  Created by Arturo Carretero Calvo on 23/12/2019.
//  Copyright © 2019 Arturo Carretero Calvo. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class VideoCollectionViewCell: UICollectionViewCell {
    
    // MARK: Properties
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    var videoPlayer: AVPlayerViewController?
    var avPlayerController: AVPlayerViewController?
    var paused: Bool = false
    var videoUrl: String? = nil {
        didSet {
            self.setupMoviePlayer()
        }
    }
    var avVolume: Float = 3
    var avBackgroundColor: UIColor = UIColor.clear
    
    // MARK: Public functions
    func setupMoviePlayer() {
        self.loading.isHidden = false
        self.loading.startAnimating()
        if let urlString = self.videoUrl,
            let url = URL(string: urlString) {
            let avPlayer = AVPlayer.init(playerItem: AVPlayerItem(url: url))
            avPlayer.volume = self.avVolume
            avPlayer.actionAtItemEnd = .none
            self.avPlayerController = AVPlayerViewController()
            if let avPlayController = self.avPlayerController {
                avPlayController.player = avPlayer
                NotificationCenter.default.addObserver(self,
                                                       selector: #selector(self.playerItemDidReachEnd(notification:)),
                                                       name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                                       object: avPlayer.currentItem)
                avPlayController.view.frame = self.videoView.bounds
                avPlayController.videoGravity = AVLayerVideoGravity.resizeAspectFill
                avPlayController.showsPlaybackControls = false
                avPlayController.view.backgroundColor = self.avBackgroundColor
                avPlayController.allowsPictureInPicturePlayback = true
                for view in self.videoView.subviews {
                    view.removeFromSuperview()
                }
                self.videoView.insertSubview(avPlayController.view, at: 0)
            }
        }
    }
    
    func stopPlayback() {
        if let avPlayController = self.avPlayerController,
            let player = avPlayController.player {
            player.pause()
        }
    }
    
    func startPlayback() {
        if let avPlayController = self.avPlayerController,
            let player = avPlayController.player {
            player.play()
            self.loading.isHidden = true
        }
    }
    
    @objc func playerItemDidReachEnd(notification: Notification) {
        guard let p: AVPlayerItem = notification.object as? AVPlayerItem else {
            return
        }
        p.seek(to: CMTime.zero) { (_) in
        }
    }
}
