// ElevenLabsService.swift
// ElevenSpeak. Created by Bogdan Bystritskiy.

import ElevenlabsSwift
import Foundation

class ElevenLabsService: NSObject, ObservableObject {
    private let elevenApi: ElevenlabsSwift
    private let audioPlayerService = AudioPlayerService()

    override init() {
        elevenApi = ElevenlabsSwift(elevenLabsAPI: Secret.elevenlabsKey)
    }

    public func getAudio(from text: String) {
        Task {
            let voices = try await elevenApi.fetchVoices()
            if let voiceId = voices.first?.id {
                let url = try await elevenApi.textToSpeech(voice_id: voiceId, text: text)
                audioPlayerService.playRecording(url: url)
            }
        }
    }
}
