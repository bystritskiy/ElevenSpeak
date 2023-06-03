// InputView.swift
// ElevenSpeak. Created by Bogdan Bystritskiy.

import SwiftUI

struct InputView: View {
    @ObservedObject var audioService: AudioService = .init()
    @ObservedObject var whisperService: WhisperService = .init()

    var body: some View {
        VStack {
            Text(whisperService.text)
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
        audioService.startRecording()
    }

    func stopListening() {
        audioService.stopRecording()
        whisperService.transcribe(file: audioService.audioFileData!)
    }
}

struct InputView_Previews: PreviewProvider {
    static var previews: some View {
        InputView()
    }
}
