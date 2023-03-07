//
//  TextView.swift
//  SwiftUIChat
//
//  Created by Korashi on 23/01/2023.
//

import SwiftUI

/// Multiline SwiftUI TextView with a placeholder
struct TextView: View {

	@Binding var text: String
	@Binding var height: Double
	let placeholder: String
	let padding: EdgeInsets
	let foregroundColor: UIColor
	let backgroundColor: UIColor
	let cursorColor: UIColor
	let onTextChange: ((String) -> Void)?
	let onChangeBegin: (() -> Void)?
	let onChangeEnd: (() -> Void)?
	
	@FocusState private var isFocused: Bool
	
	init(_ text: Binding<String>,
		 height: Binding<Double>,
		 placeholder: String,
		 padding: EdgeInsets = .init(top: 5, leading: 12, bottom: 5, trailing: 12),
		 foregroundColor: UIColor = .label,
		 backgroundColor: UIColor = .systemBackground,
		 cursorColor: UIColor = .tintColor,
		 onTextChange: ((String) -> Void)? = nil,
		 onChangeBegin: (() -> Void)? = nil,
		 onChangeEnd: (() -> Void)? = nil) {
		
		self._text = text
		self._height = height
		self.placeholder = placeholder
		self.padding = padding
		self.foregroundColor = foregroundColor
		self.backgroundColor = backgroundColor
		self.cursorColor = cursorColor
		self.onTextChange = onTextChange
		self.onChangeBegin = onChangeBegin
		self.onChangeEnd = onChangeEnd
	}
	
	var body: some View {
		ZStack(alignment: .leading) {
			TextViewPresentation($text,
								 height: $height,
								 padding: padding,
								 foregroundColor: foregroundColor,
								 backgroundColor: backgroundColor,
								 cursorColor: cursorColor,
								 onTextChange: onTextChange,
								 onChangeBegin: onChangeBegin,
								 onChangeEnd: onChangeEnd)
			.focused($isFocused, equals: true)
			if text.isEmpty {
				Text(placeholder)
					.font(.system(size: 17))
					.foregroundColor(Color(uiColor: .placeholderText))
					.padding(.leading, padding.leading + 5)
					.offset(y: -1)
					.onTapGesture {
						isFocused = true
					}
			}
		}
	}
}

/// Multiline SwiftUI TextView
struct TextViewPresentation: UIViewRepresentable {
    
    typealias UIViewType = UITextView
    
    @Binding var text: String
    @Binding var height: Double
    let padding: UIEdgeInsets
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
         padding: EdgeInsets,
         foregroundColor: UIColor = .label,
         backgroundColor: UIColor = .systemBackground,
         cursorColor: UIColor = .tintColor,
         onTextChange: ((String) -> Void)? = nil,
         onChangeBegin: (() -> Void)? = nil,
         onChangeEnd: (() -> Void)? = nil) {
        
        self._text = text
        self._height = height
        self.padding = UIEdgeInsets(top: padding.top, left: padding.leading, bottom: padding.bottom, right: padding.trailing)
        self.foregroundColor = foregroundColor
        self.backgroundColor = backgroundColor
        self.cursorColor = cursorColor
        self.onTextChange = onTextChange
        self.onChangeBegin = onChangeBegin
        self.onChangeEnd = onChangeEnd
    }
    
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.contentInset = padding
        textView.textColor = .label
        textView.backgroundColor = backgroundColor
        textView.font = .systemFont(ofSize: 17)
        textView.showsVerticalScrollIndicator = false
        textView.showsHorizontalScrollIndicator = false
        textView.tintColor = cursorColor
        textView.delegate = context.coordinator
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        
		if text.isEmpty {
			uiView.text = text
		}
		
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
                    foregroundColor: foregroundColor,
                    onTextChange: onTextChange,
                    onChangeBegin: onChangeBegin,
                    onChangeEnd: onChangeEnd)
    }
    
    /// The coordinator between UITextView and UITextViewDelegate
    class Coordinator: NSObject, UITextViewDelegate {
        
        @Binding var text: String
        @Binding var height: Double
        let foregroundColor: UIColor
        let onTextChange: ((String) -> Void)?
        let onChangeBegin: (() -> Void)?
        let onChangeEnd: (() -> Void)?

        private var minHeight: CGFloat = 44
        private var maxHeight: CGFloat = 88
        
        /**
         Creates a coordinator that manages UITextViewDelegate
         
         - Parameter text: text within the textview.
         - Parameter height: container height.
         - Parameter foregroundColor: text color.
         - Parameter onTextChange: completion handler that fires everytime the text is changed.
         - Parameter onChangeBegin: completion handler that fires everytime the editing begins.
         - Parameter onChangeEnd: completion handler that fires everytime the editing ends.

         - Returns: A coordinator between UITextView and UITextViewDelegate.
         */
        init(text: Binding<String>,
             height: Binding<Double>,
             foregroundColor: UIColor,
             onTextChange: ((String) -> Void)? = nil,
             onChangeBegin: (() -> Void)? = nil,
             onChangeEnd: (() -> Void)? = nil) {
            self._text = text
            self._height = height
            self.foregroundColor = foregroundColor
            self.onTextChange = onTextChange
            self.onChangeBegin = onChangeBegin
            self.onChangeEnd = onChangeEnd
        }
        
        func textViewDidChange(_ textView: UITextView) {
           
            text = textView.text
            height = minHeight
            
            if textView.contentSize.height <= minHeight {
                height = minHeight + 2
            } else if textView.contentSize.height >= maxHeight {
                height = maxHeight
            } else {
                height = textView.contentSize.height
            }
            
            textView.scrollToBottom()
            onTextChange?(textView.text)
        }
        
        func textViewDidBeginEditing(_ textView: UITextView) {
            onChangeBegin?()
        }
        
        func textViewDidEndEditing(_ textView: UITextView) {
            onChangeEnd?()
        }
    }
}
