// ContentView.swift
// ElevenSpeak. Created by Bogdan Bystritskiy.

import AVFoundation
import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: ViewModel

    var body: some View {
        VStack {
            ScrollView {
                ForEach(viewModel.messages, id: \.self) { message in
                    MessageView(message: message)
                }
            }
            InputView(text: $viewModel.currentInput, onCommit: viewModel.sendMessage)
        }
    }

    init() {
        viewModel = ViewModel()
    }
}
