// InputView.swift
// ElevenSpeak. Created by Bogdan Bystritskiy.

import SwiftUI

struct InputView: View {
    @Binding var text: String
    let onCommit: () -> Void

    var body: some View {
        HStack {
            TextField("Type something...", text: $text, onCommit: onCommit)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            Button(action: {
                // Handle the microphone button press
                startListening()
            }) {
                Image(systemName: "mic.fill")
                    .foregroundColor(.white)
            }
            .background(Color.blue)
            .clipShape(Circle())
            .padding()
        }
    }

    func startListening() {}
}
