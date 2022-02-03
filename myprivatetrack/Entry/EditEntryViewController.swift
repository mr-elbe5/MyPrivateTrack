//
//  EditEntryViewController.swift
//
//  Created by Michael Rönnau on 21.07.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import CoreLocation

protocol SaveEntryDelegate{
    func saveEntry(entry: EntryData)
}

class EditEntryViewController: EditViewController, PhotoCaptureDelegate, VideoCaptureDelegate, DeleteEntryActionDelegate{
    
    var delegate : SaveEntryDelegate? = nil
    
    var entry : EntryData!
    
    var showLocationSwitch = SwitchView()
    var addTextButton = IconButton(icon: "text.alignleft")
    var addPhotoButton = IconButton(icon: "camera")
    var addAudioButton = IconButton(icon: "mic")
    let addVideoButton = IconButton(icon: "video")
    
    override func loadView() {
        super.loadView()
        
        showLocationSwitch.setEnabled(entry.location != nil)
        showLocationSwitch.setupView(labelText: "showLocation".localize(), isOn: entry.showLocation)
        
        stackView.addArrangedSubview(showLocationSwitch)
        for item in entry.items{
            var editItem : EntryItemEditView? = nil
            switch item.type{
            case .text:
                editItem = TextItemEditView.fromData(data: item.data as! TextItemData)
                editItem?.delegate = self
                break
            case .audio:
                editItem = AudioItemEditView.fromData(data: item.data as! AudioData)
                editItem?.delegate = self
                break
            case .photo:
                editItem = PhotoItemEditView.fromData(data: item.data as! PhotoItemData)
                editItem?.delegate = self
                break
            case .video:
                editItem = VideoItemEditView.fromData(data: item.data as! VideoItemData)
                editItem?.delegate = self
                break
            }
            if let editItem = editItem{
                stackView.addArrangedSubview(editItem)
            }
        }
        let buttonContainer = ButtonStackView()
        buttonContainer.setupView()
        let saveButton = TextButton(text: (entry.isNew ? "save" : "ok").localize())
        saveButton.addTarget(self, action: #selector(save), for: .touchDown)
        buttonContainer.stackView.addArrangedSubview(saveButton)
        if entry.isNew{
            let cancelButton = TextButton(text: "cancel".localize())
            cancelButton.addTarget(self, action: #selector(cancel), for: .touchDown)
            buttonContainer.stackView.addArrangedSubview(cancelButton)
        }
        stackView.addArrangedSubview(buttonContainer)
    }
    
    override func setupHeaderView(){
        let headerView = UIView()
        let leftStackView = UIStackView()
        let rightStackView = UIStackView()
        headerView.backgroundColor = UIColor.systemBackground
        headerView.addSubview(leftStackView)
        headerView.addSubview(rightStackView)
        leftStackView.setupHorizontal(spacing: 2*defaultInset)
        leftStackView.setAnchors(top: headerView.topAnchor, leading: headerView.leadingAnchor, bottom: headerView.bottomAnchor, insets: defaultInsets)
        rightStackView.setupHorizontal(spacing: 2*defaultInset)
        rightStackView.setAnchors(top: headerView.topAnchor, trailing: headerView.trailingAnchor, bottom: headerView.bottomAnchor, insets: defaultInsets)
        
        addTextButton.addTarget(self, action: #selector(addText), for: .touchDown)
        leftStackView.addArrangedSubview(addTextButton)
        addPhotoButton.addTarget(self, action: #selector(addImage), for: .touchDown)
        leftStackView.addArrangedSubview(addPhotoButton)
        addAudioButton.addTarget(self, action: #selector(addAudio), for: .touchDown)
        leftStackView.addArrangedSubview(addAudioButton)
        addVideoButton.addTarget(self, action: #selector(addVideo), for: .touchDown)
        leftStackView.addArrangedSubview(addVideoButton)
        let infoButton = IconButton(icon: "info.circle")
        infoButton.addTarget(self, action: #selector(showInfo), for: .touchDown)
        rightStackView.addArrangedSubview(infoButton)
        
        self.headerView = headerView
    }
    
    @objc func addText(){
        let data = TextItemData()
        entry.addItem(item: data)
        let editView = TextItemEditView.fromData(data: data)
        insertItemView(editView)
    }
    
    @objc func addImage(){
        AVCaptureDevice.askCameraAuthorization(){ result in
            switch result{
            case .success(()):
                DispatchQueue.main.async {
                    let data = PhotoItemData()
                    let imageCaptureController = PhotoCaptureViewController()
                    imageCaptureController.data = data
                    imageCaptureController.delegate = self
                    imageCaptureController.modalPresentationStyle = .fullScreen
                    self.present(imageCaptureController, animated: true)
                }
                return
            case .failure:
                DispatchQueue.main.async {
                    self.showError("cameraNotAuthorized")
                }
                return
            }
        }
        
    }
    
    @objc func addAudio(){
        AVCaptureDevice.askAudioAuthorization(){ result in
            switch result{
            case .success(()):
                DispatchQueue.main.async {
                    let data = AudioData()
                    self.entry.addItem(item: data)
                    let editView = AudioItemEditView.fromData(data: data)
                    self.insertItemView(editView)
                }
                return
            case .failure:
                DispatchQueue.main.async {
                    self.showError("audioNotAuthorized")
                }
                return
            }
        }
    }
    
    @objc func addVideo(){
        AVCaptureDevice.askVideoAuthorization(){ result in
            switch result{
            case .success(()):
                DispatchQueue.main.async {
                    let data = VideoItemData()
                    let videoCaptureController = VideoCaptureViewController()
                    videoCaptureController.data = data
                    videoCaptureController.delegate = self
                    videoCaptureController.modalPresentationStyle = .fullScreen
                    self.present(videoCaptureController, animated: true)
                }
                return
            case .failure:
                DispatchQueue.main.async {
                    self.showError("videoNotAuthorized")
                }
                return
            }
        }
    }
    
    @objc func showInfo(){
        let infoController = EditEntryInfoViewController()
        self.present(infoController, animated: true)
    }
    
    func insertItemView(_ editView: EntryItemEditView){
        editView.delegate = self
        stackView.insertArrangedSubview(editView, at: stackView.arrangedSubviews.count-1)
        scrollView.setNeedsLayout()
        editView.setFocus()
    }
    
    func showError(_ reason: String){
        showAlert(title: "error".localize(), text: reason.localize())
    }
    
    // ImageCaptureDelegate
    
    func photoCaptured(photo: PhotoItemData){
        entry.addItem(item: photo)
        let editView = PhotoItemEditView.fromData(data: photo)
        insertItemView(editView)
    }
    
    // VideoCaptureDelegate
    
    func videoCaptured(data: VideoItemData){
        entry.addItem(item: data)
        let editView = VideoItemEditView.fromData(data: data)
        insertItemView(editView)
    }
    
    // DeleteEntryActionDelegate
    
    func deleteItem(itemView: EntryItemEditView) {
        showApprove(title: "reallyDeleteItem".localize(), text: "deleteItemApproveInfo".localize()){
            for v in self.stackView.arrangedSubviews{
                if v == itemView {
                    self.entry.removeItem(item: itemView.data)
                    self.stackView.removeArrangedSubview(itemView)
                    self.stackView.removeSubview(itemView)
                    break
                }
            }
        }
    }
    
    // SaveActionDelegate
    
    @objc func save(){
        if entry.items.count == 0{
            showAlert(title: "error".localize(), text: "noItems".localize())
            return
        }
        if (!entry.isComplete()){
            showAlert(title: "error".localize(), text: "notComplete".localize())
            return
        }
        entry.showLocation = showLocationSwitch.isOn
        delegate?.saveEntry(entry: entry)
        self.dismiss(animated: true)
    }
    
    @objc func cancel(){
        if entry.isNew{
            entry.removeAllItems()
        }
        self.dismiss(animated: true)
    }
    
    
}
