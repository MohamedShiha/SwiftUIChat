//
//  SwiftUIChatApp.swift
//  SwiftUIChat
//
//  Created by Korashi on 22/01/2023.
//

import SwiftUI

private let START_AS_HOST = true

var CURRENT_USER: User {
	if START_AS_HOST {
		// Sender
		return User(id: "32B2C22D-C680-482C-B3AB-3DB4D04BA096", name: "Mohamed Shiha", avatar: nil)
	}
	// Reciever
	return User(id: "32BABE2D-CAW0-48C5-A12B-AEB4D12BA096", name: "Morsy Soker", avatar: nil)
}

@main
struct SwiftUIChatApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
	    
    var body: some Scene {
        WindowGroup {
            NavigationView {
				if START_AS_HOST {
					MainMenu()
				} else {
					JoinRoomView()
				}
            }
        }
    }
}

extension Color {
	static let main = Color.accentColor
}
