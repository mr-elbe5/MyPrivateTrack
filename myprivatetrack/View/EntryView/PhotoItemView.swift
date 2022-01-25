//
//  ImageItemView.swift
//
//  Created by Michael Rönnau on 20.07.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation
import UIKit

protocol PhotoItemDelegate{
    func viewPhotoItem(data: PhotoData)
    func sharePhotoItem(data: PhotoData)
}

class PhotoItemView : EntryItemView{
    
    static func fromData(data : PhotoData,delegate : PhotoItemDelegate? = nil)  -> PhotoItemView{
        let itemView = PhotoItemView()
        itemView.delegate = delegate
        itemView.setupView(data: data)
        return itemView
    }
    
    fileprivate var aspectRatioConstraint:NSLayoutConstraint? = nil
    
    var photoData : PhotoData? = nil
    
    var delegate : PhotoItemDelegate? = nil
    
    var imageView = UIImageView()
    
    func setupView(data: PhotoData){
        imageView.setDefaults()
        imageView.setRoundedBorders()
        addSubview(imageView)
        self.photoData = data
        imageView.image = data.getImage()
        imageView.setAnchors(top: topAnchor, leading: leadingAnchor, trailing: trailingAnchor, insets: defaultInsets)
        imageView.setAspectRatioConstraint()
        if !data.title.isEmpty{
            let titleView = MediaCommentLabel(text: data.title)
            addSubview(titleView)
            titleView.setAnchors(top: imageView.bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: bottomAnchor, insets: defaultInsets)
        }
        else{
            imageView.bottom(bottomAnchor)
        }
        if delegate != nil{
            let sv = UIStackView()
            sv.setupHorizontal(distribution: .fillEqually, spacing: 2*defaultInset)
            addSubview(sv)
            sv.setAnchors(top: topAnchor, trailing: trailingAnchor, insets: doubleInsets)
            let viewButton = IconButton(icon: "magnifyingglass", tintColor: .systemBlue, backgroundColor: transparentColor)
            viewButton.addTarget(self, action: #selector(viewItem), for: .touchDown)
            sv.addArrangedSubview(viewButton)
            let shareButton = IconButton(icon: "square.and.arrow.up", tintColor: .systemBlue, backgroundColor: transparentColor)
            shareButton.addTarget(self, action: #selector(shareItem), for: .touchDown)
            sv.addArrangedSubview(shareButton)
        }
    }
    
    @objc func viewItem(){
        if let imageData = photoData{
            delegate?.viewPhotoItem(data: imageData)
        }
    }
    
    @objc func shareItem(){
        if let imageData = photoData{
            delegate?.sharePhotoItem(data: imageData)
        }
    }
    
}

class PhotoItemDetailView : EntryItemDetailView{
    
    var photoData : PhotoData? = nil
    
    var imageView = UIImageView()
    
    static func fromData(data : PhotoData)  -> PhotoItemDetailView{
        let itemView = PhotoItemDetailView()
        itemView.setupView(data: data)
        return itemView
    }
    
    func setupView(data: PhotoData){
        imageView.setDefaults()
        addSubview(imageView)
        self.photoData = data
        imageView.image = data.getImage()
        imageView.fillView(view: self)
    }
    
}

class PhotoItemEditView : EntryItemEditView, UITextViewDelegate{
    
    static func fromData(data : PhotoData)  -> PhotoItemEditView{
        let editView = PhotoItemEditView()
        editView.setupView(data: data)
        return editView
    }
    
    fileprivate var aspectRatioConstraint:NSLayoutConstraint? = nil
    
    var photoData : PhotoData!
    
    override var data: EntryItemData{
        get{
            return photoData
        }
    }
    
    var imageView = UIImageView()
    var titleView = TextEditArea()
    
    private func setupView(data: PhotoData){
        self.photoData = data
        imageView.image = data.getImage()
        titleView.setText(data.title)
        let deleteButton = addDeleteButton()
        imageView.setDefaults()
        imageView.setRoundedBorders()
        addSubview(imageView)
        titleView.setDefaults(placeholder: "comment".localize())
        titleView.delegate = self
        addSubview(titleView)
        titleView.setKeyboardToolbar()
        imageView.setAnchors(top: deleteButton.bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, insets: deleteInsets)
        imageView.setAspectRatioConstraint()
        titleView.setAnchors(top: imageView.bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: bottomAnchor, insets: flatInsets)
    }
    
    override func setFocus(){
        titleView.becomeFirstResponder()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if photoData != nil{
            photoData!.title = textView.text!.trim()
        }
        titleView.textDidChange()
    }
    
}
