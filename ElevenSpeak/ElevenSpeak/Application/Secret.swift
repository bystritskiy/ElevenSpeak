// Secret.swift
// ElevenSpeak. Created by Bogdan Bystritskiy.

import Foundation

struct Secret {
    static func string(for key: String) -> String {
        Bundle.main.infoDictionary?[key] as? String ?? ""
    }
}

enum OpenAI {
    static var apiKey: String {
        Secret.string(for: "OPENAI_API_KEY")
    }
}
