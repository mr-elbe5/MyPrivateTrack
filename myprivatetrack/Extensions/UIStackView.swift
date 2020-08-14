//
//  UIStackView.swift
//  myprivatetrack
//
//  Created by Michael Rönnau on 11.07.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation
import UIKit

extension UIStackView{
    
    func setupVertical(spacing: CGFloat = 0){
        self.axis = .vertical
        self.alignment = .fill
        self.distribution = .equalSpacing
        self.spacing = spacing
    }
    
    func setupHorizontal(distribution: UIStackView.Distribution = .fill, spacing: CGFloat = 0){
        self.axis = .horizontal
        self.alignment = .fill
        self.distribution = distribution
        self.spacing = spacing
    }
    
    func removeAllArrangedSubviews() {
        for subview in subviews {
            removeArrangedSubview(subview)
        }
        removeAllSubviews()
    }

}
