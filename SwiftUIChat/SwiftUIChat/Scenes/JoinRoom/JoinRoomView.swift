//
//  JoinRoomView.swift
//  SwiftUIChat
//
//  Created by Mohamed Shiha on 2/27/23.
//

import SwiftUI

struct JoinRoomView: View {
	
	@StateObject var chatroomViewModel = JoinRoomViewModel(manager: ChatRoomReciever())
	@State private var roomId = ""
	@State private var opensChat = false
	@State private var showsError = false
	
    var body: some View {
		VStack(spacing: 40) {
			
			Spacer()
				.frame(height: 100)
			
			Image(systemName: "message.fill")
				.font(.system(size: 56))
				.foregroundColor(.main)
				.padding()
				.background(
					RoundedRectangle(cornerRadius: 16)
						.fill(Color.main.opacity(0.2))
				)
			
			TextField("Room id", text: $roomId)
				.padding(.vertical)
				.padding(.horizontal, 24)
				.background(Color(UIColor.systemGray6))
				.clipShape(Capsule(style: .continuous))
				.frame(height: 48)
				.shadow(color: .main.opacity(0.3), radius: 16, y: 6)
			
			Button {
				
				Task {
					do {
						guard !roomId.isEmpty else { return }
						try await chatroomViewModel.join(roomId: roomId)
						withAnimation {
							opensChat = true
						}
					} catch {
						print(error.localizedDescription)
						showsError = true
					}
				}
				
			} label: {
				Text("JOIN ROOM")
					.font(.system(size: 16, weight: .bold))
					.foregroundColor(.white)
					.padding()
					.background {
						Capsule()
							.fill(Color.main)
					}
			}
			
			Spacer()
			
			if opensChat {
				NavigationLink(destination: ConversationView(viewModel: ConversationViewModel(roomId: chatroomViewModel.chatroom!.id, MessageProvider())),
							   isActive: $opensChat) { EmptyView() }
			}
		}
		.padding(.horizontal)
		.alert("Unable to join the room.", isPresented: $showsError) {
			Button("OK", role: .cancel) { }
		}
    }
}

struct JoinRoomView_Previews: PreviewProvider {
    static var previews: some View {
        JoinRoomView()
    }
}
