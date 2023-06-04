// DetailView.swift
// ElevenSpeak. Created by Bogdan Bystritskiy.

import OpenAI
import SwiftUI

struct DetailView: View {
    @FocusState private var isFocused: Bool

    let conversation: Conversation
    let error: Error?
    let sendMessage: (String, Model) -> Void

    @ObservedObject var audioRecorderService = AudioRecorderService()
    @ObservedObject var whisperService = WhisperService()
    @ObservedObject var elevanLabsService = ElevenLabsService()

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
            Button(action: {
                withAnimation {
                    didTapListeningButton()
                }
            }) {
                Image(systemName: "mic.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 24, height: 24)
                    .foregroundColor(audioRecorderService.isRecording ? .red : .blue)
            }
        }
        .padding(.bottom)
    }

    private func didTapListeningButton() {
        if audioRecorderService.isRecording {
            stopListening()
        } else {
            startListening()
        }
    }

    private func startListening() {
        whisperService.text = ""
        audioRecorderService.startRecording()
    }

    private func stopListening() {
        audioRecorderService.stopRecording()
        whisperService.transcribe(file: audioRecorderService.audioFileData!)
        sendMessage(whisperService.text, .gpt3_5Turbo)
//        elevanLabsService.getAudio(from: answer)
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
