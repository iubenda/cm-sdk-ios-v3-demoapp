//
//  InitializationView.swift
//  CMPSDKDemoApp
//
//  Created by Fabio Torre on 08/10/24.
//

import SwiftUI
import cm_sdk_ios_v3

struct InitializationView: View {
    let onConsentInitialized: () -> Void
    
    var body: some View {
        Text("Initializing Consent Manager...")
            .onAppear {
                initializeConsent()
            }
    }
    
    private func initializeConsent() {
        let cmpManager = CMPManager.shared
        cmpManager.setUrlConfig(UrlConfig(id: "Your ID goes here",    // Inform the ID
                                          domain: "delivery.consentmanager.net",
                                          language: "EN",
                                          appName: "CMPDemoApp"))
        cmpManager.setWebViewConfig(ConsentLayerUIConfig())
        cmpManager.checkWithServerAndOpenIfNecessary { error in
            if let error = error {
                print("Error initializing consent: \(error)")
            } else {
                print("CMPManager initialized successfully")
                DispatchQueue.main.async {
                    onConsentInitialized()
                }
            }
        }
    }
}
