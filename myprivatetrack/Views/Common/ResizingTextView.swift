//
//  ResizingTextView.swift
//  myprivatetrack
//
//  Created by Michael Rönnau on 11.08.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation
import UIKit

class ResizingTextView : UITextView{
    
    private let placeholderTextView: UITextView = {
        let tv = UITextView()
        
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = .clear
        tv.isScrollEnabled = false
        tv.textColor = .placeholderText
        tv.isUserInteractionEnabled = false
        return tv
    }()
    
    var placeholder: String? {
        get {
            return placeholderTextView.text
        }
        set {
            placeholderTextView.text = newValue
        }
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        placeholderTextView.font = UIFont.preferredFont(forTextStyle: .body)
        addSubview(placeholderTextView)
        placeholderTextView.fillSuperview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setDefaults(placeholder : String = ""){
        super.setDefaults()
        self.placeholder = placeholder
    }
    
    override var contentInset: UIEdgeInsets {
        didSet {
            placeholderTextView.contentInset = contentInset
        }
    }
    
    func setText(_ text: String){
        self.text = text
        placeholderTextView.isHidden = !text.isEmpty
    }
    
    func textDidChange() {
        invalidateIntrinsicContentSize()
        placeholderTextView.isHidden = !text.isEmpty
    }
    
    override var intrinsicContentSize: CGSize {
        var size = super.intrinsicContentSize
        if size.height == UIView.noIntrinsicMetric {
            // force layout
            layoutManager.glyphRange(for: textContainer)
            size.height = layoutManager.usedRect(for: textContainer).height + textContainerInset.top + textContainerInset.bottom
        }
        return size
    }

}
