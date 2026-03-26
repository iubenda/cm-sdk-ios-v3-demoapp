# 009: Add Defensive Validation in ConsentManager.configure

**Status:** pending  
**Priority:** p3  
**Tags:** code-review, security, defense-in-depth  
**Issue ID:** 009

## Problem Statement

`ConsentManager.configure(with:)` does not validate the config. If a future caller bypasses the UI and passes invalid config, it would be applied to the SDK. Defense in depth recommends validating at the boundary.

## Findings

- **Location:** `ConsentManager.swift:23-27`
- **Current:** Config passed directly to SDK
- **Risk:** Low for current code (only ContentView and onAppear call it with valid config)

## Proposed Solutions

### Option A: Add guard with assertionFailure
```swift
guard config.isValid else {
    assertionFailure("Invalid CMPConfiguration passed to configure")
    return
}
```
- **Pros:** Catches bugs in debug
- **Cons:** Silent no-op in release

### Option B: Add guard with return, log in debug
- Same as A but also print in debug
- **Pros:** Visible in development
- **Cons:** Slightly more code

### Option C: Skip
- Current callers are trusted
- **Pros:** No change
- **Cons:** No defense if code evolves

## Recommended Action

Option A for defense in depth.

## Technical Details

- **Files:** `ConsentManager.swift`
- **Effort:** Small

## Acceptance Criteria

- [ ] configure() validates config before applying
- [ ] Invalid config does not reach SDK

## Work Log

| Date | Action |
|------|--------|
| 2026-03-02 | Created from final implementation review |
