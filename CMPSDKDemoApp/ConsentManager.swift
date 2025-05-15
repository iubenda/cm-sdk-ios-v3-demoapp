//
//  ConsentManager.swift
//  CMPSDKDemoApp
//
//  Created by Fabio Torre on 18/02/25.
//

import SwiftUI
import cm_sdk_ios_v3

class ConsentManager: NSObject, CMPManagerDelegate {
    
    static let shared = ConsentManager()
    private var completionHandler: ((Bool) -> Void)?
    
    private override init() {
        super.init()
        setupCMPManager()
    }
    
    private func setupCMPManager() {
        let cmpManager = CMPManager.shared
        cmpManager.delegate = self
        
        let webViewConfig = ConsentLayerUIConfig(
            position: .fullScreen,
            backgroundStyle: .blur(.prominent),
            cornerRadius: 0,
            respectsSafeArea: false,
            allowsOrientationChanges: true
        )
        
        cmpManager.setUrlConfig(UrlConfig(
            id: "YOUR-CODE-ID-GOES-HERE",
            domain: "delivery.consentmanager.net",
            language: "IT",
            appName: "CMPDemoApp"
        ))
        
        cmpManager.setWebViewConfig(webViewConfig)
    }
    
    func initialize(from viewController: UIViewController, completion: @escaping (Bool) -> Void) {
        self.completionHandler = completion
        CMPManager.shared.setPresentingViewController(viewController)
        CMPManager.shared.checkAndOpen { [weak self] error in
            if let error = error {
                print("DemoApp: Error initializing consent: \(error)")
                self?.completionHandler?(false)
            }
        }
    }
    
    // MARK: - CMPManagerDelegate
    
    func didReceiveConsent(consent: String, jsonObject: [String : Any]) {
        print("DemoApp: Consent received: \(consent)")
    }
    
    func didShowConsentLayer() {
        print("DemoApp: Consent layer shown")
    }
    
    func didCloseConsentLayer() {
        print("DemoApp: Consent layer closed")
        completionHandler?(true)
    }
    
    func didReceiveError(error: String) {
        print("DemoApp: Error received \(error)")
        completionHandler?(false)
    }

    func didChangeATTStatus(oldStatus: Int, newStatus: Int, lastUpdated: Date?) {
        print("DemoApp: ATT Status changed.")
    }
}
