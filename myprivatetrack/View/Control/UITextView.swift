//
//  UITextView.swift
//
//  Created by Michael Rönnau on 23.06.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation
import UIKit

extension UITextView{
    
    @objc public func setDefaults(){
        autocapitalizationType = .none
        autocorrectionType = .no
        font = UIFont.preferredFont(forTextStyle: .body)
        adjustsFontForContentSizeCategory = true
        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = 0.5
        layer.cornerRadius = 5
        layer.masksToBounds = true
    }
    
}