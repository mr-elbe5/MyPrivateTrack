//
//  InfoViewController.swift
//  myprivatetrack
//
//  Created by Michael Rönnau on 08.08.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation
import UIKit

class ModalScrollViewController: ScrollStackViewController {
    
    override func loadView() {
        self.scrollViewTopPadding = 0
        super.loadView()
        self.modalPresentationStyle = .fullScreen
    }
    
    override func setupHeaderView(){
        let buttonView = UIView()
        buttonView.backgroundColor = UIColor.white
        let closeButton = IconButton(icon: "xmark.circle")
        buttonView.addSubview(closeButton)
        closeButton.addTarget(self, action: #selector(close), for: .touchDown)
        closeButton.enableAnchors()
        closeButton.setTopAnchor(buttonView.topAnchor)
        closeButton.setTrailingAnchor(buttonView.trailingAnchor)
        closeButton.setBottomAnchor(buttonView.bottomAnchor)
        headerView = buttonView
    }
    
    @objc func close(){
        self.dismiss(animated: true, completion: {
        })
    }
    
}
