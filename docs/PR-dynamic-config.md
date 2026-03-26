# PR: Dynamic CMP Webview Configuration

## Summary
Adds an initial configuration screen that allows users to dynamically configure the CMP webview before loading the SDK. Users can set Code-ID, language, position, background style, corner radius, and other options.

## Changes

### New Files
- **CMPConfiguration.swift** - Configuration model with `WebviewPosition` and `WebviewBackgroundStyle` enums, converts to SDK `UrlConfig` and `ConsentLayerUIConfig`
- **ConfigurationView.swift** - Form UI with sections for CMP Settings and Webview Appearance

### Modified Files
- **ConsentManager.swift** - Replaced hardcoded setup with `configure(with: CMPConfiguration)` method
- **ContentView.swift** - New flow: ConfigurationView → (Load CMP) → ConsentView → HomeView
- **ConsentView.swift** - Simplified; configuration is applied in ContentView before showing consent

## User Flow
1. App launches → **ConfigurationView** (form with Code-ID, Language, App Name, Domain, Position, Background, Corner Radius, toggles)
2. User taps "Load CMP" → **ConsentView** (CMP SDK loads with dynamic config, shows consent layer if needed)
3. After consent → **HomeView** (existing demo actions)

## Configuration Options
| Option | Type | Default |
|--------|------|---------|
| Code-ID | Text | YOUR-CODE-ID-GOES-HERE |
| Language | Picker | IT (EN, DE, FR, ES, PT, NL, PL) |
| App Name | Text | CMPDemoApp |
| Domain | Text | delivery.consentmanager.net |
| Position | Picker | Full Screen, Half Screen (Top), Half Screen (Bottom) |
| Background | Picker | Blur (Prominent), Dimmed (Black 50%), Dimmed (Grey 75%) |
| Corner Radius | Stepper | 0–30, step 5 |
| Respects Safe Area | Toggle | false |
| Allows Orientation Changes | Toggle | true |

## Feature Video
To record a feature video:
1. Launch the app in the iOS Simulator
2. Show the Configuration screen with all options
3. Enter a Code-ID (or use placeholder for demo)
4. Change language, position, background
5. Tap "Load CMP" and show the consent flow
6. Demonstrate HomeView with CMP actions

## Testing
- Build: `xcodebuild -scheme CMPSDKDemoApp -destination 'platform=iOS Simulator,id=614C859C-0198-4223-A1CA-169010AA9AA6' build`
- App launches and shows ConfigurationView first
- "Load CMP" proceeds to ConsentView with applied config
