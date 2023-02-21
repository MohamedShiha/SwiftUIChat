//
//  Message.swift
//  SwiftUIChat
//
//  Created by Korashi on 25/01/2023.
//

import Foundation

struct Message: Identifiable, Codable {
    
    /// message id
    let id: String
    /// message type associated with its value.
    let body: MessageType
    /// message sender
    let sender: User
    /// timestamp since 1970 in seconds.
    let createAt: Int

    /**
     Represents a user that is either a sender or a reciever.
     
     - Parameter id: message id.
     - Parameter name: .
     - Parameter avatar: User's avatar url.
     
     - Returns: A chat room with an empty
     */
    init(id: String, body: MessageType, sender: User) {
        self.id = id
        self.body = body
        self.sender = sender
        self.createAt = Int(Date().timeIntervalSince1970)
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case body = "body"
        case sender = "sender"
        case createAt = "createAt"
    }
}
