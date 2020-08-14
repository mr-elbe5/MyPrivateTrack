//
//  AudioRecorder.swift
//  myprivatetrack
//
//  Created by Michael Rönnau on 09.08.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class AudioRecorderView : AudioPlayerView, AVAudioRecorderDelegate{
    
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    
    var recordButton = IconButton(icon: "mic.fill")
    
    override func setupView() {
        super.setupView()
        recordButton.addTarget(self, action: #selector(toggleRecording), for: .touchUpInside)
        addSubview(recordButton)
        self.recordButton.isEnabled = false
        self.rewindButton.isEnabled = false
        self.playButton.isEnabled = false
    }

    override func layoutView(){
        recordButton.placeAfter(anchor: leadingAnchor)
        playProgress.enableAnchors()
        playProgress.setLeadingAnchor(recordButton.trailingAnchor,padding: Statics.defaultInset)
        playProgress.setCenterYAnchor(centerYAnchor)
        playButton.placeBefore(anchor: trailingAnchor)
        rewindButton.placeBefore(view: playButton)
        playProgress.setTrailingAnchor(rewindButton.leadingAnchor, padding: Statics.defaultInset)
    }
    
    func enableRecording(){
        recordingSession = AVAudioSession.sharedInstance()
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    self.recordButton.isEnabled = allowed
                }
            }
        } catch {
            self.recordButton.isEnabled = false
        }
    }
    
    func startRecording() {
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 16000,
            AVEncoderAudioQualityKey: AVAudioQuality.low.rawValue,
            AVNumberOfChannelsKey: 1
        ]
        if let url = url{
            do{
                audioRecorder = try AVAudioRecorder(url: url, settings: settings)
                audioRecorder.delegate = self
                audioRecorder.record()
                recordButton.setImage(UIImage(systemName: "mic.slash.fill"), for: .normal)
            }
            catch{
                recordButton.isEnabled = false
            }
        }
    }
    
    func finishRecording(success: Bool) {
        audioRecorder.stop()
        audioRecorder = nil

        if success {
            playButton.isEnabled = true
            enablePlayer()
        } else {
            playButton.isEnabled = false
        }
        recordButton.setImage(UIImage(systemName: "mic.fill"), for: .normal)
    }
    
    @objc func toggleRecording() {
        if audioRecorder == nil {
            startRecording()
        } else {
            finishRecording(success: true)
        }
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording(success: flag)
        }
    }
    
}
