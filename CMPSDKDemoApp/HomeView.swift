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
    @State private var isDarkMode = false

    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                ScrollView {
                    VStack(spacing: 20) {
                        Text("CM Swift DemoApp")
                            .font(.largeTitle)
                            .padding()

                        Button(action: {
                            let status = CMPManager.shared.getUserStatus()
                            var message = "Status: \(status.status)\n\n"
                            
                            message += "Vendors:\n"
                            for (vendorId, state) in status.vendors {
                                message += "- \(vendorId): \(state)\n"
                            }
                            
                            message += "\nPurposes:\n"
                            for (purposeId, state) in status.purposes {
                                message += "- \(purposeId): \(state)\n"
                            }
                            
                            message += "\nTCF: \(status.tcf)\n"
                            message += "Additional Consent: \(status.addtlConsent)\n"
                            message += "Regulation: \(status.regulation)"

                            print(message)
                            showToast(message: "Check logs for the User Status")
                        }) {
                            Text("Get User Status")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .accessibilityIdentifier("Get User Status")
                        }

                        Button(action: {
                            let cmpString = CMPManager.shared.exportCMPInfo()
                            print("Exported CMP String: \(cmpString)")
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
                            let purposeStatus = CMPManager.shared.getStatusForPurpose(id: "c53")
                            var message = "Purpose c53 status: "
                            switch purposeStatus {
                            case .choiceDoesntExist: message += "No Choice"
                            case .granted: message += "Granted"
                            case .denied: message += "Denied"
                            @unknown default:
                                message += "No Choice"
                            }
                            showToast(message: message)
                        }) {
                            Text("Status for Purpose c53")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.mint)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                            .accessibilityIdentifier("Has Purpose ID c53?")
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
                            let vendorStatus = CMPManager.shared.getStatusForVendor(id: "s2789")
                            var message = "Vendor s2789 status: "
                            switch vendorStatus {
                            case .choiceDoesntExist: message += "No choice"
                            case .denied: message += "Denied"
                            case .granted: message += "Granted"
                            @unknown default: message += "No choice"
                            }
                            showToast(message: message)
                        }) {
                            Text("Status for Vendor ID s2789")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.cyan)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .accessibilityIdentifier("Has Vendor ID s2789?")
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
                            CMPManager.shared.checkAndOpen(){ error in
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
                            CMPManager.shared.forceOpen(){ error in
                                if let error = error {
                                    print("HomeView: Open Consent Layer operation failed with error \(error)")
                                } else {
                                    print("HomeView: Consent Layer opened succesfully in the DemoApp.")
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
                            showToast(message: "Google Consent Mode Status: \n \(CMPManager.shared.getGoogleConsentModeStatus())")
                        }) { Text("Get Google Consent Mode")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.indigo)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .accessibilityIdentifier( "Get Google Consent Mode")
                        }
                        
                        Button(action: {
                            CMPManager.shared.forceOpen(jumpToSettings: true){ error in
                                if let error = error {
                                    showToast(message: "Error: \(error.localizedDescription)")
                                } else {
                                    showToast(message: "Opening CMP Settings")
                                }
                            }
                        }) {
                            Text("Jump to CMP Settings")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.indigo)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        
                        Button(action: {
                            CMPManager.shared.importCMPInfo("Q1FMVW10Z1FMVW10Z0FmUTVDSVRCWUZnQUFBQUFBQUFBQWlnS3dOWF9HX19iWGx2LVg3MzZmdGtlWTFmOTloNzdzUXhCaGZKcy00RnpMdldfSndYMzJFek5FMzZ0cVlLbVJJQXUzVEJJUU50R0pqVVJWQ2hhb2dWcnpEc2FFeVVvVHRLSi1Ca2lITVJZMmRZQ0Z4dm00dGplUUNaNXZyXzkxZDUyUl90N2RyLTNkenl5NWhudjNhOV8tUzFXSmlkSzUtdEhfdjliUk9iLV9JLTlfeC1fNHY0X05fcEUyX2VUMXRfdFd2dDczOS04dHZfOV9fOTlfX19fZl9fX19fXzNfLV9mX19mX19fOEZYd0NURFFxSUF5d0pDUWcwRENDQkFDb0t3Z0lvRUFRQUFKQTBRRUFKZ3dLZGdZQUxyQ1JBQ0FGQUFNRUFJQUFRWkFBZ0FBQWdBUWlBQ0FBb0VBQUVBZ1VBQVlBRUF3RUFCQXdBQWdBc0JBSUFBUUhRTVV3SUlCQXNBRWpNaW9Vd0lRZ0VnZ0piS2hCSUFnUVZ3aENMUEFJZ0VSTUZBQUFBQUFVZ0FDQXNGZ2NTU0FsUWtFQVhFRzBBQUJBQWdFRUFCUWdrNU1BQVFCbXkxQjRNRzBaV21BWVBtQ1JEVEFNZ0NJSXlFZzBBQUEjXzUxXzUyXzUzXzU0XzU1XzU2XyNfczI4MTVfYzY0MDQzX3MyODE0X3MyNzYyX3MyODg1X3MyODE5X3MyODQ2X3MzMDM1X3MyNDM0X1VfIzEtLS0j"){ error in
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
                                .background(Color.black)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .accessibilityIdentifier("Reset all CMP Info")
                        }
                        
                        Button(action: {
                            retrieveUserPreferences()
                        }) {
                            Text("Get CMP Preferences")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.gray)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .accessibilityIdentifier("Get CMP Preferences")
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
    
    private func retrieveUserPreferences() {
        let userDefaults = UserDefaults.standard
        let allKeys = userDefaults.dictionaryRepresentation().keys

        print("=================")
        print("User Preferences:")
        for key in allKeys {
            if let value = userDefaults.object(forKey: key) {
                print("\(key): \(value)")
            }
        }

        showToast(message: "Check the logs for the key/values from User Preferences")
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
