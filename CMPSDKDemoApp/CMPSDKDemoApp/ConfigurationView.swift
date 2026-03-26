//
//  ConfigurationView.swift
//  CMPSDKDemoApp
//
//  Initial screen for dynamic CMP webview configuration.
//

import SwiftUI

struct ConfigurationView: View {
    @Binding var configuration: CMPConfiguration
    var onContinue: () -> Void

    @State private var showValidationAlert = false

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("CMP Settings")) {
                    TextField("Code-ID", text: $configuration.codeId)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .accessibilityIdentifier("Code-ID")

                    Picker("Language", selection: $configuration.language) {
                        ForEach(["EN", "IT", "DE", "FR", "ES", "PT", "NL", "PL"], id: \.self) { lang in
                            Text(lang).tag(lang)
                        }
                    }
                    .accessibilityIdentifier("Language")

                    TextField("App Name", text: $configuration.appName)
                        .accessibilityIdentifier("App Name")

                    TextField("Domain", text: $configuration.domain)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .accessibilityIdentifier("Domain")
                }

                Section(header: Text("Webview Appearance")) {
                    Picker("Position", selection: $configuration.position) {
                        ForEach(WebviewPosition.allCases) { pos in
                            Text(pos.rawValue).tag(pos)
                        }
                    }
                    .accessibilityIdentifier("Position")

                    Picker("Background", selection: $configuration.backgroundStyle) {
                        ForEach(WebviewBackgroundStyle.allCases) { style in
                            Text(style.rawValue).tag(style)
                        }
                    }
                    .accessibilityIdentifier("Background")

                    Stepper(value: $configuration.cornerRadius, in: 0...30, step: 5) {
                        Text("Corner Radius: \(Int(configuration.cornerRadius))")
                    }
                    .accessibilityIdentifier("Corner Radius")

                    Toggle("Respects Safe Area", isOn: $configuration.respectsSafeArea)
                        .accessibilityIdentifier("Respects Safe Area")

                    Toggle("Allows Orientation Changes", isOn: $configuration.allowsOrientationChanges)
                        .accessibilityIdentifier("Allows Orientation Changes")
                }
            }
            .navigationTitle("CMP Configuration")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("Load CMP") {
                        if configuration.isValid {
                            onContinue()
                        } else {
                            showValidationAlert = true
                        }
                    }
                    .accessibilityIdentifier("Load CMP")
                }
            }
            .alert("Invalid Configuration", isPresented: $showValidationAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(configuration.validationError ?? "")
            }
        }
    }
}
