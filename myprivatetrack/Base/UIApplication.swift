//
//  UIApplication.swift
//  myprivatetrack
//
//  Created by Michael Rönnau on 18.04.25.
//  Copyright © 2025 Michael Rönnau. All rights reserved.
//

import Foundation
import UIKit

extension UIApplication {
    var firstKeyWindow: UIWindow? {
        let windowScenes = UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }
        let activeScene = windowScenes.filter { $0.activationState == .foregroundActive }
        let firstActiveScene = activeScene.first
        return firstActiveScene?.keyWindow
    }
}
