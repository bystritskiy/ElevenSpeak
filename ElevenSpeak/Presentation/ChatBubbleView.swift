// ChatBubbleView.swift
// ElevenSpeak. Created by Bogdan Bystritskiy.

import SwiftUI

struct ChatBubbleView: View {
    let message: Message

    private var assistantBackgroundColor: Color {
        Color(uiColor: UIColor.systemGray5)
    }

    private var userForegroundColor: Color {
        Color(uiColor: .white)
    }

    private var userBackgroundColor: Color {
        Color(uiColor: .systemBlue)
    }

    var body: some View {
        HStack {
            switch message.role {
            case .assistant:
                Text(message.content)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(assistantBackgroundColor)
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                Spacer(minLength: 24)
            case .user:
                Spacer(minLength: 24)
                Text(message.content)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .foregroundColor(userForegroundColor)
                    .background(userBackgroundColor)
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            case .system:
                EmptyView()
            }
        }
    }
}
