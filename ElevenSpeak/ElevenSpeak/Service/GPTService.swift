// GPTService.swift
// ElevenSpeak. Created by Bogdan Bystritskiy.

import Foundation
import OpenAI

class GPTService: NSObject, ObservableObject {
    private let openAI: OpenAI

    var messages: [Chat] = [.init(role: .system, content: Promt.teacher)]

    override init() {
        openAI = OpenAI(apiToken: Secret.gptKey)
    }

    public func getAnswer(prompt: String, completion: @escaping (_ answer: String) -> Void) {
        messages.append(.init(role: .user, content: prompt))
        let query = ChatQuery(
            model: .gpt3_5Turbo,
            messages: messages
        )
        Task {
            do {
                let result = try await openAI.chats(query: query)
                completion(result.choices.first?.message.content ?? "")
            } catch {
                completion("")
            }
        }
    }

    public func getEmoji(prompt: String, completion: @escaping (_ answer: String) -> Void) {
        let query = ChatQuery(
            model: .gpt3_5Turbo,
            messages: [
                .init(role: .system, content: Promt.emoji),
                .init(role: .user, content: prompt)
            ]
        )
        Task {
            do {
                let result = try await openAI.chats(query: query)
                completion(result.choices.first?.message.content ?? "")
            } catch {
                completion("")
            }
        }
    }
}
