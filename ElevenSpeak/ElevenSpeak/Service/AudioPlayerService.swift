// AudioPlayerService.swift
// ElevenSpeak. Created by Bogdan Bystritskiy.

import AVFoundation

class AudioPlayerService: NSObject, ObservableObject {
    private var audioPlayer: AVAudioPlayer?

    @Published var isPlaying = false
    @Published var audioFileURL: URL?

    func playRecording(url: URL) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
            isPlaying = true
        } catch {
            print("Failed to play recording")
        }
    }

    func stopPlaying() {
        audioPlayer?.stop()
        isPlaying = false
    }
}
