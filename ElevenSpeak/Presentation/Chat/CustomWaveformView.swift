// CustomWaveformView.swift
// ElevenSpeak. Created by Bogdan Bystritskiy.

import SwiftUI

struct CustomWaveformView: View {
    var amplitudes: [CGFloat] // Input amplitudes
    private let rectangleCount = 7
    private let rectangleWidth: CGFloat = 10
    private let spacing: CGFloat = 5
    private let sensitivity: CGFloat = 600.0 // Increase the sensitivity
    private let maxAmplitude: CGFloat = 80.0 // Increase the maximum amplitude
    private let minHeight: CGFloat = 5.0 // Set minimum height for each rectangle
    private let maxHeight: CGFloat = 100.0 // Set maximum height for each rectangle

    var body: some View {
        // Handle the case where the amplitudes array is empty
        if amplitudes.isEmpty {
            return AnyView(EmptyView())
        }

        // Calculate the stride size and ensure it is at least 1
        let strideSize = max((amplitudes.count + rectangleCount - 1) / rectangleCount, 1)

        let averagedAmplitudes = stride(from: 0, to: amplitudes.count, by: strideSize).map { strideIndex -> CGFloat in
            let rangeEnd = min(strideIndex + strideSize, amplitudes.count)
            let subrange = amplitudes[strideIndex ..< rangeEnd]
            let average = subrange.reduce(0, +) / CGFloat(subrange.count)
            return average
        }.prefix(rectangleCount) // Ensure that we only take up to `rectangleCount` elements

        return AnyView(
            HStack(alignment: .center, spacing: spacing) {
                ForEach(averagedAmplitudes.indices, id: \.self) { index in
                    // Use the normalized and scaled amplitude to determine the height of the rectangle
                    // Apply non-linear scaling using the square function
                    let normalizedAmplitude = min(averagedAmplitudes[index] * sensitivity, maxAmplitude)
                    let scaledAmplitude = pow(normalizedAmplitude, 2)
                    let rectangleHeight = max(minHeight, min(scaledAmplitude, maxHeight)) // Cap the height to maxHeight
                    RoundedRectangle(cornerRadius: rectangleWidth / 2)
                        .fill(Color.blue)
                        .frame(width: rectangleWidth, height: rectangleHeight)
                }
            }
            .animation(.easeInOut(duration: 0.2), value: averagedAmplitudes) // Apply the animation here
        )
    }
}
