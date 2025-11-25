//
//  ImageFeedUITests.swift
//  ImageFeedUITests
//
//  Created by Igor on 25.11.2025.
//

import XCTest

final class ImageFeedUITests: XCTestCase {
    private let app = XCUIApplication()

    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }

    func testAuth() throws {
        
        app.buttons["authButton"].tap()
        
        let webView = app.webViews["unsplashWebView"]
        XCTAssertTrue(webView.waitForExistence(timeout: 5))

        let loginField = webView.descendants(matching: .textField).element
        XCTAssertTrue(loginField.waitForExistence(timeout: 5))
        
        loginField.tap()
        loginField.press(forDuration: 1.0)
        loginField.typeText("--Login--")
        webView.swipeDown()

        let passwordField = webView.descendants(matching: .secureTextField).element
        XCTAssertTrue(passwordField.waitForExistence(timeout: 5))
        
        passwordField.tap()
        passwordField.tap()
        passwordField.press(forDuration: 1.0)
        passwordField.typeText("--Password--")

        webView.buttons["Login"].tap()
        
        let tablessApp = app.tables
        let cell = tablessApp.children(matching: .cell).element(boundBy: 0)
        
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
    }

    func testFeed() throws {
        let tablesQuery = app.tables
        
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        cell.swipeUp()
        
        sleep(2)
        
        let cellToLike = tablesQuery.children(matching: .cell).element(boundBy: 1)
        
        cellToLike.buttons["likeButton"].tap()
        cellToLike.buttons["likeButton"].tap()
        
        sleep(2)
        
        cellToLike.tap()
        
        sleep(2)
        
        let image = app.scrollViews.images.element(boundBy: 0)
        image.pinch(withScale: 3, velocity: 1) // zoom in
        image.pinch(withScale: 0.5, velocity: -1)
        
        let navBackButtonWhiteButton = app.buttons["backButton"]
        navBackButtonWhiteButton.tap()
    }
    
    func testProfile() throws {
        sleep(7)
        app.tabBars.buttons.element(boundBy: 1).tap()
       
        XCTAssertTrue(app.staticTexts["Igor Burkovsky"].exists)
        XCTAssertTrue(app.staticTexts["@ideveloper"].exists)
        
        app.buttons["logoutButton"].tap()
        
        app.alerts["Пока, пока!"].scrollViews.otherElements.buttons["Да"].tap()
    }
}
