//
//  ContentView.swift
//  CMPSDKDemoApp
//
//  Created by Fabio Torre on 18/02/25.
//

import SwiftUI

/// Launch argument to skip ConfigurationView and go directly to consent (for UI tests).
struct LaunchArguments {
    static let skipConfig = "--skip-config"
}

struct ContentView: View {
    @State private var configuration = CMPConfiguration.default
    @State private var hasConfiguration = false
    @State private var isConsentInitialized = false

    private var skipConfig: Bool {
        ProcessInfo.processInfo.arguments.contains(LaunchArguments.skipConfig)
    }

    var body: some View {
        Group {
            if isConsentInitialized {
                HomeView()
                    .accessibilityIdentifier("HomeScreen")
            } else if hasConfiguration {
                ConsentView(isInitialized: $isConsentInitialized)
                    .accessibilityIdentifier("ConsentScreen")
            } else {
                ConfigurationView(configuration: $configuration) {
                    ConsentManager.shared.configure(with: configuration)
                    hasConfiguration = true
                }
                .accessibilityIdentifier("ConfigurationScreen")
            }
        }
        .onAppear {
            if skipConfig {
                ConsentManager.shared.configure(with: configuration)
                hasConfiguration = true
            }
        }
    }
}
