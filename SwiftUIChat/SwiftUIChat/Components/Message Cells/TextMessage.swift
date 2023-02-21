//
//  TextMessage.swift
//  SwiftUIChat
//
//  Created by Korashi on 22/01/2023.
//

import SwiftUI

struct TextMessage: View {
    
    let text: String
    let forwardType: ForwardType
    let time: String
    let mainForeground: Color
    let mainColor: Color
    
    /**
     Creates a message container with the specified body
     
     - Parameter text: text contained within the message.
     - Parameter time: time when the message was sent.
     - Parameter forwardType: determines whether the view is associated with a sender or a reciever.
     - Parameter mainForeground: sender's text message foreground color..
     - Parameter mainColor: sender's message bubble fill color.

     - Returns: A text message with the specified colors.
     */
    init(text: String, forwardType: ForwardType, time: String, mainForeground: Color = .white, mainColor: Color) {
        self.text = text
        self.time = time
        self.forwardType = forwardType
        self.mainForeground = mainForeground
        self.mainColor = mainColor
    }
    
    var body: some View {
        BaseMessageCell(forwardType: forwardType, time: time, mainColor: mainColor) {
            Text(text)
                .foregroundColor(forwardType == .sender ? mainForeground : .primary)
        }
    }
}

struct TextMessageCell_Previews: PreviewProvider {
    static var previews: some View {
        TextMessage(text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.",
                        forwardType: .sender,
                        time: "10:13",
                        mainForeground: .white,
                        mainColor: .indigo
        )
        .padding(.horizontal, 8)
    }
}
