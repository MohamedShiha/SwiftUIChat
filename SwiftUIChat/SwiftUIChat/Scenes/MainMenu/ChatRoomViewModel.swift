//
//  ChatRoomViewModel.swift
//  SwiftUIChat
//
//  Created by Korashi on 25/01/2023.
//

import Foundation

final class ChatRoomViewModel: ObservableObject {
    
    private let manager: any Managable
    
    init(manager: some Managable) {
        self.manager = manager
    }
    
    /// Start a chat room for a specific duration in **minutes**.
    func start(forDuration duration: Int) async {
        let room = await manager.create(for: duration) as? ChatRoom
        if let room {
            print(room.description)
        } else {
            print("Error Creating Room in Firestore.")
        }
    }
    
    func delete() async {
        print("Delete Room!")
    }
}
