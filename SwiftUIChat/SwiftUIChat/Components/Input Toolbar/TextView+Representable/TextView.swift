//
//  TextView.swift
//  SwiftUIChat
//
//  Created by Korashi on 23/01/2023.
//

import SwiftUI

/// Multiline SwiftUI TextView
struct TextView: UIViewRepresentable {
    
    typealias UIViewType = UITextView
    
    @Binding var text: String
    @Binding var height: Double
    let padding: UIEdgeInsets
    let placeholder: String
    let foregroundColor: UIColor
    let backgroundColor: UIColor
    let cursorColor: UIColor
    let onTextChange: ((String) -> Void)?
    let onChangeBegin: (() -> Void)?
    let onChangeEnd: (() -> Void)?
    
    /**
     Creates a representable UITextView
     
     - Parameter text: text within the textview.
     - Parameter height: container height.
     - Parameter placeholder: a text that appears in case of empty text.
     - Parameter padding: text container padding.
     - Parameter foregroundColor: text color.
     - Parameter cursorColor: editing cursor color..
     - Parameter backgroundColor: container color.
     - Parameter onTextChange: completion handler that fires everytime the text is changed.
     - Parameter onChangeBegin: completion handler that fires everytime the editing begins.
     - Parameter onChangeEnd: completion handler that fires everytime the editing ends.

     - Returns: UITextView that can be used as a SwiftUI view.
     */
    init(_ text: Binding<String>,
         height: Binding<Double>,
         placeholder: String,
         padding: EdgeInsets = .init(top: 4, leading: 12, bottom: 4, trailing: 12),
         foregroundColor: UIColor = .label,
         backgroundColor: UIColor = .systemBackground,
         cursorColor: UIColor = .tintColor,
         onTextChange: ((String) -> Void)? = nil,
         onChangeBegin: (() -> Void)? = nil,
         onChangeEnd: (() -> Void)? = nil) {
        
        self._text = text
        self._height = height
        self.padding = UIEdgeInsets(top: padding.top, left: padding.leading, bottom: padding.bottom, right: padding.trailing)
        self.placeholder = placeholder
        self.foregroundColor = foregroundColor
        self.backgroundColor = backgroundColor
        self.cursorColor = cursorColor
        self.onTextChange = onTextChange
        self.onChangeBegin = onChangeBegin
        self.onChangeEnd = onChangeEnd
    }
    
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.text = placeholder
        textView.contentInset = padding
        textView.textColor = .placeholderText
        textView.backgroundColor = backgroundColor
        textView.font = .systemFont(ofSize: 17)
        textView.showsVerticalScrollIndicator = false
        textView.showsHorizontalScrollIndicator = false
        textView.tintColor = cursorColor
        textView.delegate = context.coordinator
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        
        uiView.bounds.size = CGSize(width: uiView.bounds.size.width, height: height)
        if height > 50 {
            UIView.animate(withDuration: 0.2) {
                uiView.layer.cornerRadius = 12
            }
        } else {
            UIView.animate(withDuration: 0.2) {
                uiView.layer.cornerRadius = uiView.bounds.height / 2
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(text: $text,
                    height: $height,
                    placeholder: placeholder,
                    foregroundColor: foregroundColor,
                    onTextChange: onTextChange,
                    onChangeBegin: onChangeBegin,
                    onChangeEnd: onChangeEnd)
    }
    
    /// The coordinator between UITextView and UITextViewDelegate
    class Coordinator: NSObject, UITextViewDelegate {
        
        @Binding var text: String
        @Binding var height: Double
        let placeholder: String
        let foregroundColor: UIColor
        let onTextChange: ((String) -> Void)?
        let onChangeBegin: (() -> Void)?
        let onChangeEnd: (() -> Void)?

        private let placeholderColor = UIColor.placeholderText
        private var minHeight: CGFloat = 40
        private var maxHeight: CGFloat = 88
        
        /**
         Creates a coordinator that manages UITextViewDelegate
         
         - Parameter text: text within the textview.
         - Parameter height: container height.
         - Parameter placeholder: a text that appears in case of empty text.
         - Parameter foregroundColor: text color.
         - Parameter onTextChange: completion handler that fires everytime the text is changed.
         - Parameter onChangeBegin: completion handler that fires everytime the editing begins.
         - Parameter onChangeEnd: completion handler that fires everytime the editing ends.

         - Returns: A coordinator between UITextView and UITextViewDelegate.
         */
        init(text: Binding<String>,
             height: Binding<Double>,
             placeholder: String,
             foregroundColor: UIColor,
             onTextChange: ((String) -> Void)? = nil,
             onChangeBegin: (() -> Void)? = nil,
             onChangeEnd: (() -> Void)? = nil) {
            self._text = text
            self._height = height
            self.placeholder = placeholder
            self.foregroundColor = foregroundColor
            self.onTextChange = onTextChange
            self.onChangeBegin = onChangeBegin
            self.onChangeEnd = onChangeEnd
        }
        
        func textViewDidChange(_ textView: UITextView) {
           
            text = textView.text
            height = minHeight
            
            if textView.contentSize.height <= minHeight {
                height = minHeight
            } else if textView.contentSize.height >= maxHeight {
                height = maxHeight
            } else {
                height = textView.contentSize.height
            }
            
            textView.scrollToBottom()
            onTextChange?(textView.text)
        }
        
        func textViewDidBeginEditing(_ textView: UITextView) {
            if textView.text == placeholder || textView.textColor == placeholderColor {
                textView.text = ""
                textView.textColor = foregroundColor
            }
            onChangeBegin?()
        }
        
        func textViewDidEndEditing(_ textView: UITextView) {
            if textView.text.isEmpty {
                textView.text = placeholder
                textView.textColor = placeholderColor
            }
            onChangeEnd?()
        }
    }
}
