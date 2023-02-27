//
//  Managable.swift
//  SwiftUIChat
//
//  Created by Mohamed Shiha on 2/22/23.
//

import Foundation

/// Enables an object to be managed by some other entity
protocol Managing {
	
	/// The type of the managed object
	associatedtype Managed: Identifiable
	
	 /// Initiates an object based on its presence/existence in a remote env.
	 /// - Returns: The managed object in case of successful initiation.
	func initiate() async -> Managed?
	
	/// Create the object for a limited duration in **minutes** in a remote env.
	/// - Parameter duration: The lifetime duration of the object in **minutes**
	/// - Returns: The managed object in case of successful creation.
	func create(for duration: Int) async -> Managed?
	
	/// Gets a managed object from a remote env.
	/// - Parameter managedId: The identifier of the managed object
	/// - Returns: The managed object if it exists in the remote env.
	func get(managedId: String) async -> Managed?
	
	/// Deletes the managed object in a remote env.
	/// - Parameter managed: The managed object to be deleted
	/// - Returns: True if the object is deleted successfully.
	func delete(managed: Managed) async throws
}

/// Enables a chatroom to be managed by some other entity
protocol ChatRoomManaging: Managing where Managed == ChatRoom { }
