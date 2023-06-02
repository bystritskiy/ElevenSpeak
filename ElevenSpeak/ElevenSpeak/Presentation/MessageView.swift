// MessageView.swift
// ElevenSpeak. Created by Bogdan Bystritskiy.

import SwiftUI

struct MessageView: View {
    let message: Message

    var body: some View {
        Text(message.text)
            .padding()
            .background(message.sender == .user ? Color.blue : Color.gray)
            .foregroundColor(.white)
            .cornerRadius(10)
    }
}
