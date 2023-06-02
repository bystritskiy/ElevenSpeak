// ViewModel.swift
// ElevenSpeak. Created by Bogdan Bystritskiy.

import Combine

class ViewModel: ObservableObject {
    @Published var messages = [Message]()
    @Published var currentInput = ""

    func sendMessage() {
        let message = Message(text: currentInput, sender: .user)
        messages.append(message)
        currentInput = ""

        // Here's where you'd integrate the Whisper API to convert speech to text.
        // Once you have the text, you can send it to the GPT-3 API to get a response.
        // Then, send the response to the Google Cloud Text-to-Speech API to get the audio form of the response.
        // Lastly, play the audio to the user.
    }
}
