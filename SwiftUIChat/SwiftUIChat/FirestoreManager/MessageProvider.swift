//
//  MessageProvider.swift
//  SwiftUIChat
//
//  Created by Korashi on 25/01/2023.
//

import Foundation
import FirebaseFirestore

protocol Provider {
    associatedtype T
    func send(_ value: T, to sourceId: String) async throws
    func retrieve(from sourceId: String) async -> Array<T>
    func listen(from sourceId: String) async -> Array<T>
}

class MessageProvider: Provider {
    
    typealias T = Message
    private var roomsCollection: CollectionReference {
        Firestore.firestore().collection("chat-rooms")
    }
    
    func send(_ value: Message, to roomId: String) async throws {
        let ref = roomsCollection.document(roomId)
        let fields = [ChatRoom.Codingkeys.thread.rawValue : FieldValue.arrayUnion([value])]
        try await ref.updateData(fields)
    }

    func retrieve(from roomId: String) async -> Array<Message> {
        let ref = roomsCollection.document(roomId)
        do {
            let room = try await ref.getDocument(as: ChatRoom.self)
            return room.thread
        } catch {
            print(error.localizedDescription)
            return Array<Message>()
        }
    }
    
    func listen(from roomId: String) async -> Array<Message> {
        return await withCheckedContinuation { continuation in
            let _ = roomsCollection.document(roomId).addSnapshotListener { snapshot, error in
                guard error == nil else {
                    print(error!.localizedDescription)
                    continuation.resume(returning: Array<Message>())
                    return
                }
                
                guard let snapshot, snapshot.exists else {
                    continuation.resume(returning: Array<Message>())
                    return
                }
                
                do {
                    let room = try snapshot.data(as: ChatRoom.self)
                    continuation.resume(returning: room.thread)
                } catch {
                    print(error.localizedDescription)
                    continuation.resume(returning: Array<Message>())
                }
                
            }
        }
    }
    
    
}
