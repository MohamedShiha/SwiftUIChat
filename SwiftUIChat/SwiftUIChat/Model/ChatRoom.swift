//
//  ChatRoom.swift
//  SwiftUIChat
//
//  Created by Korashi on 25/01/2023.
//

import Foundation

struct ChatRoom: Identifiable, Codable {
    
    let id: String
    /// messages container.
    let thread: Array<Message>
    /// timestamp in seconds since 1970 when the room is created.
    let createdAt: Int
    /// timestamp from the creation date to the givem Date in seconds
    let ttl: Int
    
	/// Keys for encoding and decoding data.
    enum Codingkeys: String, CodingKey {
        case id = "id"
        case thread = "thread"
        case createdAt = "createdAt"
        case ttl = "ttl"
    }
    
    /**
     Creates a chat room containing the conversation
     
     - Parameter thread: A list of messages between the sender and reciever.
     - Parameter durationInMinutes: The lifetime duration of the room in **minutes**
     
     - Returns: A chat room with an empty
     */
    init(thread: Array<Message> = [], durationInMinutes minutes: Int) {
        self.id = UUID().uuidString
        self.thread = thread
        self.createdAt = Int(Date().timeIntervalSince1970)
        self.ttl = minutes * 60
    }
    
    /**
     Creates a chat room containing the conversation
     
     - Parameter thread: A list of messages between the sender and reciever.
     - Parameter ttl: **time-to-live** in seconds = DueDate - Now.
     
     - Returns: A chat room
     */
    init(thread: Array<Message> = [], ttl: Int) {
        self.id = UUID().uuidString
        self.thread = thread
        self.createdAt = Int(Date().timeIntervalSince1970)
        self.ttl = ttl
    }
}

extension ChatRoom: CustomStringConvertible {
    var description: String {
        return """
            Chatroom: {
                id: \(id)
                thread containing \(thread.count) of messages.
                created at: \(createdAt)
                time to live stamp (ttl): \(ttl)
            }
        """
    }
}
