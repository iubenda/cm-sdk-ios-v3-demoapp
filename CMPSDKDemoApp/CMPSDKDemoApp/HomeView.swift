//
//  HomeView.swift
//  CMSwiftDemoApp
//
//  Created by Fabio Torre on 16/07/24.
//

import SwiftUI
import cm_sdk_ios_v3

struct HomeView: View {
    @State private var toastMessage: String?
    @State private var showingToast = false

    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                ScrollView {
                    VStack(spacing: 20) {
                        Text("CM Swift DemoApp")
                            .font(.largeTitle)
                            .padding()

                        Button(action: {
                            let hasConsent = CMPManager.shared.hasUserChoice()
                            showToast(message: "Has User Choice: \(hasConsent)")
                        }) {
                            Text("Has User Choice?")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .accessibilityIdentifier("Has User Choice?")
                        }

                        Button(action: {
                            let cmpString = CMPManager.shared.exportCMPInfo()
                            showToast(message: "CMP String: \(cmpString)")
                        }) {
                            Text("Get CMP String")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.teal)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .accessibilityIdentifier("Get CMP String")
                        }

                        Button(action: {
                            let allPurposes = CMPManager.shared.getAllPurposesIDs()
                            showToast(message: "All Purposes: \(allPurposes)")
                        }) {
                            Text("Get All Purposes")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.mint)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                            .accessibilityIdentifier("Get All Purposes")
                        }

