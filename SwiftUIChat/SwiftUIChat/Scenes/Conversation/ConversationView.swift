//
//  ConversationView.swift
//  SwiftUIChat
//
//  Created by Korashi on 23/01/2023.
//

import SwiftUI

struct ConversationView: View {
	
    @FocusState private var isGoingToType: Bool
	@StateObject private var viewModel: ConversationViewModel
	@Environment(\.dismiss) var dismiss
	
	init(viewModel: ConversationViewModel) {
		self._viewModel = StateObject(wrappedValue: viewModel)
	}
	
    @ViewBuilder
    var conversationList: some View {
		if !viewModel.thread.isEmpty {
			ScrollView {
				ForEach(viewModel.thread) { message in
					switch message.body {
					case .text(let text):
						TextMessage(text: text,
									forwardType: message.sender.id == CURRENT_USER.id ? .sender : .reciever,
									time: Date(timeIntervalSince1970: TimeInterval(message.createAt)).timeFormatted(),
									mainColor: .main)
						.id(message.id)
					default:
						EmptyView()
					}
				}
				.padding(.vertical)
			}
			.navigationBarHidden(true)
        } else {
            emptyConversationView
				.navigationBarHidden(true)
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
			ScrollViewReader { proxy in
				conversationList
					.onChange(of: viewModel.thread.count) { _ in
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
				MessageToolBar(text: $viewModel.text, actionColor: .main, onSend: {
					Task {
						await viewModel.sendTextMessage()
						self.scrollToBottom(scrollProxy: proxy)
					}
				})
				.focused($isGoingToType, equals: true)
			}
        }
		.onAppear {
			Task {
				do {
					try await viewModel.startListening()
				} catch {
					dismiss()
				}
			}
		}
		.onDisappear {
			viewModel.stopListeningToMessages()
		}
        .onTapGesture {
			dismissKeyboard()
        }
    }
    
    private func scrollToBottom(scrollProxy: ScrollViewProxy) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            withAnimation(.easeInOut) {
				scrollProxy.scrollTo(viewModel.thread.last?.id, anchor: UnitPoint(x: 1, y: 0.95))
            }
        }
    }
	
	private func dismissKeyboard() {
		UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
		isGoingToType = false
	}
}
