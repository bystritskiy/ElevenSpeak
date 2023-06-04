// Message.swift
// ElevenSpeak. Created by Bogdan Bystritskiy.

import Foundation
import OpenAI

struct Message {
    var id: String
    var role: Chat.Role
    var content: String
    var createdAt: Date
}

extension Message: Equatable, Codable, Hashable, Identifiable {}
