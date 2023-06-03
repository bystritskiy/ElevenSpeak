// AudioRecorderService.swift
// ElevenSpeak. Created by Bogdan Bystritskiy.

import AVFoundation

// swiftlint:disable all
class AudioRecorderService: NSObject, ObservableObject {
    var audioFileData: Data?
    @Published var isRecording = false

    private var audioRecorder: AVAudioRecorder?
    private var audioFilePath: String?

    func startRecording() {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let audioFileName = documentsDirectory.appendingPathComponent("recording.m4a")
        audioFilePath = audioFileName.path

        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue,
        ]

        do {
            audioRecorder = try AVAudioRecorder(url: audioFileName, settings: settings)
            audioRecorder?.record()
            isRecording = true
        } catch {
            print("Failed to start recording")
        }
    }

    func stopRecording() {
        audioRecorder?.stop()
        isRecording = false

        let audioFileURL = URL(fileURLWithPath: audioFilePath!)
        audioFileData = try! Data(contentsOf: audioFileURL)
    }
}
