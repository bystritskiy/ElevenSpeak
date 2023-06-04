// MainView.swift
// ElevenSpeak. Created by Bogdan Bystritskiy.

import SwiftUI

struct MainView: View {
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            ChatView()
                .tabItem {
                    Label("Chat", systemImage: "1.circle")
                }
                .tag(0)
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "2.circle")
                }
                .tag(1)
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
