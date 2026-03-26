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
        app.launchArguments = ["--skip-config"]
        app.launch()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    @MainActor
    func testExample() throws {
        let app = XCUIApplication()
        app.launchArguments = ["--skip-config"]
        app.launch()
    }

    @MainActor
    func testConfigurationScreenOnFreshLaunch() throws {
        let freshApp = XCUIApplication()
        freshApp.launch()
        let configScreen = freshApp.otherElements["ConfigurationScreen"]
        XCTAssertTrue(configScreen.waitForExistence(timeout: 5), "Configuration screen should appear on fresh launch")
    }

    @MainActor
    func testOpenConsentLayer() throws {
        let openConsentLayerButton = app.buttons["Open Consent Layer"]
        XCTAssertTrue(openConsentLayerButton.waitForExistence(timeout: 15), "Open Consent Layer button not found")
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

        let getCMPStringButton = app.buttons["Get CMP String"]
        XCTAssertTrue(getCMPStringButton.waitForExistence(timeout: 30), "Should return to HomeView after rejecting")
    }

    @MainActor
    func testOpenConsentLayerAndAcceptAll() throws {
        let openConsentLayerButton = app.buttons["Open Consent Layer"]
        XCTAssertTrue(openConsentLayerButton.waitForExistence(timeout: 15), "Open Consent Layer button not found")
        openConsentLayerButton.tap()

        let webView = app.webViews.firstMatch
        XCTAssertTrue(webView.waitForExistence(timeout: 15), "WebView did not appear")

        let acceptAllButton = webView.buttons["Accetta tutto"]
        XCTAssertTrue(acceptAllButton.waitForExistence(timeout: 15), "Accept All button not found in WebView")
        acceptAllButton.tap()

        let getCMPStringButton = app.buttons["Get CMP String"]
        XCTAssertTrue(getCMPStringButton.waitForExistence(timeout: 30), "Should return to HomeView after accepting")
    }

    @MainActor
    func testGetUserStatus() throws {
        let getUserStatusButton = app.buttons["Get User Status"]
        XCTAssertTrue(getUserStatusButton.waitForExistence(timeout: 15), "Get User Status button not found")
        getUserStatusButton.tap()

        let toastMessage = app.staticTexts.element(matching: .any, identifier: "ToastMessage")
        XCTAssertTrue(toastMessage.waitForExistence(timeout: 15), "Toast message not found")
    }

    @MainActor
    func testGetCMPString() throws {
        let getCMPStringButton = app.buttons["Get CMP String"]
        XCTAssertTrue(getCMPStringButton.waitForExistence(timeout: 15), "Get CMP String button not found")
        getCMPStringButton.tap()

        let toastMessage = app.staticTexts.element(matching: .any, identifier: "ToastMessage")
        XCTAssertTrue(toastMessage.waitForExistence(timeout: 15), "Toast message not found")
    }

    @MainActor
    func testGetCMPPreferences() throws {
        let getCMPPreferencesButton = app.buttons["Get CMP Preferences"]
        XCTAssertTrue(getCMPPreferencesButton.waitForExistence(timeout: 15), "Get CMP Preferences button not found")
        getCMPPreferencesButton.tap()

        let toastMessage = app.staticTexts.element(matching: .any, identifier: "ToastMessage")
        XCTAssertTrue(toastMessage.waitForExistence(timeout: 15), "Toast message not found")
    }
}
