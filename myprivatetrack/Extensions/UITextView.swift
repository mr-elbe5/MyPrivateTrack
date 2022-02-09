/*
 My Private Track
 App for creating a diary with entry based on time and map location using text, photos, audios and videos
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation

import UIKit

extension UITextView{
    
    @objc func setDefaults(){
        autocapitalizationType = .none
        autocorrectionType = .no
        font = UIFont.preferredFont(forTextStyle: .body)
        adjustsFontForContentSizeCategory = true
        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = 0.5
        layer.cornerRadius = 5
        layer.masksToBounds = true
    }
    
    func setKeyboardToolbar(doneTitle: String){
        let toolbar : UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        toolbar.barStyle = .default
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: doneTitle, style: .done, target: self, action: #selector(toolbarAction))
        toolbar.items = [flexSpace, done]
        toolbar.sizeToFit()
        self.inputAccessoryView = toolbar
    }
    
    @objc func toolbarAction(){
        self.resignFirstResponder()
    }
    
}

