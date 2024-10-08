//
//  ContentView.swift
//  CMPSDKDemoApp
//
//  Created by Fabio Torre on 07/10/24.
//

import SwiftUI
import cm_sdk_ios_v3

struct ContentView: View {
    @State private var isConsentInitialzed = false
    
    
    var body: some View {
        if isConsentInitialzed {
            HomeView()
        } else {
            InitializationView(onConsentInitialized: { isConsentInitialzed = true })
        }
    }
}

#Preview {
    ContentView()
}
