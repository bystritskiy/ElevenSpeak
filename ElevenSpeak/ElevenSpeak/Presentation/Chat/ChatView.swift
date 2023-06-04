// ChatView.swift
// ElevenSpeak. Created by Bogdan Bystritskiy.

import SwiftUI

struct ChatView: View {
    @ObservedObject var audioRecorderService = AudioRecorderService()
    @ObservedObject var whisperService = WhisperService()
    @ObservedObject var gptService = GPTService()
    @ObservedObject var elevanLabsService = ElevenLabsService()

    @State var answer: String = "..."

    var body: some View {
        VStack {
            Text(whisperService.text)
            Text(answer)
            Button { didTapListeningButton() } label: {
                Image(systemName: "mic.fill")
                    .resizable()
                    .frame(width: 40, height: 50)
                    .foregroundColor(audioRecorderService.isRecording ? .red : .blue)
            }
        }
    }

    func didTapListeningButton() {
        if audioRecorderService.isRecording {
            stopListening()
        } else {
            startListening()
        }
    }

    func startListening() {
        whisperService.text = ""
        audioRecorderService.startRecording()
    }

    func stopListening() {
        audioRecorderService.stopRecording()
        whisperService.transcribe(file: audioRecorderService.audioFileData!)
        gptService.getAnswer(prompt: whisperService.text) { result in
            answer = result
            elevanLabsService.getAudio(from: answer)
        }
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
    }
}
