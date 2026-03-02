# 002: Input Validation for Configuration Fields

**Status:** complete  
**Priority:** p2  
**Tags:** code-review, security, validation  
**Issue ID:** 002

## Problem Statement

`ConfigurationView` accepts user input for Code-ID, Domain, and App Name with minimal validation. These values are passed directly to the CMP SDK's `UrlConfig`. Malicious input could enable URL injection, open redirects, or SSRF if the SDK builds URLs from these values.

## Findings

- **Code-ID:** Only checks non-empty; no length limit, format, or character whitelist
- **Domain:** No validation; arbitrary domains (e.g. `evil.com`, `javascript:...`) can be used
- **App Name:** No length or character restrictions
- **Language:** Safe (picker with fixed options)

## Proposed Solutions

### Option A: Strict validation (Recommended for production)
- Domain: Allowlist `delivery.consentmanager.net` (and any other known CMP domains)
- Code-ID: Alphanumeric + hyphens, max 64 chars
- App Name: Alphanumeric + spaces/hyphens/underscores, max 128 chars
- **Pros:** Strong security
- **Cons:** May block valid edge cases; demo app may want flexibility

### Option B: Basic sanitization
- Reject protocol handlers in domain (`javascript:`, `data:`)
- Limit lengths (Code-ID 128, Domain 253, App Name 128)
- **Pros:** Reduces risk, allows custom domains for testing
- **Cons:** Weaker than allowlist

### Option C: Document as demo-only
- Add comment that this is a demo app; production apps should validate
- **Pros:** No code change
- **Cons:** Risk remains if code is copied

## Recommended Action

For a **demo app**: Option B (basic sanitization) or Option C. For production use: Option A.

## Technical Details

- **Files:** `CMPConfiguration.swift`, `ConfigurationView.swift`
- **Effort:** Small–Medium

## Acceptance Criteria

- [ ] Domain cannot be `javascript:`, `data:`, or other protocol handlers
- [ ] Length limits enforced (or documented)
- [ ] Invalid config shows user-friendly error

## Work Log

| Date | Action |
|------|--------|
| 2026-03-02 | Created from code review |
