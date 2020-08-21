//
//  ViewController.swift
//  myprivatetrack
//
//  Created by Michael Rönnau on 18.08.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation
import UIKit

class ViewController: UIViewController {
    
    var mainViewTopPadding : CGFloat = 1
    var headerView : UIView? = nil
    var mainView = UIView()
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = .systemGroupedBackground
        let guide = view.safeAreaLayoutGuide
        setupHeaderView()
        if let headerView = headerView{
            view.addSubview(headerView)
            headerView.enableAnchors()
            headerView.setLeadingAnchor(guide.leadingAnchor, padding: .zero)
            headerView.setTopAnchor(guide.topAnchor,padding: .zero)
            headerView.setTrailingAnchor(guide.trailingAnchor,padding: .zero)
        }
        self.view.addSubview(mainView)
        mainView.backgroundColor = .systemBackground
        mainView.enableAnchors()
        mainView.setLeadingAnchor(guide.leadingAnchor, padding: .zero)
        mainView.setTopAnchor(headerView?.bottomAnchor ?? guide.topAnchor, padding: mainViewTopPadding)
        mainView.setTrailingAnchor(guide.trailingAnchor,padding: .zero)
        mainView.setBottomAnchor(guide.bottomAnchor, padding: .zero)
    }
    
    func setupHeaderView(){
        
    }
    
}