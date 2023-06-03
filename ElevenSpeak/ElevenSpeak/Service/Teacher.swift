// Teacher.swift
// ElevenSpeak. Created by Bogdan Bystritskiy.

import AsyncHTTPClient
import AVFoundation
import Foundation
import OpenAIKit
import OSLog
import SwiftWhisper

class Teacher: NSObject, ObservableObject, AVAudioRecorderDelegate, WhisperDelegate {
    @Published
    var text: String = ""

    @Published
    var isRecording: Bool = false

    @Published
    var hasRecording: Bool = false

    @Published
    var isTranscribing: Bool = false

    @Published
    var transcribeProgress: Double = 0

    @Published
    var isAuthorized: Bool = false

    @Published
    var realTimeTranscription: String = ""

    @Published
    var waveformAmplitudes: [CGFloat] = []

    private let logger: Logger
    private var isBusy: Bool = false
    private var audioFrames: [Float] = []
    private var whisper: Whisper!
    private let openAI: OpenAIKit.Client
    private var inputNode: AVAudioNode!
    private let audioEngine = AVAudioEngine()
    private let audioSession = AVAudioSession.sharedInstance()

    override init() {
        logger = Logger(subsystem: "com.bystritskiy.ElevenSpeak", category: "ElevenSpeak")
        let httpClient = HTTPClient(eventLoopGroupProvider: .createNew)
        let configuration = Configuration(apiKey: OpenAI.apiKey)
        openAI = OpenAIKit.Client(httpClient: httpClient, configuration: configuration)
        let modelURL = Bundle.main.url(forResource: "tiny", withExtension: ".bin")!
        whisper = Whisper(fromFileURL: modelURL)
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
            logger.error("\(error)")
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
        hasRecording = false
    }

    // MARK: - Private

    private func startAudioEngine() {
        audioFrames.removeAll()
        whisper.delegate = self
        inputNode = audioEngine.inputNode
        let recordingFormat = inputNode.outputFormat(forBus: 0)

        // Reset real-time transcription at the start of a new recording.
        realTimeTranscription = ""

        inputNode.installTap(
            onBus: 0,
            bufferSize: 2048,
            format: recordingFormat
        ) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
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
                // Print the count and the first few amplitude values
                let count = self.waveformAmplitudes.count
                let firstFewAmplitudes = self.waveformAmplitudes.prefix(10)
            }
        }

        audioEngine.prepare()
        do {
            try audioEngine.start()
            isRecording = true
        } catch {
            logger.error("\(error)")
            endRecording()
        }
    }

    private func endRecording() {
        inputNode.removeTap(onBus: 0)
        isRecording = false
        hasRecording = !audioFrames.isEmpty
    }

    internal func whisper(_ aWhisper: Whisper, didUpdateProgress progress: Double) {
        transcribeProgress = max(0, min(1, progress))
    }

    func whisper(_ aWhisper: Whisper, didProcessNewSegments segments: [Segment], atIndex index: Int) {
        // Update the real-time transcription property with the transcribed segment text.
        DispatchQueue.main.async {
            self.realTimeTranscription += segments.map(\.text).joined()
        }
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
                logger.error("\(error)")
            }
        }
    }
}
