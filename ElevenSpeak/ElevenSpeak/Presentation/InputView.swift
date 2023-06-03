// InputView.swift
// ElevenSpeak. Created by Bogdan Bystritskiy.

import SwiftUI

struct InputView: View {
    @ObservedObject var audioService: AudioService = .init()
    @ObservedObject var whisperService: WhisperService = .init()
    @ObservedObject var gptService: GPTService = .init()

    @State var answer: String = "..."

    var body: some View {
        VStack {
            Text(whisperService.text)
            Text(answer)
            Button { didTapListeningButton() } label: {
                Image(systemName: "mic.fill")
                    .resizable()
                    .frame(width: 40, height: 50)
                    .foregroundColor(audioService.isRecording ? .red : .blue)
            }
        }
    }

    func didTapListeningButton() {
        if audioService.isRecording {
            stopListening()
        } else {
            startListening()
        }
    }

    func startListening() {
        whisperService.text = ""
        audioService.startRecording()
    }

    func stopListening() {
        audioService.stopRecording()
        whisperService.transcribe(file: audioService.audioFileData!)
        gptService.getAnswer(prompt: whisperService.text) { result in
            answer = result ?? "..."
        }
    }
}

struct InputView_Previews: PreviewProvider {
    static var previews: some View {
        InputView()
    }
}
