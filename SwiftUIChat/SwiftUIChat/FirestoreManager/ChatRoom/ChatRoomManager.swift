//
//  ChatRoomManager.swift
//  SwiftUIChat
//
//  Created by Korashi on 25/01/2023.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

final class ChatRoomManager: ChatRoomManagable {
        
    typealias Managed = ChatRoom
    
    private let firestore = Firestore.firestore()
    private var rooms: CollectionReference {
        return firestore.collection("chat-rooms")
    }
    
    func create(for duration: Int) async -> ChatRoom? {
        let room = ChatRoom(durationInMinutes: duration)
        do {
            try rooms.document(room.id).setData(from: room)
            return room
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
	func delete(managed room: Managed) async -> Bool {
		do {
			try await rooms.document(room.id).delete()
			return true
		} catch {
			print(error.localizedDescription)
			return false
		}
    }
}
