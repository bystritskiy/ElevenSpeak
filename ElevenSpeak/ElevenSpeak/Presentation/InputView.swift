// InputView.swift
// ElevenSpeak. Created by Bogdan Bystritskiy.

import SwiftUI

struct InputView: View {
    @StateObject var teacher: Teacher = .init()
    @ObservedObject var audioRecorder: AudioRecorder = .init()
    @State var isListening = false

    var body: some View {
        VStack {
            Text(teacher.text)
            Text(teacher.realTimeTranscription)
            Text("\(Int(teacher.transcribeProgress) * 100)%")

            Button { didTapListeningButton() } label: {
                Image(systemName: "mic.fill")
                    .resizable()
                    .frame(width: 40, height: 50)
                    .foregroundColor(isListening ? .red : .blue)
            }
            CustomWaveformView(amplitudes: teacher.waveformAmplitudes)
                .frame(maxWidth: .infinity, minHeight: 100, maxHeight: 100, alignment: .center)
        }
    }

    func didTapListeningButton() {
        if isListening {
            stopListening()
        } else {
            startListening()
        }
    }

    func startListening() {
        isListening = true
        teacher.startRecording()
        audioRecorder.startRecording()
    }

    func stopListening() {
        isListening = false
        teacher.stopRecording()
        audioRecorder.stopRecording()
    }
}

struct InputView_Previews: PreviewProvider {
    static var previews: some View {
        InputView()
    }
}
