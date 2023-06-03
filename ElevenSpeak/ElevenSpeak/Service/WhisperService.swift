// WhisperService.swift
// ElevenSpeak. Created by Bogdan Bystritskiy.

import Foundation
import OpenAI

class WhisperService: NSObject, ObservableObject {
    @Published var text: String = "..."
    @Published var isTranscribing: Bool = false

    private let openAI: OpenAI

    override init() {
        openAI = OpenAI(apiToken: Secret.whisperKey)
    }

    func transcribe(file: Data, fileName: String = "recording.m4a") {
        isTranscribing = true
        let query = AudioTranscriptionQuery(file: file, fileName: fileName, model: .whisper_1)
        openAI.audioTranscriptions(query: query) { result in
            switch result {
            case let .success(transcriptionResult):
                self.text = transcriptionResult.text
                print(self.text)
            case let .failure(error):
                self.text = "Error"
                print("Transcription failed with error: \(error)")
            }
        }
        isTranscribing = false
    }
}
