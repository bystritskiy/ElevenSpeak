// AudioRecorder.swift
// ElevenSpeak. Created by Bogdan Bystritskiy.

import AVFoundation
import SwiftUI

class AudioRecorder: NSObject, ObservableObject {
    private var audioRecorder: AVAudioRecorder?
    private var audioPlayer: AVAudioPlayer?
    @Published var isRecording = false
    @Published var isPlaying = false
    @Published var audioFileURL: URL?
    @Published var audioFilePath: String?

    func startRecording() {
        print("Starting recording...")
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let audioFilename = documentsDirectory.appendingPathComponent("recording.m4a")
        print("Audio file path: \(audioFilename)") // Check the printed output for correctness
        audioFilePath = audioFilename.path

        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue,
        ]

        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder?.delegate = self
            audioRecorder?.record()
            isRecording = true
        } catch {
            print("Failed to start recording")
        }
    }

    func stopRecording() {
        audioRecorder?.stop()
        isRecording = false
    }

    func playRecording() {
        guard let audioFilePath else { return }
        let audioFileURL = URL(fileURLWithPath: audioFilePath)
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audioFileURL)
            audioPlayer?.delegate = self
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

extension AudioRecorder: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            print("Recording was not successful")
        }
    }
}

extension AudioRecorder: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        isPlaying = false
    }
}
