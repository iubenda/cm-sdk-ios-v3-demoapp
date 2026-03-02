# 001: UI Tests Broken by New Configuration Flow

**Status:** complete  
**Priority:** p1  
**Tags:** code-review, testing, ui-tests  
**Issue ID:** 001

## Problem Statement

The app now starts on `ConfigurationView` instead of going directly to `ConsentView` or `HomeView`. All existing UI tests assume the app launches into `HomeView` and look for buttons like "Open Consent Layer", "Get CMP String", etc. These tests will fail because:
1. On launch, the app shows ConfigurationView (Code-ID, Language, etc.)
2. Tests never navigate through the config → Load CMP → consent flow

## Findings

- **Location:** `CMPSDKDemoAppUITests/CMPSDKDemoAppUITests.swift`
- **Affected tests:** `testOpenConsentLayer`, `testOpenConsentLayerAndRejectAll`, `testOpenConsentLayerAndAcceptAll`, `testHasUserChoice`, `testGetCMPString`, `testAllPurposes`
- **Root cause:** App flow changed from `ConsentView → HomeView` to `ConfigurationView → ConsentView → HomeView`
- **Additional:** Tests reference buttons that don't exist in HomeView: "Get Disabled Purposes", "Get Enabled Purposes", "Has User Choice?", "Get All Purposes"

## Proposed Solutions

### Option A: Add launch argument to skip config (Recommended)
- Add `--skip-config` launch argument; when set, ContentView shows ConsentView directly with default config
- UI tests launch with this argument to preserve old behavior
- **Pros:** Minimal test changes, fast fix
- **Cons:** Tests don't exercise the new config flow

### Option B: Update tests for full flow
- Tests first fill ConfigurationView (Code-ID, tap Load CMP), then handle consent, then HomeView
- **Pros:** Full coverage of new flow
- **Cons:** Longer, more brittle tests; need valid Code-ID or mock

### Option C: Disable/skip failing tests temporarily
- Mark tests as skipped with `XCTSkip` until fixed
- **Pros:** Unblocks CI
- **Cons:** No test coverage

## Recommended Action

Implement Option A: add `--skip-config` and use it in UI tests. Optionally add one smoke test that exercises the full config flow.

## Technical Details

- **Files:** `ContentView.swift`, `CMPSDKDemoAppUITests.swift`, `CMPSDKDemoApp.xcodeproj` (launch arguments)
- **Effort:** Small

## Acceptance Criteria

- [ ] UI tests pass (or are explicitly skipped with tracking issue)
- [ ] At least one test verifies ConfigurationView appears on fresh launch
- [ ] Launch argument documented

## Work Log

| Date | Action |
|------|--------|
| 2026-03-02 | Created from code review |
