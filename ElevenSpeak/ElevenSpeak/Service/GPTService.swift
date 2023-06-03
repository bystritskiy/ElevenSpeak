// GPTService.swift
// ElevenSpeak. Created by Bogdan Bystritskiy.

import Combine
import Foundation
import OpenAI

class GPTService: NSObject, ObservableObject {
    private let openAI: OpenAI

    override init() {
        openAI = OpenAI(apiToken: Secret.gptKey)
    }

    public func getAnswer(prompt: String, completion: @escaping (_ answer: String?) -> Void) {
        let query = ChatQuery(
            model: .gpt3_5Turbo,
            messages: [
                .init(role: .system, content: Promt.teacherPromt),
                .init(role: .user, content: prompt),
            ]
        )
        Task {
            do {
                let result = try await openAI.chats(query: query)
                completion(result.choices.first?.message.content)
            } catch {
                print(error.localizedDescription)
                completion(nil)
            }
        }
    }
}
