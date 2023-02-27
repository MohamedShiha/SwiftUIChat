//
//  Identifiable+Extensions.swift
//  SwiftUIChat
//
//  Created by Mohamed Shiha on 2/26/23.
//

import Foundation

extension Identifiable {
	
	/// Saves object id in UserDefaults keyed by the class name.
	/// Intended to statically save an object of only one key (which is class name)
	func persistId() {
		UserDefaults.standard.set(self.id, forKey: "ManagedRoom")
	}
	
	/// Fetches the id associated with the class name from UserDefaults
	/// - Returns: a nullable string representing object id.
	static func fetchId() -> String? {
		UserDefaults.standard.string(forKey: "ManagedRoom")
	}
	
	/// Removes object id from UserDefaults.
	func deleteId() {
		UserDefaults.standard.removeObject(forKey: "ManagedRoom")
	}
}
