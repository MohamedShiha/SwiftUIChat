//
//  SwiftUIChatApp.swift
//  SwiftUIChat
//
//  Created by Korashi on 22/01/2023.
//

import SwiftUI

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
    static let main = Color(red: 43 / 255, green: 41 / 255, blue: 121 / 255)
}
