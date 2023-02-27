//
//  BaseMessageCell.swift
//  SwiftUIChat
//
//  Created by Korashi on 22/01/2023.
//

import SwiftUI

/// A container for a message component
struct BaseMessageCell<Content: View>: View {
    
    let forwardType: ForwardType
    let time: String
    let mainColor: Color
    let label: () -> Content
    
    @State private var showsTime = false
    
    /**
     Creates a message container with the specified body
     
     - Parameter forwardType: determines whether the view is associated with a sender or a reciever.
     - Parameter time: time when the message was sent.
     - Parameter mainColor: sender's message bubble fill color.
     - Parameter label: message bubble body.

     - Returns: A message container containing the preferred message body.
     */
    init(forwardType: ForwardType, time: String, mainColor: Color, label: @escaping () -> Content) {
        self.forwardType = forwardType
        self.time = time
        self.mainColor = mainColor
        self.label = label
    }
    
    var messageBubble: some View {
        label()
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(forwardType == .sender ? mainColor : Color(uiColor: .systemFill))
            )
            .frame(width: UIScreen.main.bounds.width * 0.75, alignment: forwardType == .sender ? .trailing : .leading)
            .padding(.horizontal)
            .onTapGesture {
                withAnimation(.spring()) {
                    showsTime.toggle()
                }
            }
    }
    
    var timeTitle: some View {
        Text(time)
            .font(.system(size: 14))
            .foregroundColor(Color(uiColor: .secondaryLabel))
            .transition(.opacity)
            .padding(.horizontal, 24)
    }
    
    var container: some View {
        VStack(alignment: forwardType == .sender ? .trailing : .leading) {
            messageBubble
            if showsTime {
                timeTitle
            }
        }
    }
    
    var body: some View {
        HStack(alignment: .lastTextBaseline) {
            if forwardType == .sender {
                Spacer()
                container
            } else {
                container
                Spacer()
            }
        }
    }
}
