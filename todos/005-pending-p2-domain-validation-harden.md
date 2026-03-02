# 005: Harden Domain Validation

**Status:** pending  
**Priority:** p2  
**Tags:** code-review, security, validation  
**Issue ID:** 005

## Problem Statement

Domain validation blocks protocol handlers (`javascript:`, `data:`, etc.) but allows `@`, `/`, `?`, `#`, `%`, and arbitrary hostnames. If the SDK builds URLs from the domain, weak validation could enable SSRF, open redirects, or path/query injection.

## Findings

- **Location:** `CMPConfiguration.swift:84-93`
- **Current:** Blocks `javascript:`, `data:`, `vbscript:`, `file:`; length ≤253
- **Gaps:** `http://evil.com`, `host@evil.com`, `host/path?x=1`, `%2f..%2fevil.com` not blocked

## Proposed Solutions

### Option A: Strict hostname format (Recommended)
- Allow only `[a-zA-Z0-9.-]`, block `@`, `/`, `?`, `#`, `%`, null bytes
- Block `http://`, `https://` prefixes
- **Pros:** Strong security
- **Cons:** May reject edge cases

### Option B: Add blocklist for path/query chars
- Add checks for `@`, `/`, `?`, `#`, `%`
- **Pros:** Simple, reduces risk
- **Cons:** Less comprehensive than Option A

### Option C: Document as demo-only
- Add comment that production apps should use stricter validation
- **Pros:** No code change
- **Cons:** Risk remains

## Recommended Action

Option A for production readiness; Option B for minimal fix.

## Technical Details

- **Files:** `CMPConfiguration.swift`
- **Effort:** Small

## Acceptance Criteria

- [ ] Domain rejects `@`, `/`, `?`, `#`, `%`
- [ ] Domain rejects `http://`, `https://` prefixes
- [ ] Hostname uses whitelist of safe characters

## Work Log

| Date | Action |
|------|--------|
| 2026-03-02 | Created from final implementation review |
