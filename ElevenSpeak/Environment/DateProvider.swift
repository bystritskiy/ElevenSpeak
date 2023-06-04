// DateProvider.swift
// ElevenSpeak. Created by Bogdan Bystritskiy.

import SwiftUI

private struct DateProviderKey: EnvironmentKey {
    static let defaultValue: () -> Date = Date.init
}

public extension EnvironmentValues {
    var dateProviderValue: () -> Date {
        get { self[DateProviderKey.self] }
        set { self[DateProviderKey.self] = newValue }
    }
}

public extension View {
    func dateProviderValue(_ dateProviderValue: @escaping () -> Date) -> some View {
        environment(\.dateProviderValue, dateProviderValue)
    }
}
