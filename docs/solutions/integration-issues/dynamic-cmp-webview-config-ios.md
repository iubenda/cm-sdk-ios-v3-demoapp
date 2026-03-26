---
title: "Dynamic CMP Webview Configuration in iOS Demo App"
date: "2026-03-02"
problem_type: "Feature implementation + code review hardening"
component: "iOS SwiftUI demo app for CMP SDK v3 (cm-sdk-ios-v3-demoapp)"
tags:
  - cm-sdk
  - ios
  - swiftui
  - cmp
  - webview
  - configuration
  - validation
  - security
related_docs:
  - docs/PLAN-dynamic-webview-config.md
  - docs/PR-dynamic-config.md
---

# Dynamic CMP Webview Configuration in iOS Demo App

## Problem

The CMP SDK demo app used hardcoded configuration. There was no way to:
- Collect Code-ID, language, position, background, and other settings from the user
- Load the CMP SDK with dynamic configuration
- Validate configuration before applying it to the SDK

Additionally, code review identified security and robustness gaps: sensitive data logging, weak domain validation, and no validation boundary at the SDK integration point.

## Root Cause

- **Hardcoded configuration**: CMP SDK was initialized with fixed values (Code-ID, domain, app name, etc.) inside `ConsentManager`.
- **No validation boundary**: Config was passed straight to the SDK without checks, so invalid or unsafe values could reach it.

## Solution

### 1. CMPConfiguration Model with Validation

A `CMPConfiguration` struct holds Code-ID, language, app name, domain, position, background style, corner radius, and toggles. Validation rules:

| Field | Rules |
|-------|-------|
| Code-ID | Required, alphanumeric + hyphens, max 64 chars |
| Domain | Hostname only (letters, numbers, dots, hyphens); blocks `javascript:`, `data:`, `http://`, `https://`, and `@`, `/`, `?`, `#`, `%` |
| App Name | Alphanumeric + spaces/hyphens/underscores, max 128 chars |

`toUrlConfig()` and `toConsentLayerUIConfig()` map to SDK types. `WebviewPosition` and `WebviewBackgroundStyle` enums map to SDK position/background.

### 2. ConfigurationView Form

Form with sections: CMP Settings (Code-ID, Language, App Name, Domain) and Webview Appearance (Position, Background, Corner Radius, toggles). "Load CMP" button calls `onContinue` only when `configuration.isValid`; otherwise shows validation alert. Accessibility identifiers on all controls.

### 3. ConsentManager.configure(with:)

`configure(with: CMPConfiguration)` replaces hardcoded setup. Full setup deferred until `configure(with:)` is called. **Defensive validation** at the boundary:

```swift
func configure(with config: CMPConfiguration) {
    guard config.isValid else {
        assertionFailure("Invalid CMPConfiguration passed to configure")
        return
    }
    cmpManager.setUrlConfig(config.toUrlConfig())
    cmpManager.setWebViewConfig(config.toConsentLayerUIConfig())
}
```

### 4. Flow: ConfigurationView → ConsentView → HomeView

`ContentView` manages state: `configuration`, `hasConfiguration`, `isConsentInitialized`. Flow:

- If `!hasConfiguration` → `ConfigurationView`
- If `hasConfiguration && !isConsentInitialized` → `ConsentView`
- If `isConsentInitialized` → `HomeView`

### 5. Code Review Fixes

| Fix | Implementation |
|-----|----------------|
| **`--skip-config` for UI tests** | `LaunchArguments.skipConfig`; when present, `onAppear` configures with default and sets `hasConfiguration = true` so tests skip config screen |
| **Domain validation hardening** | `isValidDomain` blocks protocol prefixes and `@`, `/`, `?`, `#`, `%`; hostname whitelist `[a-z0-9.-]` |
| **`#if DEBUG` for sensitive logging** | Consent strings, errors, UserDefaults dump, and CMP string export wrapped in `#if DEBUG` |
| **ConsentManager guard `config.isValid`** | `guard config.isValid else { assertionFailure(...); return }` before applying config |
| **CMP string toast truncation** | Toast shows first 50 chars + "…" instead of full consent string |

### 6. Code Examples

**Flow and skip-config:**

```swift
// ContentView.swift
private var skipConfig: Bool {
    ProcessInfo.processInfo.arguments.contains(LaunchArguments.skipConfig)
}
// ...
if !hasConfiguration { ConfigurationView(...) }
else if hasConfiguration && !isConsentInitialized { ConsentView(...) }
else { HomeView() }
.onAppear {
    if skipConfig {
        ConsentManager.shared.configure(with: configuration)
        hasConfiguration = true
    }
}
```

**CMP string toast truncation:**

```swift
// HomeView.swift - Get CMP String button
let cmpString = CMPManager.shared.exportCMPInfo()
#if DEBUG
print("Exported CMP String: \(cmpString)")
#endif
let display = cmpString.count > 50 ? String(cmpString.prefix(50)) + "…" : cmpString
showToast(message: "CMP String: \(display)")
```

## Prevention & Best Practices

### Validate at Boundaries

Treat `ConsentManager` as the boundary between app and SDK. All configuration must be validated before it reaches the SDK. Never bypass `ConsentManager` and set SDK config directly.

### Guard Sensitive Logging

Wrap consent strings, UserDefaults dumps, and error messages that may contain user/config data in `#if DEBUG`. Prefer "Check logs" or truncated strings in UI instead of full consent strings.

### Harden Input Validation

- **Domain**: Allow only `[a-zA-Z0-9.-]`; reject protocol prefixes and `@`, `/`, `?`, `#`, `%`; max 253 chars
- **Code-ID**: Alphanumeric and hyphens only; max 64 chars; trim whitespace
- **App Name**: Alphanumeric, spaces, hyphens, underscores; max 128 chars

### Test Strategies

- **`--skip-config`**: Use `app.launchArguments = ["--skip-config"]` for UI tests that focus on consent/HomeView
- **Config flow tests**: Launch without `--skip-config` to test `testConfigurationScreenOnFreshLaunch`
- **Validation unit tests**: Cover `CMPConfiguration` for valid and invalid inputs (empty Code-ID, invalid chars, protocol in domain, etc.)

## Related Documentation

- [PLAN-dynamic-webview-config.md](../../PLAN-dynamic-webview-config.md) – Design and implementation plan
- [PR-dynamic-config.md](../../PR-dynamic-config.md) – PR description and file changes

## Files Changed

| File | Role |
|------|------|
| `CMPConfiguration.swift` | Config model, validation, SDK mapping |
| `ConfigurationView.swift` | Form UI |
| `ConsentManager.swift` | `configure(with:)`, defensive guard |
| `ContentView.swift` | Flow orchestration, `--skip-config` |
| `ConsentView.swift` | Consent layer presentation |
| `HomeView.swift` | Sensitive logging guards, toast truncation |
