// Conversation.swift
// ElevenSpeak. Created by Bogdan Bystritskiy.

import Foundation

struct Conversation {
    init(id: String, messages: [Message] = []) {
        self.id = id
        self.messages = messages
    }

    typealias ID = String

    let id: String
    var messages: [Message]
}

extension Conversation: Equatable, Identifiable {}
