//
//  EntryCell.swift
//  myprivatetrack
//
//  Created by Michael Rönnau on 15.06.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import UIKit

protocol EntryActionDelegate{
    func editEntry(entry: EntryData)
    func deleteEntry(entry: EntryData)
    func viewEntry(entry: EntryData)
    func viewImageItem(data: ImageData)
    func viewVideoItem(data: VideoData)
}

class EntryCell: UITableViewCell, ImageItemDelegate, VideoItemDelegate{
    
    var entry : EntryData? = nil {
        didSet {
            updateCell()
        }
    }
    
    var delegate: EntryActionDelegate? = nil
    
    var cellBody = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        isUserInteractionEnabled = true
        backgroundColor = .clear
        cellBody.backgroundColor = .systemGray6
        cellBody.layer.cornerRadius = 5
        addSubview(cellBody)
        cellBody.fillSuperview(padding: defaultInsets)
        accessoryType = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateCell(isEditing: Bool = false){
        cellBody.removeAllSubviews()
        if entry != nil{
            let timeLabel = UILabel()
            timeLabel.text = entry!.creationDate.timeString()
            timeLabel.textAlignment = .center
            cellBody.addSubview(timeLabel)
            timeLabel.placeBelow(anchor: cellBody.topAnchor, padding: defaultInsets)
            
            if isEditing{
                let editButton = IconButton(icon: "pencil.circle")
                editButton.tintColor = UIColor.systemBlue
                editButton.addTarget(self, action: #selector(editEntry), for: .touchDown)
                cellBody.addSubview(editButton)
                editButton.enableAnchors()
                editButton.setTopAnchor(cellBody.topAnchor, padding: defaultInset)
                
                let deleteButton = IconButton(icon: "xmark.circle")
                deleteButton.tintColor = UIColor.systemRed
                deleteButton.addTarget(self, action: #selector(deleteEntry), for: .touchDown)
                cellBody.addSubview(deleteButton)
                deleteButton.enableAnchors()
                deleteButton.setTopAnchor(cellBody.topAnchor, padding: defaultInset)
                
                deleteButton.setTrailingAnchor(cellBody.trailingAnchor, padding: defaultInset)
                editButton.setTrailingAnchor(deleteButton.leadingAnchor, padding: defaultInset)
            }
            else{
                let viewButton = ViewDetailButton()
                viewButton.addTarget(self, action: #selector(viewEntry), for: .touchDown)
                cellBody.addSubview(viewButton)
                viewButton.placeTopRight()
            }
            
            var lastView : UIView = timeLabel
            for item in entry!.items{
                switch item.type{
                case .text:
                    let itemView = TextItemView.fromData(data: item.data as! TextData)
                    cellBody.addSubview(itemView)
                    itemView.placeBelow(view: lastView, padding: defaultInsets)
                    lastView = itemView
                    break
                case .audio:
                    let itemView = AudioItemView.fromData(data: item.data as! AudioData)
                    cellBody.addSubview(itemView)
                    itemView.placeBelow(view: lastView, padding: defaultInsets)
                    lastView = itemView
                    break
                case .image:
                    let itemView = ImageItemView.fromData(data: item.data as! ImageData, delegate: self)
                    cellBody.addSubview(itemView)
                    itemView.placeBelow(view: lastView, padding: defaultInsets)
                    lastView = itemView
                    break
                case .video:
                    let itemView = VideoItemView.fromData(data: item.data as! VideoData, delegate: self)
                    cellBody.addSubview(itemView)
                    itemView.placeBelow(view: lastView, padding: defaultInsets)
                    lastView = itemView
                    break
                case .location:
                    let itemView = LocationItemView.fromData(data: item.data as! LocationData)
                    cellBody.addSubview(itemView)
                    itemView.placeBelow(view: lastView, padding: defaultInsets)
                    lastView = itemView
                    break
                }
            }
            lastView.connectBottom(view: cellBody, padding: defaultInset)
        }
    }
    
    @objc func editEntry() {
        if entry != nil{
            delegate?.editEntry(entry: entry!)
        }
    }
    
    @objc func deleteEntry() {
        if entry != nil{
            delegate?.deleteEntry(entry: entry!)
        }
    }
    
    @objc func viewEntry() {
        if entry != nil{
            delegate?.viewEntry(entry: entry!)
        }
    }
    
    func viewImageItem(data: ImageData){
        delegate?.viewImageItem(data: data)
    }
    
    func viewVideoItem(data: VideoData){
        delegate?.viewVideoItem(data: data)
    }
    
}
