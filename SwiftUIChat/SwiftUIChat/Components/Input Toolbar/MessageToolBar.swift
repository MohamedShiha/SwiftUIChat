//
//  MessageToolBar.swift
//  SwiftUIChat
//
//  Created by Korashi on 22/01/2023.
//

import SwiftUI

struct MessageToolBar: View {
    
    @State private var height: Double = 44
    @Binding var text: String
    let actionColor: Color
    let onSend: () -> Void
    
    var body: some View {
        HStack {
            TextView($text, height: $height, placeholder: "Message", backgroundColor: .secondarySystemBackground, cursorColor: UIColor(actionColor))
                .frame(height: height)
            Button {
                onSend()
				height = 44
            } label: {
                Image(systemName: "paperplane.fill")
                    .font(.system(size: 20))
                    .foregroundColor(actionColor)
            }
        }
        .padding(16)
        .background(
            Color.white
                .shadow(color: .black.opacity(0.1), radius: 16)
                .edgesIgnoringSafeArea(.all)
        )
    }
}
