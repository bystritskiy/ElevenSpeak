// IDProvider.swift
// ElevenSpeak. Created by Bogdan Bystritskiy.

import SwiftUI

private struct IDProviderKey: EnvironmentKey {
    static let defaultValue: () -> String = {
        UUID().uuidString
    }
}

public extension EnvironmentValues {
    var idProviderValue: () -> String {
        get { self[IDProviderKey.self] }
        set { self[IDProviderKey.self] = newValue }
    }
}

public extension View {
    func idProviderValue(_ idProviderValue: @escaping () -> String) -> some View {
        environment(\.idProviderValue, idProviderValue)
    }
}
