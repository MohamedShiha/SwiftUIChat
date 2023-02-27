//
//  Joinable.swift
//  SwiftUIChat
//
//  Created by Mohamed Shiha on 2/27/23.
//

import Foundation

protocol Joinable {
	/// A type represting the room that can be joined by a client
	associatedtype Room: Identifiable
	/// Gets the room to be joined
	/// - Parameter roomId: The id associated with the room
	/// - Returns: A room to be joined if it exists.
	func get(roomId: Room.ID) async throws -> Room?
}

/// Enables a client to join a specific chat room.
protocol ChatRoomJoinable: Joinable where Room == ChatRoom {  }
