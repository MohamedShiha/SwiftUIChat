//
//  ChatRoomManager.swift
//  SwiftUIChat
//
//  Created by Korashi on 25/01/2023.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

/// Enables an object to be managed by some other entity
protocol Managable {
    
    /// The type of the managed object
    associatedtype Managed
        
    /// Create the object for a limited duration in **minutes** in a remote env
    /// - Parameter duration: The lifetime duration of the room in **minutes**
    /// - Returns: the managed object in case of successful creation.
    func create(for duration: Int) async -> Managed?
    
    /// Deletes the managed object in a remote env
    /// - Returns: true if the room is deleted successfully.
    func delete() async -> Bool
}

final class ChatRoomManager: Managable {
        
    typealias Managed = ChatRoom
    
    private let firestore = Firestore.firestore()
    private var rooms: CollectionReference {
        return firestore.collection("chat-rooms")
    }
    
    func create(for duration: Int) async -> ChatRoom? {
        let room = ChatRoom(durationInMinutes: duration)
        guard let snapshot = try? await rooms.document(room.id).getDocument() else { return nil }
        guard !snapshot.exists else { return nil }
        do {
            try rooms.document(room.id).setData(from: room)
            return room
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func delete() async -> Bool {
        return false
    }
}
