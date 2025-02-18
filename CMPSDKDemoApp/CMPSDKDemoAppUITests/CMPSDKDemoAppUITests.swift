//
//  CMPSDKDemoAppUITests.swift
//  CMPSDKDemoAppUITests
//
//  Created by Fabio Torre on 20/01/25.
//

import XCTest

final class CMPSDKDemoAppUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    @MainActor
    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    @MainActor
    func testOpenConsentLayer() throws {
        let openConsentLayerButton = app.buttons["Open Consent Layer"]
        XCTAssertTrue(openConsentLayerButton.waitForExistence(timeout: 5), "Open Consent Layer button not found")
        openConsentLayerButton.tap()
        
        let webView = app.webViews.firstMatch
        XCTAssertTrue(webView.waitForExistence(timeout: 10), "WebView did not appear")
    }
    
    @MainActor
    func testOpenConsentLayerAndRejectAll() throws {
        let openConsentLayerButton = app.buttons["Open Consent Layer"]
        XCTAssertTrue(openConsentLayerButton.waitForExistence(timeout: 15), "Open Consent Layer button not found")
        openConsentLayerButton.tap()
        
        let webView = app.webViews.firstMatch
        XCTAssertTrue(webView.waitForExistence(timeout: 15), "WebView did not appear")
        
        let rejectAllButton = webView.buttons["Rifiuta tutto"]
        
        XCTAssertTrue(rejectAllButton.waitForExistence(timeout: 15), "Reject All button not found in WebView")
        
        rejectAllButton.tap()
        
        let getDisabledPurposesButton = app.buttons["Get Disabled Purposes"]
        XCTAssertTrue(getDisabledPurposesButton.waitForExistence(timeout: 15), "Get Disabled Purposes button not found after rejecting all")
        
        getDisabledPurposesButton.tap()
        
        let toastMessage = app.staticTexts.element(matching: .any, identifier: "ToastMessage")
        
        XCTAssertTrue(toastMessage.waitForExistence(timeout: 15), "Toast message not found")
        XCTAssertFalse(toastMessage.label.contains("Disabled Purposes: []"), "Disabled purposes list should not be empty after rejecting all")
    }
    
    @MainActor
    func testOpenConsentLayerAndAcceptAll() throws {
        let openConsentLayerButton = app.buttons["Open Consent Layer"]
        XCTAssertTrue(openConsentLayerButton.waitForExistence(timeout: 15), "Open Consent Layer button not found")
        openConsentLayerButton.tap()
        
        let webView = app.webViews.firstMatch
        XCTAssertTrue(webView.waitForExistence(timeout: 15), "WebView did not appear")
        
        let acceptAllButton = webView.buttons["Accetta tutto"] // In case it's recognized as a link
        
        XCTAssertTrue(acceptAllButton.waitForExistence(timeout: 15), "Accept All button not found in WebView")
        
        acceptAllButton.tap()
        
        let getEnabledPurposesButton = app.buttons["Get Enabled Purposes"]
        XCTAssertTrue(getEnabledPurposesButton.waitForExistence(timeout: 15), "Get Enabled Purposes button not found after accepting all")
        
        getEnabledPurposesButton.tap()
        
        let toastMessage = app.staticTexts.element(matching: .any, identifier: "ToastMessage")
        
        XCTAssertTrue(toastMessage.waitForExistence(timeout: 15), "Toast message not found")
        XCTAssertFalse(toastMessage.label.contains("Enabled Purposes: []"), "Enabled purposes list should not be empty after accepting all")
    }
    
    @MainActor
    func testHasUserChoice() throws {
        let hasUserChoiceButton = app.buttons["Has User Choice?"]
        XCTAssertTrue(hasUserChoiceButton.waitForExistence(timeout: 15), "Has User Choice? button not found")
        hasUserChoiceButton.tap()
        
        let toastMessage = app.staticTexts.element(matching: .any, identifier: "ToastMessage")
        
        XCTAssertTrue(toastMessage.waitForExistence(timeout: 15), "Toast message not found")
        XCTAssertTrue(toastMessage.label.contains("true"), "Should have user choice")
    }
    
    @MainActor
    func testGetCMPString() throws {
        let getCMPStringButton = app.buttons["Get CMP String"]
        XCTAssertTrue(getCMPStringButton.waitForExistence(timeout: 15), "Get CMP String button not found")
        getCMPStringButton.tap()
        
        let toastMessage = app.staticTexts.element(matching: .any, identifier: "ToastMessage")
        
        XCTAssertTrue(toastMessage.waitForExistence(timeout: 15), "Toast message not found")
        XCTAssertTrue(toastMessage.label.contains("String: Q1"), "Should have user choice")
    }
    
    @MainActor
    func testAllPurposes() throws {
        let getAllPurposesButton = app.buttons["Get All Purposes"]
        XCTAssertTrue(getAllPurposesButton.waitForExistence(timeout: 15), "Get All Purposes button not found")
        getAllPurposesButton.tap()

        let toastMessage = app.staticTexts.element(matching: .any, identifier: "ToastMessage")
        
        XCTAssertTrue(toastMessage.waitForExistence(timeout: 15), "Toast message not found")
        XCTAssertTrue(toastMessage.label.contains("c51"), "Should have user choice")
    }

}
