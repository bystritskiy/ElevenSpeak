// MainView.swift
// ElevenSpeak. Created by Bogdan Bystritskiy.

import OpenAI
import SwiftUI

struct MainView: View {
    @State private var selectedTab = 0

    @StateObject var chatStore: ChatStore

    @Environment(\.idProviderValue) var idProvider
    @Environment(\.dateProviderValue) var dateProvider

    init(idProvider: @escaping () -> String) {
        _chatStore = StateObject(
            wrappedValue: ChatStore(
                openAIClient: OpenAI(apiToken: Secret.gptKey),
                idProvider: idProvider
            )
        )
    }

    var body: some View {
        ChatView(store: chatStore)
    }
}
