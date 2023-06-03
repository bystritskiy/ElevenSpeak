// InputView.swift
// ElevenSpeak. Created by Bogdan Bystritskiy.

import SwiftUI

struct InputView: View {
    @StateObject var whisperService: WhisperService = .init()
    @ObservedObject var audioRecorder: AudioRecorder = .init()

    var body: some View {
        VStack {
            Text(whisperService.text)
            Button { didTapListeningButton() } label: {
                Image(systemName: "mic.fill")
                    .resizable()
                    .frame(width: 40, height: 50)
                    .foregroundColor(whisperService.isRecording ? .red : .blue)
            }
            CustomWaveformView(amplitudes: whisperService.waveformAmplitudes)
                .frame(maxWidth: .infinity, minHeight: 100, maxHeight: 100, alignment: .center)
        }
    }

    func didTapListeningButton() {
        if whisperService.isRecording {
            stopListening()
        } else {
            startListening()
        }
    }

    func startListening() {
        whisperService.startRecording()
//        audioRecorder.startRecording()
    }

    func stopListening() {
        whisperService.stopRecording()
//        audioRecorder.stopRecording()
    }
}

struct InputView_Previews: PreviewProvider {
    static var previews: some View {
        InputView()
    }
}
