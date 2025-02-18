//
//  ContentView.swift
//  CMPSDKDemoApp
//
//  Created by Fabio Torre on 18/02/25.
//

import Foundation
import UIKit
import SwiftUI

// ContentView.swift
struct ContentView: View {
    @State private var isConsentInitialized = false
    
    var body: some View {
        if isConsentInitialized {
            HomeView()
        } else {
            ConsentView(isInitialized: $isConsentInitialized)
        }
    }
}
