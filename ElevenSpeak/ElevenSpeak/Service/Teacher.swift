// Teacher.swift
// ElevenSpeak. Created by Bogdan Bystritskiy.

import AudioKit
import AVFoundation
import Foundation
import SwiftWhisper

class Teacher: NSObject, ObservableObject {
    @Published var text: String = ""
    @Published var isRecording: Bool = false
    @Published var isTranscribing: Bool = false
    @Published var transcribeProgress: Double = 0
    @Published var realTimeTranscription: String = ""
    @Published var waveformAmplitudes: [CGFloat] = []

    private var whisper: Whisper!
    private let whisperModel = Bundle.main.url(forResource: "tiny", withExtension: "bin")!

    private var inputNode: AVAudioNode!
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
        whisper.delegate = self
        inputNode = audioEngine.inputNode
        let recordingFormat = inputNode.outputFormat(forBus: 0)

        // Reset real-time transcription at the start of a new recording.
        realTimeTranscription = ""

        inputNode.installTap(onBus: 0, bufferSize: 2048, format: recordingFormat) { (buffer: AVAudioPCMBuffer, _) in
            // Append recorded audio frames to the buffer.
            let recordedFrames = [Float](UnsafeBufferPointer(buffer.audioBufferList.pointee.mBuffers))
            self.audioFrames.append(contentsOf: recordedFrames)

            // Calculate RMS amplitude levels for the waveform
            let chunkSize = 160 // Define the chunk size for RMS calculation
            var rmsAmplitudes: [CGFloat] = []
            for index in stride(from: 0, to: recordedFrames.count, by: chunkSize) {
                let chunk = recordedFrames[index ..< min(index + chunkSize, recordedFrames.count)]
                let rms = sqrt(chunk.map { CGFloat($0) * CGFloat($0) }.reduce(0, +) / CGFloat(chunk.count))
                rmsAmplitudes.append(rms)
            }

            DispatchQueue.main.async {
                self.waveformAmplitudes = rmsAmplitudes
            }
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
        inputNode.removeTap(onBus: 0)
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

extension Teacher: WhisperDelegate {
    func whisper(_ aWhisper: Whisper, didUpdateProgress progress: Double) {
        transcribeProgress = max(0, min(1, progress))
    }

    func whisper(_ aWhisper: Whisper, didProcessNewSegments segments: [Segment], atIndex index: Int) {
        // Update the real-time transcription property with the transcribed segment text.
        DispatchQueue.main.async {
            self.realTimeTranscription += segments.map(\.text).joined()
        }
    }

    func whisper(_ aWhisper: Whisper, didCompleteWithSegments segments: [Segment]) {
        print(segments)
    }

    func whisper(_ aWhisper: Whisper, didErrorWith error: Error) {
        print(error)
    }
}
