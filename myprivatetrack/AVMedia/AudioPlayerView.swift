/*
 My Private Track
 App for creating a diary with entry based on time and map location using text, photos, audios and videos
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation
import UIKit
import AVFoundation

class AudioPlayerView : UIView, AVAudioPlayerDelegate{
    
    var player : AVPlayer
    var playerItem : AVPlayerItem? = nil
    
    var playProgress = UIProgressView()
    var rewindButton = IconButton(icon: "repeat")
    var playButton = IconButton(icon: "play.fill")
    var volumeView = VolumeSlider()
    
    var timeObserverToken : Any? = nil
    
    private var _url : URL? = nil
    var url : URL?{
        get{
            return _url
        }
        set{
            _url = newValue
            playProgress.setProgress(0, animated: false)
            rewindButton.isEnabled = false
            if _url == nil{
                playButton.isEnabled = false
            } else {
                playButton.isEnabled = true
            }
        }
    }
    
    override init(frame: CGRect) {
        self.player = AVPlayer()
        super.init(frame: frame)
        setRoundedBorders()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(playerItemDidReachEnd(notification:)),
                                               name: .AVPlayerItemDidPlayToEndTime,
                                               object: player.currentItem)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        addSubview(playProgress)
        rewindButton.addTarget(self, action: #selector(rewind), for: .touchDown)
        addSubview(rewindButton)
        playButton.addTarget(self, action: #selector(togglePlay), for: .touchDown)
        addSubview(playButton)
        rewindButton.isEnabled = false
        playButton.isEnabled = false
        volumeView.addTarget(self, action: #selector(volumeChanged), for: .valueChanged)
        addSubview(volumeView)
    }
    
    func layoutView(){
        playProgress.setAnchors(leading: leadingAnchor, insets: defaultInsets)
            .centerY(centerYAnchor)
        playButton.setAnchors(top: topAnchor, trailing: trailingAnchor, insets: defaultInsets)
        rewindButton.setAnchors(top: topAnchor, trailing: playButton.leadingAnchor, insets: defaultInsets)
        playProgress.trailing(rewindButton.leadingAnchor, inset: defaultInset)
        volumeView.setAnchors(top: playProgress.bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: bottomAnchor, insets: defaultInsets)
    }
    
    func enablePlayer(){
        if url != nil{
            removePeriodicTimeObserver()
            let asset = AVURLAsset(url: url!)
            playerItem = AVPlayerItem(asset: asset)
            player.replaceCurrentItem(with: playerItem!)
            player.rate = 0
            player.volume = volumeView.value
            addPeriodicTimeObserver(duration: asset.duration)
            rewindButton.isEnabled = false
            volumeView.isEnabled = true
        }
    }
    
    func disablePlayer(){
        player.rate = 0
        removePeriodicTimeObserver()
        playerItem = nil
        playProgress.setProgress(0, animated: false)
        rewindButton.isEnabled = false
        playButton.isEnabled = false
        volumeView.isEnabled = false
    }
    
    func addPeriodicTimeObserver(duration: CMTime) {
        let seconds = Float(CMTimeGetSeconds(duration))
        let timeScale = CMTimeScale(NSEC_PER_SEC)
        let time = CMTime(seconds: 0.5, preferredTimescale: timeScale)
        
        timeObserverToken = player.addPeriodicTimeObserver(forInterval: time,
                                                           queue: .main) {
                                                            [weak self] time in
                                                            let part = Float(CMTimeGetSeconds(time))
                                                            self?.playProgress.setProgress(part/seconds, animated: true)
        }
    }

    func removePeriodicTimeObserver() {
        if let timeObserverToken = timeObserverToken {
            player.removeTimeObserver(timeObserverToken)
            self.timeObserverToken = nil
        }
    }
    
    @objc func rewind(){
        player.rate = 0
        if let item = playerItem{
            item.seek(to: CMTime.zero, completionHandler: nil)
        }
        playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        playProgress.setProgress(0, animated: false)
        rewindButton.isEnabled = false
        playButton.isEnabled = true
    }
    
    @objc func togglePlay(){
        if player.rate == 0{
            player.rate = 1
            playButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
            rewindButton.isEnabled = false
        }
        else{
            player.rate = 0
            playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
            rewindButton.isEnabled = true
        }
    }
    
    @objc func volumeChanged(){
        player.volume = volumeView.value
    }
    
    @objc func playerItemDidReachEnd(notification: Notification) {
        if let playerItem = notification.object as? AVPlayerItem {
            playerItem.seek(to: CMTime.zero, completionHandler: nil)
            player.rate = 0
            playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
            playButton.isEnabled = true
            rewindButton.isEnabled = false
        }
    }
    
}
