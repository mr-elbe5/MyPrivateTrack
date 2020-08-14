//
//  DaySectionHeader.swift
//  myprivatetrack
//
//  Created by Michael Rönnau on 21.06.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation
import UIKit

class DayHeaderLabel: UILabel {
    
    override var intrinsicContentSize: CGSize{
        let originalSize = super.intrinsicContentSize
        let height = originalSize.height + 12
        layer.cornerRadius = height/2
        layer.masksToBounds = true
        return CGSize(width: originalSize.width + 16, height: height)
    }
    
}

class DaySectionHeader : UIView{
    
    public func setupView(day: DayData){
        let label = DayHeaderLabel()
        label.text = day.date.dateString()
        label.textAlignment = .center
        label.backgroundColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 14)
        
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [label.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
}
