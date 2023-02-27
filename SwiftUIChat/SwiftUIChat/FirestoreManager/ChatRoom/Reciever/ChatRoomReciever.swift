//
//  ChatRoomReciever.swift
//  SwiftUIChat
//
//  Created by Mohamed Shiha on 2/27/23.
//

import Foundation
import FirebaseFirestore

final class ChatRoomReciever: ChatRoomJoinable {
	
	typealias Room = ChatRoom
	
	private let firestore = Firestore.firestore()
	private var rooms: CollectionReference {
		return firestore.collection("chat-rooms")
	}
	
	func get(roomId: String) async throws -> ChatRoom? {
		return try await rooms.document(roomId).getDocument(as: ChatRoom.self)
	}
}