                        Button(action: {
                            let hasPurpose = CMPManager.shared.hasPurposeConsent(id: "c53")
                            showToast(message: "Has Purpose: \(hasPurpose)")
                        }) {
                            Text("Has Purpose ID c53?")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.mint)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                            .accessibilityIdentifier("Has Purpose ID c53?")
                        }

                        Button(action: {
                            let enabledPurposes = CMPManager.shared.getEnabledPurposesIDs()
                            showToast(message: "Enabled Purposes: \(enabledPurposes)")
                        }) {
                            Text("Get Enabled Purposes")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.mint)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .accessibilityIdentifier("Get Enabled Purposes")

                        }

                        Button(action: {
                            let disabledPurposes = CMPManager.shared.getDisabledPurposesIDs()
                            showToast(message: "Disabled Purposes: \(disabledPurposes.joined(separator: ", "))")
                        }) {
                            Text("Get Disabled Purposes")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.gray)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .accessibilityIdentifier("Get Disabled Purposes")
                        }

                        Button(action: {
                            CMPManager.shared.acceptPurposes(["c52", "c53"], updatePurpose: true){ error in
                                if let error = error {
                                    showToast(message: "Error: \(error.localizedDescription)")
                                } else {
                                    showToast(message: "Purposes enabled")
                                }
                            }
                        }) {
                            Text("Enable Purposes c52 and c53")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.mint)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .accessibilityIdentifier("Enable Purposes c52 and c53")
                        }

                        Button(action: {
                            CMPManager.shared.rejectPurposes(["c52", "c53"], updateVendor: true){ error in
                                if let error = error {
                                    showToast(message: "Error: \(error.localizedDescription)")
                                } else {
                                    showToast(message: "Purposes disabled")
                                }
                            }
                        }) {
                            Text("Disable Purposes c52 and c53")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.red)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .accessibilityIdentifier("Disable Purposes c52 and c53")
                        }

                        Button(action: {
                            let allVendors = CMPManager.shared.getAllVendorsIDs()
                            showToast(message: "All Vendors: \(allVendors)")
                        }) {
                            Text("Get All Vendors")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.cyan)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .accessibilityIdentifier("Get All Vendors")
                        }

                        Button(action: {
                            let hasVendor = CMPManager.shared.hasVendorConsent(id: "s2789")
                            showToast(message: "Has Vendor: \(hasVendor)")
                        }) {
                            Text("Has Vendor ID s2789?")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.cyan)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .accessibilityIdentifier("Has Vendor ID s2789?")
                        }

                        Button(action: {
                            let enabledVendors = CMPManager.shared.getEnabledVendorsIDs()
                            showToast(message: "Enabled Vendors: \(enabledVendors)")
                        }) {
                            Text("Get Enabled Vendors")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.cyan)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .accessibilityIdentifier("Get Enabled Vendors")
                        }

                        Button(action: {
                            let disabledVendors = CMPManager.shared.getDisabledVendorsIDs()
                            showToast(message: "Disabled Vendors: \(disabledVendors.joined(separator: ", "))")
                        }) {
                            Text("Get Disabled Vendors")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.gray)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .accessibilityIdentifier("Get Disabled Vendors")
                        }
                        
                        Button(action: {
                            CMPManager.shared.acceptVendors(["s2790", "s2791"]) { error in
                                if let error = error {
                                    showToast(message: "Error: \(error.localizedDescription)")
                                } else {
                                    showToast(message: "Vendors Enabled")
                                }
                            }
                        }) {
                            Text("Enable Vendors s2790 and s2791")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.cyan)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .accessibilityIdentifier("Enable Vendors s2790 and s2791")
                        }

                        Button(action: {
                            CMPManager.shared.rejectVendors(["s2790", "s2791"]) { error in
                                if let error = error {
                                    showToast(message: "Error: \(error.localizedDescription)")
                                } else {
                                    showToast(message: "Vendors Disabled")
                                }
                            }
                        }) {
                            Text("Disable Vendors s2790 and s2791")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.red)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .accessibilityIdentifier("Disable Vendors s2790 and s2791")
                        }

                        Button(action: {
                            CMPManager.shared.rejectAll() { error in
                                if let error = error {
                                    showToast(message: "Error: \(error.localizedDescription)")
                                } else {
                                    showToast(message: "All consents rejected")
                                }
                            }
                        }) {
                            Text("Reject All")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.red)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .accessibilityIdentifier("Reject All")
                        }

                        Button(action: {
                            CMPManager.shared.acceptAll()  { error in
                                if let error = error {
                                    showToast(message: "Error: \(error.localizedDescription)")
                                } else {
                                    showToast(message: "All consents accepted.")
                                }
                            }
                        }) {
                            Text("Accept All")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .accessibilityIdentifier("Accept All")
                        }

                        Button(action: {
                            CMPManager.shared.checkWithServerAndOpenIfNecessary(){ error in
                                if let error = error {
                                    print("Check and Open Consent Layer operation failed with error \(error)")
                                } else {
                                    print("Check and Open Consent Layer operation done succesfully in the DemoApp.")
                                }
                            }
                        }) {
                            Text("Check and Open Consent Layer")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.indigo)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .accessibilityIdentifier("Check and Open Consent Layer")
                        }

                        Button(action: {
                            CMPManager.shared.checkIfConsentIsRequired() { needsConsent in
                                showToast(message: "Needs Consent: \(needsConsent)")
                            }
                        }) {
                            Text("Check Consent Required")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.indigo)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .accessibilityIdentifier("Check Consent Required")
                        }

                        Button(action: {
                            CMPManager.shared.openConsentLayer(){ error in
                                if let error = error {
                                    print("Open Consent Layer operation failed with error \(error)")
                                } else {
                                    print("Consent Layer opened succesfully in the DemoApp.")
                                }
                            }
                        }) {
                            Text("Open Consent Layer")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.indigo)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .accessibilityIdentifier("Open Consent Layer")
                        }

                        Button(action: {
                            CMPManager.shared.importCMPInfo("Q1FERkg3QVFERkg3QUFmR01CSVRCQkVnQUFBQUFBQUFBQWlnQUFBQUFBQUEjXzUxXzUyXzUzXzU0XzU1XzU2XyNfczI3ODlfczI3OTBfczI3OTFfczI2OTdfczk3MV9VXyMxLS0tIw"){ error in
                                if let error = error {
                                    showToast(message: "Error: \(error.localizedDescription)")
                                } else {
                                    showToast(message: "New consent string imported succesfully")
                                }
                            }
                        }) {
                            Text("Import CMP String")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.teal)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .accessibilityIdentifier("Import CMP String")
                        }

                        Button(action: {
                            CMPManager.shared.resetConsentManagementData(){ error in
                                if let error = error {
                                    showToast(message: "Error: \(error.localizedDescription)")
                                } else {
                                    showToast(message: "All consents reset.")
                                }
                            }
                        }) {
                            Text("Reset all CMP Info")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.gray)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .accessibilityIdentifier("Reset all CMP Info")
                        }
                        
                        if #available(iOS 14, *) {
                            Button(action: {
                                CMPManager.shared.requestATTAuthorization { status in
                                    showATTStatusToast(status)
                                }
                            }) {
                                Text("Request ATT Authorization")
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.purple)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                                    .accessibilityIdentifier("Request ATT Authorization")
                            }
                        }
                    }
                }
                .padding()
                .toast(message: toastMessage ?? "", isShowing: $showingToast, duration: 2.0)
            }
        }
    }

    private func showToast(message: String) {
        toastMessage = message
        showingToast = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.showingToast = false
        }
    }
    
    @available(iOS 14, *)
    private func showATTStatusToast(_ status: ATTManager.AuthorizationStatus) {
        let message: String
        switch status {
        case .notDetermined:
            message = "ATT Status: Not Determined - The user hasn't been asked for permission yet."
        case .restricted:
            message = "ATT Status: Restricted - The app is not allowed to request permission."
        case .denied:
            message = "ATT Status: Denied - The user denied permission for tracking."
        case .authorized:
            message = "ATT Status: Authorized - The user granted permission for tracking."
        @unknown default:
            message = "ATT Status: Unknown status"
        }
        showToast(message: message)
    }
}

extension View {
    func toast(message: String, isShowing: Binding<Bool>, duration: TimeInterval) -> some View {
        ZStack {
            self
            if isShowing.wrappedValue {
                Text(message)
                    .font(.body)
                    .padding()
                    .background(Color.black)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.bottom, 20)
                    .accessibilityIdentifier("ToastMessage")
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                            withAnimation {
                                isShowing.wrappedValue = false
                            }
                        }
                    }
                .transition(.opacity)
            }
        }
    }
}
