# 008: Fix Accessibility Identifier Typo

**Status:** complete  
**Priority:** p3  
**Tags:** code-review, accessibility, quality  
**Issue ID:** 008

## Problem Statement

The "Get Google Consent Mode" button has a leading space in its accessibility identifier: `.accessibilityIdentifier( "Get Google Consent Mode")` — space between `(` and `"`.

## Findings

- **Location:** `HomeView.swift:262`
- **Current:** `accessibilityIdentifier( "Get Google Consent Mode")`
- **Expected:** `accessibilityIdentifier("Get Google Consent Mode")`

## Proposed Solutions

Remove the leading space in the string argument.

## Recommended Action

Apply fix.

## Technical Details

- **Files:** `HomeView.swift`
- **Effort:** Trivial

## Acceptance Criteria

- [ ] No extra space in accessibility identifier

## Work Log

| Date | Action |
|------|--------|
| 2026-03-02 | Created from final implementation review |
