//
//  MessageProvider.swift
//  SwiftUIChat
//
//  Created by Korashi on 25/01/2023.
//

import Foundation
import FirebaseFirestore

class MessageProvider: MessageProviding {
    
    typealias T = Message
	var listener: ListenerRegistration?
	
    private var roomsCollection: CollectionReference {
        Firestore.firestore().collection("chat-rooms")
    }
    
    func send(_ value: Message, to roomId: String) async throws {
        let ref = roomsCollection.document(roomId)
		let data = try JSONEncoder().encode(value)
		let json = try JSONSerialization.jsonObject(with: data)
        let fields = [ChatRoom.Codingkeys.thread.rawValue : FieldValue.arrayUnion([json])]
        try await ref.updateData(fields)
    }
	
	func listen(from roomId: String) -> AsyncStream<Message> {
		return AsyncStream(Message.self) { continuation in
			self.listener = roomsCollection.document(roomId).addSnapshotListener { snapshot, error in
				guard error == nil else {
					print(error!.localizedDescription)
					return
				}
				
				guard let snapshot, snapshot.exists else { return }
				
				do {
					let room = try snapshot.data(as: ChatRoom.self)
					guard let last = room.thread.last else { return }
					continuation.yield(last)
				} catch {
					print(error.localizedDescription)
				}
			}
			continuation.onTermination = { [weak self] _ in
				print("➡️➡️➡️ Continuation Terminated")
				self?.stopListening()
			}
		}
    }
	
	func stopListening() {
		listener?.remove()
		listener = nil
	}
}
