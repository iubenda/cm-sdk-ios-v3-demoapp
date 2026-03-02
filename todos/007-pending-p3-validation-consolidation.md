# 007: Consolidate Validation Logic

**Status:** pending  
**Priority:** p3  
**Tags:** code-review, quality, refactor  
**Issue ID:** 007

## Problem Statement

`isValid` and `validationError` in CMPConfiguration duplicate the same validation checks. Single source of truth would reduce maintenance and bugs.

## Findings

- **Location:** `CMPConfiguration.swift:37-56`
- **Current:** `isValid` runs 4 guards; `validationError` runs same 4 checks
- **Dead code:** `ConfigurationView` alert uses `validationError ?? "fallback"` but fallback is never used when alert is shown

## Proposed Solutions

### Option A: Derive isValid from validationError
```swift
var isValid: Bool { validationError == nil }
```
- **Pros:** Single source of truth
- **Cons:** validationError computed on each isValid call (negligible)

### Option B: Keep both, extract shared logic
- Private method returns validation result; both use it
- **Pros:** Explicit
- **Cons:** More code

## Recommended Action

Option A. Also simplify alert: `Text(configuration.validationError ?? "")` or force-unwrap since alert only shows when invalid.

## Technical Details

- **Files:** `CMPConfiguration.swift`, `ConfigurationView.swift`
- **Effort:** Small

## Acceptance Criteria

- [ ] isValid has no duplicated validation logic
- [ ] Alert message uses validationError without dead fallback

## Work Log

| Date | Action |
|------|--------|
| 2026-03-02 | Created from final implementation review |
