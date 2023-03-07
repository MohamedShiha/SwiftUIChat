//
//  Provider.swift
//  SwiftUIChat
//
//  Created by Mohamed Shiha on 2/22/23.
//

import Foundation
import FirebaseFirestore

/// An abstraction of data provider from a remote source
protocol Providing {
	
	/// The type to be provided
	associatedtype T
	/**
	 Send or provide an object to a specific destination
	 
	 - Parameter value: A value to be provided
	 - Parameter sourceId: The id of the destination source
	 */
	func send(_ value: T, to sourceId: String) async throws
	
	/**
	 Listens for new data from some source.
	 
	 - Parameter sourceId: The id of the destination source
	 
	 - Returns: A stream of the retrieved objects.
	 */
	func listen(from sourceId: String) -> AsyncThrowingStream<T, Error>
	
	/**
	 Fetches latest data from the provider
	 
	 - Parameter sourceId: The id of the destination source
	 
	 - Returns: An array of the retrieved objects.
	 */
	func fetch(from sourceId: String) async -> Array<T>
	
	/// Stop listening for any incoming data.
	func stopListening()
}

/// An abstraction of a message provider from firestore
protocol MessageProviding: Providing where T == Message {
	/// Document listener for listening to any changes in firestore document.
	var listener: ListenerRegistration? { set get }
}
