//
//  JoinRoomViewModel.swift
//  SwiftUIChat
//
//  Created by Mohamed Shiha on 2/27/23.
//

import Foundation

@MainActor final class JoinRoomViewModel: ObservableObject {
	
	let manager: any ChatRoomJoinable
	@Published var chatroom: ChatRoom? = nil
	
	init(manager: some ChatRoomJoinable) {
		self.manager = manager
	}
	
	func join(roomId: String) async throws {
		self.chatroom = try await manager.get(roomId: roomId)
	}
}
