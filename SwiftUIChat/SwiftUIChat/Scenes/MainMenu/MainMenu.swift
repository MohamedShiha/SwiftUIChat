//
//  MainMenu.swift
//  SwiftUIChat
//
//  Created by Korashi on 25/01/2023.
//

import SwiftUI

struct MainMenu: View {
    
    @StateObject var chatroomViewModel = ChatRoomViewModel(manager: ChatRoomManager())
    private let roomDurationInMinutes = 30
    @State private var opensChat = false
    
    var body: some View {
        Button {
            Task {
                await chatroomViewModel.start(forDuration: roomDurationInMinutes)
                withAnimation {
                    opensChat = true
                }
            }
        } label: {
            Text("Start chatting 💬")
                .font(.system(size: 22, weight: .semibold))
                .padding()
                .foregroundColor(.white)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.main)
                )
        }
    }
}

struct MainMenu_Previews: PreviewProvider {
    static var previews: some View {
        MainMenu()
    }
}
