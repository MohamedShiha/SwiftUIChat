//
//  ChatRoomViewModel.swift
//  SwiftUIChat
//
//  Created by Korashi on 25/01/2023.
//

import Foundation

@MainActor final class ChatRoomViewModel: ObservableObject {
    
    private let manager: any ChatRoomManagable
	@Published var chatroom: ChatRoom? = nil
    
    init(manager: some ChatRoomManagable) {
        self.manager = manager
    }
    
    /// Start a chat room for a specific duration in **minutes**.
    func start(forDuration duration: Int) async { 
		let room = await manager.create(for: duration)
        if let room {
            print(room.description)
			self.chatroom = room
        } else {
            print("Error Creating Room in Firestore.")
        }
    }
    
	func delete() async -> Bool {
		guard let chatroom else {
			return false
		}
		return await manager.delete(managed: chatroom)
    }
}
