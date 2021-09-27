//
//  LRTextView.swift
//  LandmarkRemark
//
//  Created by Arvin on 24/9/21.
//

import UIKit

protocol LRTextViewDelegate: AnyObject {
    func lrTextViewDidChange(_ textView: LRTextView)
}

class LRTextView: UITextView {

    var placeholder = "" {
        didSet { showPlaceholder() }
    }
    
    override var text: String! {
        // Chang text color to indicate that a placeholder is being shown
        didSet { textColor = text == placeholder ? .tertiaryLabel : .label }
    }
    
    weak var changeDelegate: LRTextViewDelegate?
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        delegate = self
        font = UIFont.systemFont(ofSize: 14.0, weight: .regular)
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func showPlaceholder() {
        text = placeholder
    }
    
    private func hidePlaceholder() {
        text = ""
    }
}

extension LRTextView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        // once user started editing, if the text is the placeholder, then we hide placeholder
        if text == placeholder {
            hidePlaceholder()
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        // if the text inputted is empty, then we continue to show the placeholder assigned
        if text.isEmpty {
            showPlaceholder()
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        // continue to use the keyed-in text unless the user has pressed the return in keyboard
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        // trigger the delegate method when textView has changed.
        changeDelegate?.lrTextViewDidChange(textView as! LRTextView)
    }
}
