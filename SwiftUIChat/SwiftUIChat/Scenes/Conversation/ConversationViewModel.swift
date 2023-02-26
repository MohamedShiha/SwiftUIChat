//
//  ConversationViewModel.swift
//  SwiftUIChat
//
//  Created by Korashi on 06/02/2023.
//

import Foundation

@MainActor final class ConversationViewModel: ObservableObject {
    
    private let manager: any MessageProvidable
	private let roomId: String
	@Published var thread = Array<Message>()
	@Published var text = ""
    
	init(roomId: String, _ manager: some MessageProvidable) {
		self.roomId = roomId
        self.manager = manager
		Task {
			await listenToMessages()
		}
    }
	
	deinit {
		stopListeningToMessages()
	}
	
	func sendTextMessage() async {
		guard !text.isEmpty else { return }
		let message = Message(body: .text(text), sender: currentUser)
		do {
			try await manager.send(message, to: roomId)
			DispatchQueue.main.async {
				self.text = ""
			} 
		} catch {
			print(error.localizedDescription)
		}
    }
	
	func listenToMessages() async {
		for await message in manager.listen(from: roomId) {
			thread.append(message)
		}
	}
	
	nonisolated func stopListeningToMessages() {
		manager.stopListening()
	}
}
