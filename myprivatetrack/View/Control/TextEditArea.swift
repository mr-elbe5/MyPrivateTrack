//
//  TextEditArea.swift
//
//  Created by Michael Rönnau on 11.08.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation
import UIKit

public class TextEditArea : UITextView{
    
    private let placeholderTextView: UITextView = {
        let tv = UITextView()
        
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = .clear
        tv.isScrollEnabled = false
        tv.textColor = .placeholderText
        tv.isUserInteractionEnabled = false
        return tv
    }()
    
    public var placeholder: String? {
        get {
            return placeholderTextView.text
        }
        set {
            placeholderTextView.text = newValue
        }
    }
    
    override public init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        placeholderTextView.font = UIFont.preferredFont(forTextStyle: .body)
        addSubview(placeholderTextView)
        placeholderTextView.fillSuperview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setDefaults(placeholder : String = ""){
        super.setDefaults()
        self.placeholder = placeholder
    }
    
    override public var contentInset: UIEdgeInsets {
        didSet {
            placeholderTextView.contentInset = contentInset
        }
    }
    
    public func setText(_ text: String){
        self.text = text
        placeholderTextView.isHidden = !text.isEmpty
    }
    
    public func textDidChange() {
        invalidateIntrinsicContentSize()
        placeholderTextView.isHidden = !text.isEmpty
    }
    
    override public var intrinsicContentSize: CGSize {
        var size = super.intrinsicContentSize
        if size.height == UIView.noIntrinsicMetric {
            // force layout
            layoutManager.glyphRange(for: textContainer)
            size.height = layoutManager.usedRect(for: textContainer).height + textContainerInset.top + textContainerInset.bottom
        }
        return size
    }
    
    func setKeyboardToolbar(){
        let toolbar : UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        toolbar.barStyle = .default
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "done".localize(), style: .done, target: self, action: #selector(toolbarAction))
        toolbar.items = [flexSpace, done]
        toolbar.sizeToFit()
        self.inputAccessoryView = toolbar
    }
    
    @objc func toolbarAction(){
        self.resignFirstResponder()
    }

}