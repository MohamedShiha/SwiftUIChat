//
//  SwiftUIChatApp.swift
//  SwiftUIChat
//
//  Created by Korashi on 22/01/2023.
//

import SwiftUI

let currentUser = User(id: "32B2C22D-C680-482C-B3AB-3DB4D04BA096", name: "Mohamed Shiha", avatar: nil)

@main
struct SwiftUIChatApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                MainMenu()
            }
        }
    }
}

extension Color {
	static let main = Color.accentColor
}
