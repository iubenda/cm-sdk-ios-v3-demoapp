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
        // Defer full setup until configure(with:) is called
        CMPManager.shared.delegate = self
    }
    
    /// Applies dynamic configuration and prepares the CMP SDK.
    func configure(with config: CMPConfiguration) {
        guard config.isValid else {
            assertionFailure("Invalid CMPConfiguration passed to configure")
            return
        }
        let cmpManager = CMPManager.shared
        cmpManager.setUrlConfig(config.toUrlConfig())
        cmpManager.setWebViewConfig(config.toConsentLayerUIConfig())
    }
    
    func initialize(from viewController: UIViewController, completion: @escaping (Bool) -> Void) {
        self.completionHandler = completion
        CMPManager.shared.setPresentingViewController(viewController)
        CMPManager.shared.checkAndOpen { [weak self] error in
            if let error = error {
                #if DEBUG
                print("DemoApp: Error initializing consent: \(error)")
                #endif
                self?.completionHandler?(false)
            }
        }
    }
    
    // MARK: - CMPManagerDelegate
    
    func didReceiveConsent(consent: String, jsonObject: [String : Any]) {
        #if DEBUG
        print("DemoApp: Consent received: \(consent)")
        #endif
    }
    
    func didShowConsentLayer() {
        #if DEBUG
        print("DemoApp: Consent layer shown")
        #endif
    }
    
    func didCloseConsentLayer() {
        print("DemoApp: Consent layer closed")
        completionHandler?(true)
    }
    
    func didReceiveError(error: String) {
        #if DEBUG
        print("DemoApp: Error received \(error)")
        #endif
        completionHandler?(false)
    }

    func didChangeATTStatus(oldStatus: Int, newStatus: Int, lastUpdated: Date?) {
        #if DEBUG
        print("DemoApp: ATT Status changed.")
        #endif
    }
}
