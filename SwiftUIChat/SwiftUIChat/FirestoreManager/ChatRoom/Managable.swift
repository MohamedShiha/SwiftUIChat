//
//  Managable.swift
//  SwiftUIChat
//
//  Created by Mohamed Shiha on 2/22/23.
//

import Foundation

/// Enables an object to be managed by some other entity
protocol Managable {
	
	/// The type of the managed object
	associatedtype Managed
	
	/// Create the object for a limited duration in **minutes** in a remote env
	/// - Parameter duration: The lifetime duration of the object in **minutes**
	/// - Returns: the managed object in case of successful creation.
	func create(for duration: Int) async -> Managed?
	
	/// Deletes the managed object in a remote
	/// - Parameter managed: The managed object to be deleted
	/// - Returns: true if the object is deleted successfully.
	func delete(managed: Managed) async -> Bool
}

/// Enables an chatrooms to be managed by some other entity
protocol ChatRoomManagable: Managable where Managed == ChatRoom {
//	var chatroom: Managed? { get set }
}
