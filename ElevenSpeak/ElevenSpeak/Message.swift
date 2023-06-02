// Message.swift
// ElevenSpeak. Created by Bogdan Bystritskiy.

import Foundation

struct Message: Hashable {
    let text: String
    let sender: Sender
}

enum Sender {
    case user
    case bot
}
