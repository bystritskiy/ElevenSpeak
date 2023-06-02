// InputView.swift
// ElevenSpeak. Created by Bogdan Bystritskiy.

import SwiftUI

struct InputView: View {
    @Binding var text: String
    let onCommit: () -> Void

    var body: some View {
        HStack {
            Button(action: {
                startListening()
            }) {
                Image(systemName: "mic.fill")
            }
            .clipShape(Circle())
            .padding()
        }
    }

    func startListening() {
        // TODO:
    }
}
