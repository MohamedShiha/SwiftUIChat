//
//  User.swift
//  SwiftUIChat
//
//  Created by Korashi on 25/01/2023.
//

import Foundation

struct User: Identifiable, Codable {
    
    let id: String
    let name: String
    let avatar: String?
    
    /**
     Represents a user that is either a sender or a reciever.
     
     - Parameter id: an id can be a uuid, fcm or any generic id.
     - Parameter name: display name.
     - Parameter avatar: avatar url.
     
     A user may or may not have an avatar.
     
     - Returns: A user with the specified info
     */
    init(id: String, name: String, avatar: String?) {
        self.id = id
        self.name = name
        self.avatar = avatar
    }
    
	/// Keys for encoding and decoding data.
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case avatar = "avatar"
    }
}
