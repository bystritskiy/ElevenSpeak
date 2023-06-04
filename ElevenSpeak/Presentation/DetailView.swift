// DetailView.swift
// ElevenSpeak. Created by Bogdan Bystritskiy.

import OpenAI
import SwiftUI

struct DetailView: View {
    @State var inputText: String = ""
    @FocusState private var isFocused: Bool

    let conversation: Conversation
    let error: Error?
    let sendMessage: (String, Model) -> Void

    private var fillColor: Color {
        Color(uiColor: UIColor.systemBackground)
    }

    private var strokeColor: Color {
        Color(uiColor: UIColor.systemGray5)
    }

    var body: some View {
        NavigationStack {
            ScrollViewReader { scrollViewProxy in
                VStack {
                    List {
                        ForEach(conversation.messages) { message in
                            ChatBubbleView(message: message)
                        }
                        .listRowSeparator(.hidden)
                    }
                    .listStyle(.plain)
                    .animation(.default, value: conversation.messages)
//                    .onChange(of: conversation) { newValue in
//                        if let lastMessage = newValue.messages.last {
//                            scrollViewProxy.scrollTo(lastMessage.id, anchor: .bottom)
//                        }
//                    }

                    if let error {
                        errorMessage(error: error)
                    }

                    inputBar(scrollViewProxy: scrollViewProxy)
                }
                .navigationTitle("Chat")
            }
        }
    }

    @ViewBuilder private func errorMessage(error: Error) -> some View {
        Text(
            error.localizedDescription
        )
        .font(.caption)
        .foregroundColor(Color(uiColor: .systemRed))
        .padding(.horizontal)
    }

    @ViewBuilder private func inputBar(scrollViewProxy: ScrollViewProxy) -> some View {
        HStack {
            TextEditor(
                text: $inputText
            )
            .padding(.vertical, -8)
            .padding(.horizontal, -4)
            .frame(minHeight: 22, maxHeight: 300)
            .foregroundColor(.primary)
            .padding(EdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16))
            .background(
                RoundedRectangle(
                    cornerRadius: 16,
                    style: .continuous
                )
                .fill(fillColor)
                .overlay(
                    RoundedRectangle(
                        cornerRadius: 16,
                        style: .continuous
                    )
                    .stroke(
                        strokeColor,
                        lineWidth: 1
                    )
                )
            )
            .fixedSize(horizontal: false, vertical: true)
            .onSubmit {
                withAnimation {
                    tapSendMessage(scrollViewProxy: scrollViewProxy)
                }
            }
            .padding(.leading)

            Button(action: {
                withAnimation {
                    tapSendMessage(scrollViewProxy: scrollViewProxy)
                }
            }) {
                Image(systemName: "paperplane")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 24, height: 24)
                    .padding(.trailing)
            }
        }
        .padding(.bottom)
    }

    private func tapSendMessage(scrollViewProxy: ScrollViewProxy) {
        sendMessage(inputText, .gpt3_5Turbo)
        inputText = ""

//        if let lastMessage = conversation.messages.last {
//            scrollViewProxy.scrollTo(lastMessage.id, anchor: .bottom)
//        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(
            conversation: Conversation(
                id: "1",
                messages: [
                    Message(id: "1", role: .assistant, content: "Hello, how can I help you today?", createdAt: Date(timeIntervalSinceReferenceDate: 0)),
                    Message(id: "2", role: .user, content: "I need help with my subscription.", createdAt: Date(timeIntervalSinceReferenceDate: 100)),
                    Message(id: "3", role: .assistant, content: "Sure, what seems to be the problem with your subscription?", createdAt: Date(timeIntervalSinceReferenceDate: 200))
                ]
            ),
            error: nil,
            sendMessage: { _, _ in }
        )
    }
}
