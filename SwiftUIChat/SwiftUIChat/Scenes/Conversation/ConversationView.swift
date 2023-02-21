//
//  ConversationView.swift
//  SwiftUIChat
//
//  Created by Korashi on 23/01/2023.
//

import SwiftUI

struct DummyMessage: Identifiable {
    let id = UUID().uuidString
    let text: String
    let time: String
    let forwardType: ForwardType
}

struct ConversationView: View {
    
    @State private var text = ""
    @FocusState private var isGoingToType: Bool
    @State var messageList: [DummyMessage] = [
        DummyMessage(text: "Hi Morsy, how you?", time: "1:12", forwardType: .sender),
        DummyMessage(text: "Thank you for your order!", time: "1:12", forwardType: .sender),
        DummyMessage(text: "Meow", time: "1:12", forwardType: .reciever),
        DummyMessage(text: "Meow", time: "1:12", forwardType: .sender),
        DummyMessage(text: "Meow", time: "1:12", forwardType: .reciever),
        DummyMessage(text: "Meow", time: "1:12", forwardType: .sender),
        DummyMessage(text: "Meow", time: "1:12", forwardType: .reciever),
        DummyMessage(text: "Meow", time: "1:12", forwardType: .sender),
        DummyMessage(text: "Meow", time: "1:12", forwardType: .reciever),
        DummyMessage(text: "Meow", time: "1:12", forwardType: .reciever),
        DummyMessage(text: "Meow", time: "1:12", forwardType: .sender),
        DummyMessage(text: "Meow", time: "1:12", forwardType: .reciever),
        DummyMessage(text: "Meow", time: "1:12", forwardType: .sender),
        DummyMessage(text: "Meow", time: "1:12", forwardType: .reciever)
    ]
    
    
    @ViewBuilder
    var conversationList: some View {
        if !messageList.isEmpty {
            ScrollViewReader { proxy in
                ScrollView {
                    ForEach(messageList) {
                        TextMessage(text: $0.text, forwardType: $0.forwardType, time: $0.time, mainColor: .main)
                            .id($0.id)
                    }
                    .padding(.vertical)
                    .onChange(of: messageList.count) { _ in
                        self.scrollToBottom(scrollProxy: proxy)
                    }
                    .onChange(of: isGoingToType) { newValue in
                        if newValue {
                            self.scrollToBottom(scrollProxy: proxy)
                        }
                    }
                    .onAppear {
                        self.scrollToBottom(scrollProxy: proxy)
                    }
                }
            }
        } else {
            emptyConversationView
        }
    }
    
    var emptyConversationView: some View {
        Rectangle()
            .fill(Color.white)
            .overlay {
                Text("No Messages Yet!")
                    .font(.system(size: 30, weight: .bold))
            }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ConversationHeaderView(avatar: Image("avatar"), name: "Morsy Soker", accentColor: .main) {
                print("Back")
            }
            conversationList
            MessageToolBar(text: $text, actionColor: .main, onSend: {
                print("Send")
                sendDummyMessage()
            })
            .focused($isGoingToType, equals: true)
        }
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            isGoingToType = false
        }
    }
    
    func scrollToBottom(scrollProxy: ScrollViewProxy) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            withAnimation(.easeInOut) {
                scrollProxy.scrollTo(messageList.last?.id, anchor: UnitPoint(x: 1, y: 0.95))
            }
        }
    }
    
    func sendDummyMessage() {
        guard !text.isEmpty else { return }
        let random = (0...1).randomElement() ?? 0
        messageList.append(DummyMessage(text: text, time: "10:16", forwardType: random == 0 ? .sender : .reciever))
        text = ""
    }
}

struct ConversationView_Previews: PreviewProvider {
    static var previews: some View {
        ConversationView()
    }
}
