// InputView.swift
// ElevenSpeak. Created by Bogdan Bystritskiy.

import SwiftUI

struct InputView: View {
    @StateObject var teacher: Teacher = .init()
    @ObservedObject var audioRecorder: AudioRecorder = .init()

    var body: some View {
        VStack {
            Text(teacher.text)
            Text(teacher.realTimeTranscription)
            Text("\(Int(teacher.transcribeProgress) * 100)%")

            Button { didTapListeningButton() } label: {
                Image(systemName: "mic.fill")
                    .resizable()
                    .frame(width: 40, height: 50)
                    .foregroundColor(teacher.isRecording ? .red : .blue)
            }
            CustomWaveformView(amplitudes: teacher.waveformAmplitudes)
                .frame(maxWidth: .infinity, minHeight: 100, maxHeight: 100, alignment: .center)
        }
    }

    func didTapListeningButton() {
        if teacher.isRecording {
            stopListening()
        } else {
            startListening()
        }
    }

    func startListening() {
        teacher.startRecording()
        audioRecorder.startRecording()
    }

    func stopListening() {
        teacher.stopRecording()
        audioRecorder.stopRecording()
    }
}

struct InputView_Previews: PreviewProvider {
    static var previews: some View {
        InputView()
    }
}
