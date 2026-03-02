//
//  CMPConfiguration.swift
//  CMPSDKDemoApp
//
//  Dynamic configuration model for CMP SDK webview.
//

import UIKit
import cm_sdk_ios_v3

/// User-facing configuration for the CMP SDK.
struct CMPConfiguration {
    var codeId: String
    var language: String
    var appName: String
    var domain: String
    var position: WebviewPosition
    var backgroundStyle: WebviewBackgroundStyle
    var cornerRadius: CGFloat
    var respectsSafeArea: Bool
    var allowsOrientationChanges: Bool

    static let `default` = CMPConfiguration(
        codeId: "YOUR-CODE-ID-GOES-HERE",
        language: "IT",
        appName: "CMPDemoApp",
        domain: "delivery.consentmanager.net",
        position: .fullScreen,
        backgroundStyle: .blurProminent,
        cornerRadius: 0,
        respectsSafeArea: false,
        allowsOrientationChanges: true
    )

    private var trimmedCodeId: String { codeId.trimmingCharacters(in: .whitespaces) }

    var isValid: Bool { validationError == nil }

    var validationError: String? {
        if trimmedCodeId.isEmpty { return "Code-ID is required" }
        if !CMPConfiguration.isValidCodeId(trimmedCodeId) {
            return "Code-ID must be alphanumeric with hyphens only, max 64 characters"
        }
        if !CMPConfiguration.isValidDomain(domain) {
            return "Domain must be a valid hostname (letters, numbers, dots, hyphens only)"
        }
        if !CMPConfiguration.isValidAppName(appName) {
            return "App Name must be alphanumeric with spaces/hyphens/underscores, max 128 characters"
        }
        return nil
    }

    func toUrlConfig() -> UrlConfig {
        UrlConfig(
            id: trimmedCodeId,
            domain: domain.trimmingCharacters(in: .whitespaces),
            language: language,
            appName: appName.trimmingCharacters(in: .whitespaces)
        )
    }

    func toConsentLayerUIConfig() -> ConsentLayerUIConfig {
        ConsentLayerUIConfig(
            position: position.toSDKPosition(),
            backgroundStyle: backgroundStyle.toSDKBackgroundStyle(),
            cornerRadius: cornerRadius,
            respectsSafeArea: respectsSafeArea,
            allowsOrientationChanges: allowsOrientationChanges
        )
    }

    private static func isValidCodeId(_ value: String) -> Bool {
        guard value.count <= 64 else { return false }
        let allowed = CharacterSet.alphanumerics.union(CharacterSet(charactersIn: "-"))
        return value.unicodeScalars.allSatisfy { allowed.contains($0) }
    }

    private static func isValidDomain(_ value: String) -> Bool {
        let trimmed = value.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty, trimmed.count <= 253 else { return false }
        let lower = trimmed.lowercased()
        if lower.hasPrefix("javascript:") || lower.hasPrefix("data:") ||
           lower.hasPrefix("vbscript:") || lower.hasPrefix("file:") ||
           lower.hasPrefix("http://") || lower.hasPrefix("https://") {
            return false
        }
        let hostnameChars = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyz0123456789.-")
        guard lower.unicodeScalars.allSatisfy({ hostnameChars.contains($0) }) else { return false }
        let forbidden = CharacterSet(charactersIn: "@/?#%\0")
        return trimmed.unicodeScalars.allSatisfy { !forbidden.contains($0) }
    }

    private static func isValidAppName(_ value: String) -> Bool {
        let trimmed = value.trimmingCharacters(in: .whitespaces)
        guard trimmed.count <= 128 else { return false }
        let allowed = CharacterSet.alphanumerics.union(CharacterSet(charactersIn: " -_"))
        return trimmed.unicodeScalars.allSatisfy { allowed.contains($0) }
    }
}

// MARK: - Webview Position
// SDK supports .fullScreen and .custom(CGRect). Half screens use .custom with computed rects.

enum WebviewPosition: String, CaseIterable, Identifiable {
    case fullScreen = "Full Screen"
    case halfScreenTop = "Half Screen (Top)"
    case halfScreenBottom = "Half Screen (Bottom)"

    var id: String { rawValue }

    func toSDKPosition() -> ConsentLayerUIConfig.Position {
        switch self {
        case .fullScreen:
            return .fullScreen
        case .halfScreenTop:
            let bounds = UIScreen.main.bounds
            return .custom(CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height / 2))
        case .halfScreenBottom:
            let bounds = UIScreen.main.bounds
            return .custom(CGRect(x: 0, y: bounds.height / 2, width: bounds.width, height: bounds.height / 2))
        }
    }
}

// MARK: - Webview Background Style

enum WebviewBackgroundStyle: String, CaseIterable, Identifiable {
    case blurProminent = "Blur (Prominent)"
    case dimmedBlack = "Dimmed (Black 50%)"
    case dimmedGrey = "Dimmed (Grey 75%)"

    var id: String { rawValue }

    func toSDKBackgroundStyle() -> ConsentLayerUIConfig.BackgroundStyle {
        switch self {
        case .blurProminent: return .blur(.prominent)
        case .dimmedBlack: return .dimmed(.black, 0.5)
        case .dimmedGrey: return .dimmed(.gray, 0.75)
        }
    }
}
