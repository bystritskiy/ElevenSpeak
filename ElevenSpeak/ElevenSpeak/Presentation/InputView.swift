// InputView.swift
// ElevenSpeak. Created by Bogdan Bystritskiy.

import SwiftUI

struct InputView: View {
    @ObservedObject var audioRecorder: AudioRecorder = .init()
    @ObservedObject var whisperService: WhisperService = .init()

    var body: some View {
        VStack {
            Text(whisperService.text)
            Button { didTapListeningButton() } label: {
                Image(systemName: "mic.fill")
                    .resizable()
                    .frame(width: 40, height: 50)
                    .foregroundColor(audioRecorder.isRecording ? .red : .blue)
            }
        }
    }

    func didTapListeningButton() {
        if audioRecorder.isRecording {
            stopListening()
        } else {
            startListening()
        }
    }

    func startListening() {
        audioRecorder.startRecording()
    }

    func stopListening() {
        audioRecorder.stopRecording()
        whisperService.transcribe(file: audioRecorder.audioFileData!)
    }
}

struct InputView_Previews: PreviewProvider {
    static var previews: some View {
        InputView()
    }
}
