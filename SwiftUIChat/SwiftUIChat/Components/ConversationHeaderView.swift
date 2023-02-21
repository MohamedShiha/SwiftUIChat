//
//  ConversationHeaderView.swift
//  SwiftUIChat
//
//  Created by Korashi on 23/01/2023.
//

import SwiftUI

struct ConversationHeaderView: View {
    
    let avatar: Image
    let name: String
    let accentColor: Color
    let onBackTapped: () -> Void
    
    @Environment(\.dismiss) private var dismiss
    
    /**
     Creates a conversation header container reciever's information
     
     - Parameter avatar: reciever's profile picture.
     - Parameter name: reciever's username.
     - Parameter accentColor: header's background color.
     - Parameter onBackTapped: a completion handle that fires whenever the back button is tapped.

     - Returns: A conversation header with the specified user information
     */
    init(avatar: Image, name: String, accentColor: Color, onBackTapped: @escaping () -> Void) {
        self.avatar = avatar
        self.name = name
        self.accentColor = accentColor
        self.onBackTapped = onBackTapped
    }
    
    /// Profile avatar and name
    var recieverProfile: some View {
        HStack {
            avatar
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 48)
                .mask(Circle())
                .padding(4)
                .background(
                    Circle()
                        .opacity(0.5)
                )
            Text(name)
                .lineLimit(1)
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .minimumScaleFactor(0.65)
        }
    }
    
    var body: some View {
        HStack(spacing: 16) {
            Button {
                dismiss()
                onBackTapped()
            } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 24, weight: .semibold, design: .rounded))
            }
            recieverProfile
            Spacer()
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .foregroundColor(Color(uiColor: .systemBackground).opacity(0.9))
        .background(
            accentColor.opacity(0.85)
                .shadow(color: .black.opacity(0.2), radius: 16, y: 8)
                .background(Material.ultraThinMaterial)
            .edgesIgnoringSafeArea(.all)
        )
    }
}
