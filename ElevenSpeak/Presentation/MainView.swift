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
        TabView(selection: $selectedTab) {
            ChatView(store: chatStore)
                .tabItem {
                    Label("Chat new", systemImage: "0.circle")
                }
                .tag(0)
            HomeView()
                .tabItem {
                    Label("Chat old", systemImage: "1.circle")
                }
                .tag(1)
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "2.circle")
                }
                .tag(1)
        }
    }
}
