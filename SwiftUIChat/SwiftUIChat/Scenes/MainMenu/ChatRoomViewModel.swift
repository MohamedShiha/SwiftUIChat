//
//  ChatRoomViewModel.swift
//  SwiftUIChat
//
//  Created by Korashi on 25/01/2023.
//

import Foundation

@MainActor final class ChatRoomViewModel: ObservableObject {
    
    private let manager: any ChatRoomManaging
	@Published var chatroom: ChatRoom? = nil
    
    init(manager: some ChatRoomManaging) {
        self.manager = manager
    }
    
    /// Initiate a chat room
    func initiate() async {
		let room = await manager.initiate()
        if let room {
            print(room.description)
			self.chatroom = room
        } else {
            fatalError("Error Creating Room in Firestore.")
        }
    }
    
	func delete() async -> Bool {
		guard let chatroom else {
			return false
		}
		do {
			try await manager.delete(managed: chatroom)
			return true
		} catch {
			return false
		}
    }
}
