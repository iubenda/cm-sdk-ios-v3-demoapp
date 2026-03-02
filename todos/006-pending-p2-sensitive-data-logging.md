# 006: Guard Sensitive Data Logging

**Status:** pending  
**Priority:** p2  
**Tags:** code-review, security, logging  
**Issue ID:** 006

## Problem Statement

Consent strings and UserDefaults are printed to the console. Consent data can be used for fingerprinting; logs may be collected or shared. This is a privacy/compliance risk in production.

## Findings

- **ConsentManager.swift:43** – `print("DemoApp: Consent received: \(consent)")`
- **HomeView** – `print("Exported CMP String: \(cmpString)")`, toast shows full consent string
- **HomeView** – UserDefaults dump prints all keys/values
- **ConsentManager** – Error messages printed

## Proposed Solutions

### Option A: #if DEBUG guards (Recommended)
- Wrap all consent-related prints in `#if DEBUG`
- Restrict UserDefaults dump to debug
- **Pros:** Safe in production, useful for development
- **Cons:** Slightly more code

### Option B: Remove entirely
- Remove consent/UserDefaults logging
- **Pros:** Simplest
- **Cons:** Harder to debug

### Option C: Log levels
- Use a logging framework with levels; set production to exclude sensitive
- **Pros:** Flexible
- **Cons:** More infrastructure

## Recommended Action

Option A – guard with `#if DEBUG`.

## Technical Details

- **Files:** `ConsentManager.swift`, `HomeView.swift`
- **Effort:** Small

## Acceptance Criteria

- [ ] No consent strings logged in release builds
- [ ] UserDefaults dump restricted to debug
- [ ] Toast for CMP string: consider truncating or "Check logs" only

## Work Log

| Date | Action |
|------|--------|
| 2026-03-02 | Created from final implementation review |
