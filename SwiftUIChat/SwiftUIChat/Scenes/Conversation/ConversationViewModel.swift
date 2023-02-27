//
//  ConversationViewModel.swift
//  SwiftUIChat
//
//  Created by Korashi on 06/02/2023.
//

import Foundation

@MainActor final class ConversationViewModel: ObservableObject {
    
    private let manager: any MessageProviding
	private let roomId: String
	@Published var thread = Array<Message>()
	@Published var text = ""
    
	init(roomId: String, _ manager: some MessageProviding) {
		self.roomId = roomId
        self.manager = manager
		Task {
			thread = await manager.fetch(from: roomId)
		}
    }
	
	deinit {
		stopListeningToMessages()
	}
	
	func sendTextMessage() async {
		guard !text.isEmpty else { return }
		let message = Message(body: .text(text), sender: CURRENT_USER)
		do {
			try await manager.send(message, to: roomId)
			self.text = ""
		} catch {
			print(error.localizedDescription)
		}
    }
	
	func startListening() async {
		// Remove the last element as it is later added again when the listener works.
		if !thread.isEmpty {
			thread.removeLast()
		}
		await listenToMessages()
	}
	
	private func listenToMessages() async {
		for await message in manager.listen(from: roomId) {
			thread.append(message)
			text = ""
		}
	}
	
	nonisolated func stopListeningToMessages() {
		manager.stopListening()
	}
}
