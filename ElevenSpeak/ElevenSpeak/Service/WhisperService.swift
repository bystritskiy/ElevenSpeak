// WhisperService.swift
// ElevenSpeak. Created by Bogdan Bystritskiy.

import AVFoundation
import Foundation
import SwiftWhisper

class WhisperService: NSObject, ObservableObject {
    @Published var text: String = ""
    @Published var isRecording: Bool = false
    @Published var isTranscribing: Bool = false
    @Published var transcribeProgress: Double = 0
    @Published var realTimeTranscription: String = ""
    @Published var waveformAmplitudes: [CGFloat] = []

    private var whisper: Whisper!
    private let whisperModel = Bundle.main.url(forResource: "tiny", withExtension: "bin")!

    private var audioFrames: [Float] = []
    private let audioEngine = AVAudioEngine()
    private let audioSession = AVAudioSession.sharedInstance()

    override init() {
        whisper = Whisper(fromFileURL: whisperModel)
    }

    @MainActor
    func startRecording() {
        realTimeTranscription = "" // Reset real-time transcription

        do {
            try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
            try audioSession.setPreferredSampleRate(16000)
            audioSession.requestRecordPermission { isPermitted in
                if isPermitted {
                    self.startAudioEngine()
                } else {
                    // Ask user to give permission in settings?
                }
            }
        } catch {
            print(error)
        }
    }

    @MainActor
    func stopRecording() {
        realTimeTranscription = "" // Reset real-time transcription

        audioEngine.stop()
        endRecording()
        transcribe()
    }

    func clear() {
        text = ""
        audioFrames = []
    }

    // MARK: - Private

    private func startAudioEngine() {
        audioFrames.removeAll()
        realTimeTranscription = ""
        whisper.delegate = self

        let recordingFormat = audioEngine.inputNode.outputFormat(forBus: 0)
        audioEngine.inputNode.installTap(onBus: 0, bufferSize: 2048, format: recordingFormat) { buffer, when in
            // Append recorded audio frames to the buffer.
            let recordedFrames = [Float](UnsafeBufferPointer(buffer.audioBufferList.pointee.mBuffers))
            self.audioFrames.append(contentsOf: recordedFrames)
        }

        audioEngine.prepare()
        do {
            try audioEngine.start()
            isRecording = true
        } catch {
            print(error)
            endRecording()
        }
    }

    private func endRecording() {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        isRecording = false
    }

    @MainActor
    private func transcribe() {
        isTranscribing = true
        Task {
            do {
                let segments = try await self.whisper.transcribe(audioFrames: audioFrames)
                let newText = segments.map(\.text).joined().trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                self.isTranscribing = false
                self.text = newText
                print(text)
            } catch {
                print(error)
            }
        }
    }
}

extension WhisperService: WhisperDelegate {
    func whisper(_ aWhisper: Whisper, didUpdateProgress progress: Double) {
        transcribeProgress = max(0, min(1, progress))
    }

    func whisper(_ aWhisper: Whisper, didProcessNewSegments segments: [Segment], atIndex index: Int) {
        // Update the real-time transcription property with the transcribed segment text.
        DispatchQueue.main.async {
            self.realTimeTranscription += segments.map(\.text).joined()
        }
    }

    func whisper(_ aWhisper: Whisper, didCompleteWithSegments segments: [Segment]) {}

    func whisper(_ aWhisper: Whisper, didErrorWith error: Error) {
        print(error)
    }
}
