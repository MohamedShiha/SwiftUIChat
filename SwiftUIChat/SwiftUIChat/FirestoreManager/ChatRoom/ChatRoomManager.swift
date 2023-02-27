//
//  ChatRoomManager.swift
//  SwiftUIChat
//
//  Created by Korashi on 25/01/2023.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

final class ChatRoomManager: ChatRoomManaging {
        
    typealias Managed = ChatRoom
    
    private let firestore = Firestore.firestore()
    private var rooms: CollectionReference {
        return firestore.collection("chat-rooms")
    }
	/// A hardcoded duration for a chat room in minutes
	private let DURATION = 30
	
	func initiate() async -> ChatRoom? {
		if let id = ChatRoom.fetchId() {
			guard let room = await get(managedId: id) else {
				return await create(for: DURATION)
			}
			let destroyDate = Date(timeIntervalSince1970: TimeInterval(room.createdAt + room.ttl))
			// Check if now the room is still alive?
			if Date() < destroyDate {
				// Room is still valid
				return room
			} else {
				// Room should be terminated
				try? await delete(managed: room)
				return await create(for: DURATION)
			}
		} else {
			return await create(for: DURATION)
		}
	}
	
	func get(managedId: String) async -> ChatRoom? {
		do {
			return try await rooms.document(managedId).getDocument(as: ChatRoom.self)
		} catch {
			print(error.localizedDescription)
			return nil
		}
	}
    
    func create(for duration: Int) async -> ChatRoom? {
        let room = ChatRoom(durationInMinutes: duration)
        do {
            try rooms.document(room.id).setData(from: room)
			room.persistId()
            return room
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
	func delete(managed room: Managed) async throws {
		room.deleteId()
		try await rooms.document(room.id).delete()
    }
}
