# 004: Add Screen-Level Accessibility Identifiers

**Status:** complete  
**Priority:** p3  
**Tags:** code-review, accessibility, agent-native  
**Issue ID:** 004

## Problem Statement

Agents and UI tests cannot reliably determine which screen is currently displayed (Configuration, Consent, or Home). ContentView conditionally shows different views without screen-level identifiers.

## Findings

- **ContentView:** No identifiers on the root of each branch
- **ConsentView:** No identifier on hosting view
- **Impact:** Automation cannot reliably detect current screen state

## Proposed Solutions

### Option A: Add identifiers to each screen
- ConfigurationView root: `.accessibilityIdentifier("ConfigurationScreen")`
- ConsentView wrapper: `"ConsentScreen"`
- HomeView root: `"HomeScreen"`
- **Pros:** Enables reliable screen detection
- **Cons:** Slight boilerplate

### Option B: Skip
- Demo app may not need agent automation
- **Pros:** No change
- **Cons:** Harder to automate

## Recommended Action

Option A if UI tests or agent automation is planned.

## Technical Details

- **Files:** `ContentView.swift`, `ConfigurationView.swift`, `ConsentView.swift`, `HomeView.swift`
- **Effort:** Small

## Acceptance Criteria

- [ ] Each main screen has a unique accessibility identifier
- [ ] Tests can assert current screen

## Work Log

| Date | Action |
|------|--------|
| 2026-03-02 | Created from code review |
