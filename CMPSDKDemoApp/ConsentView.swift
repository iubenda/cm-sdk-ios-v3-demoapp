//
//  ConsentView.swift
//  CMPSDKDemoApp
//
//  Created by Fabio Torre on 18/02/25.
//

import SwiftUI

struct ConsentView: UIViewControllerRepresentable {
    @Binding var isInitialized: Bool

    func makeUIViewController(context: Context) -> UIViewController {
        let controller = UIViewController()
        controller.modalPresentationStyle = .fullScreen
        controller.isModalInPresentation = true

        ConsentManager.shared.initialize(from: controller) { success in
            isInitialized = success
        }

        return controller
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}
