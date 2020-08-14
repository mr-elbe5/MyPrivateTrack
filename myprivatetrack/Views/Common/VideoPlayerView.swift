//
//  VideoPlayerView.swift
//  myprivatetrack
//
//  Created by Michael Rönnau on 03.08.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class VideoPlayerView: UIView {
    
    var player : AVPlayer
    var playerLayer : AVPlayerLayer
    var aspectRatio : CGFloat = 1
    
    var playButton = UIButton()
    
    var url : URL? = nil{
        didSet{
            if url != nil{
                let asset = AVURLAsset(url: url!)
                if let track = asset.tracks(withMediaType: AVMediaType.video).first{
                    let size = track.naturalSize.applying(track.preferredTransform)
                    self.aspectRatio = abs(size.width / size.height)
                }
                let item = AVPlayerItem(asset: asset)
                player.replaceCurrentItem(with: item)
                layoutSubviews()
            }
        }
    }
    
    override init(frame: CGRect) {
        self.player = AVPlayer()
        self.playerLayer = AVPlayerLayer(player: player)
        super.init(frame: frame)
        setRoundedBorders()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(playerItemDidReachEnd(notification:)),
                                               name: .AVPlayerItemDidPlayToEndTime,
                                               object: player.currentItem)
        playerLayer.videoGravity = .resizeAspectFill
        playerLayer.needsDisplayOnBoundsChange = true
        self.layer.addSublayer(playerLayer)
        playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        playButton.tintColor = UIColor.white
        playButton.addTarget(self, action: #selector(togglePlay), for: .touchDown)
        addSubview(playButton)
        playButton.enableAnchors()
        playButton.setCenterXAnchor(centerXAnchor)
        playButton.setBottomAnchor(bottomAnchor, padding: Statics.defaultInset)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.playerLayer.frame = self.bounds
    }
    
    @objc func togglePlay(){
        if player.rate == 0{
            player.rate = 1
            playButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        }
        else{
            player.rate = 0
            playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        }
    }
    
    @objc func playerItemDidReachEnd(notification: Notification) {
        if let playerItem = notification.object as? AVPlayerItem {
            playerItem.seek(to: CMTime.zero, completionHandler: nil)
            player.rate = 0
            playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        }
    }
    
    override var intrinsicContentSize: CGSize {
        var size = super.intrinsicContentSize
        if size.height == UIView.noIntrinsicMetric {
            size.height = size.width / aspectRatio
        }
        return size
    }
    
    func setAspectRatioConstraint() {
        let c = NSLayoutConstraint(item: self, attribute: .width,
                                   relatedBy: .equal,
                                   toItem: self, attribute: .height,
                                   multiplier: aspectRatio, constant: 0)
        c.priority = UILayoutPriority(900)
        self.addConstraint(c)
    }
    
}

