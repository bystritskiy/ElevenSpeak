// WhisperService.swift
// ElevenSpeak. Created by Bogdan Bystritskiy.

import Foundation
import OpenAI

class WhisperService: NSObject, ObservableObject {
    @Published var isTranscribing: Bool = false

    private let openAI: OpenAI

    override init() {
        openAI = OpenAI(apiToken: Secret.whisperKey)
    }

    func transcribe(file: Data, fileName: String = "recording.m4a", completion: @escaping (_ answer: String) -> Void) {
        isTranscribing = true
        let query = AudioTranscriptionQuery(file: file, fileName: fileName, model: .whisper_1)
        openAI.audioTranscriptions(query: query) { result in
            switch result {
            case let .success(transcriptionResult):
                completion(transcriptionResult.text)
            case let .failure(error):
                completion(error.localizedDescription)
            }
        }
        isTranscribing = false
    }
}
