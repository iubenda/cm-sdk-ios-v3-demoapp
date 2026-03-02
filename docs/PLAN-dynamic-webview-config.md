# Plan: Dynamic CMP Webview Configuration

## Overview
Add an initial configuration screen to the demo app that collects Code-ID, language, position, background style, and other webview options. After the user enters all info, the CMP SDK is loaded with the dynamic configuration.

## Implementation Status: COMPLETE

### Files Created
- `CMPConfiguration.swift` - Model with WebviewPosition, WebviewBackgroundStyle, conversion to SDK types
- `ConfigurationView.swift` - Form UI for all config options

### Files Modified
- `ConsentManager.swift` - Added `configure(with:)`, removed hardcoded setup
- `ContentView.swift` - New flow: ConfigurationView → ConsentView → HomeView
- `ConsentView.swift` - Simplified (config applied in ContentView)

### SDK Compatibility Notes
- SDK 3.2.0 Position: only `.fullScreen` and `.custom(CGRect)`; half screens use `.custom` with computed rects
- BackgroundStyle: `.blur(.prominent)`, `.dimmed(.black, 0.5)`, `.dimmed(.gray, 0.75)` (UIColor uses `.gray` not `.grey`)

## Current Flow
```
App Launch → ContentView → ConsentView (hardcoded config) → HomeView
```

## Target Flow
```
App Launch → ContentView → ConfigurationView (user enters config) → ConsentView (dynamic config) → HomeView
```

## Configuration Options to Expose

### UrlConfig (CMP backend)
| Field | Type | Default | UI Control |
|-------|------|---------|------------|
| Code-ID | String | "YOUR-CODE-ID-GOES-HERE" | TextField |
| Language | String | "IT" | Picker (EN, IT, DE, FR, ES, etc.) |
| App Name | String | "CMPDemoApp" | TextField |
| Domain | String | "delivery.consentmanager.net" | TextField (optional, advanced) |

### ConsentLayerUIConfig (Webview appearance)
| Field | Type | Options | UI Control |
|-------|------|---------|------------|
| Position | Enum | fullScreen, halfScreenTop, halfScreenBottom | Picker/Segmented |
| Background | Enum | blur prominent, dimmed black 0.5, dimmed grey 0.75 | Picker |
| Corner Radius | CGFloat | 0, 5, 10, 20 | Stepper or Picker |
| Respects Safe Area | Bool | false | Toggle |
| Allows Orientation Changes | Bool | true | Toggle |

## Implementation Tasks

### 1. Create CMPConfiguration Model
- Struct holding all configurable values
- Converts to UrlConfig and ConsentLayerUIConfig for SDK
- Codable for optional UserDefaults persistence (future)

### 2. Create ConfigurationView
- Form with sections: CMP Settings, Webview Appearance
- Validation: Code-ID required
- "Load CMP" button to proceed
- Default values pre-filled

### 3. Refactor ConsentManager
- Accept CMPConfiguration before setup
- `configure(with: CMPConfiguration)` or pass config at init
- Apply config via setUrlConfig/setWebViewConfig before checkAndOpen
- Defer setupCMPManager until config is available

### 4. Update ContentView Flow
- State: `hasConfiguration` (false initially)
- If !hasConfiguration → ConfigurationView
- If hasConfiguration && !isConsentInitialized → ConsentView(with config)
- If isConsentInitialized → HomeView

### 5. Wire Configuration Through
- ConfigurationView onSubmit → store config → set hasConfiguration = true
- ConsentView receives config via @Binding or @StateObject
- ConsentManager.apply(config) before initialize()

## File Changes

| File | Action |
|------|--------|
| `CMPConfiguration.swift` | Create - config model |
| `ConfigurationView.swift` | Create - config form UI |
| `ConsentManager.swift` | Modify - accept dynamic config |
| `ContentView.swift` | Modify - add config step, pass config |
| `ConsentView.swift` | Modify - accept and pass config to ConsentManager |

## Edge Cases
- Empty Code-ID: show validation error, disable "Load CMP"
- User can reset and reconfigure: add "Reconfigure" in HomeView (optional, phase 2)
