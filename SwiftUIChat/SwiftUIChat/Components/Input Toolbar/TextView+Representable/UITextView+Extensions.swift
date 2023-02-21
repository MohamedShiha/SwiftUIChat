//
//  UITextView+Extensions.swift
//  SwiftUIChat
//
//  Created by Korashi on 23/01/2023.
//

import UIKit

// MARK: - UITextView Extensions

extension UITextView {
    
    func scrollToTop() {
        scrollRangeToVisible(NSRange(location: 0, length: 0))
    }
    
    func scrollToBottom() {
        let textCount: Int = text.count
        guard textCount >= 1 else { return }
        scrollRangeToVisible(NSRange(location: textCount - 1, length: 1))
    }
}
