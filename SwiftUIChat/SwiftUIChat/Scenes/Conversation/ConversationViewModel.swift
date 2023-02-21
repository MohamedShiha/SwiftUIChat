//
//  ConversationViewModel.swift
//  SwiftUIChat
//
//  Created by Korashi on 06/02/2023.
//

import Foundation

final class ConversationViewModel: ObservableObject {
    
    private let manager: any Provider
    @Published var thread = Array<Message>()
    
    init(_ manager: some Provider) {
        self.manager = manager
    }
    
    func sendMessage(_ message: Message, to roomId: String) async {
        await manager.send(<#T##value: Provider.T##Provider.T#>, to: <#T##String#>)
    }
}
