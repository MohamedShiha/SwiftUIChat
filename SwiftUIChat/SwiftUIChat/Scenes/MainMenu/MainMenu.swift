//
//  MainMenu.swift
//  SwiftUIChat
//
//  Created by Korashi on 25/01/2023.
//

import SwiftUI

struct MainMenu: View {
    
    @StateObject var chatroomViewModel = ChatRoomViewModel(manager: ChatRoomManager())
	/// A hardcoded duration for a chat room in minutes
    private let DURATION = 30
    @State private var opensChat = false
    
	var body: some View {
		ZStack {
			Button {
				Task {
					// Create a chat room
					await chatroomViewModel.start(forDuration: DURATION)
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
			
			// Navigate to conversation scene.
			if opensChat {
				NavigationLink(destination: ConversationView(viewModel: ConversationViewModel(roomId: chatroomViewModel.chatroom!.id, MessageProvider())),
							   isActive: $opensChat) { EmptyView() }
			}
		}
    }
}

struct MainMenu_Previews: PreviewProvider {
    static var previews: some View {
        MainMenu()
    }
}
