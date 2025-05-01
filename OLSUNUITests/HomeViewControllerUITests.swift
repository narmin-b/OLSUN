//
//  HomeViewControllerUITests.swift
//  OLSUN
//
//  Created by Narmin Baghirova on 01.05.25.
//

import XCTest

final class HomeViewControllerUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = ["-ui-testing"]
        app.launch()
    }

    func testHomeScreenDisplaysCorrectly() {
        let titleLabel = app.staticTexts["homeTitleLabel"]
        XCTAssertTrue(titleLabel.exists)
    }
    
    func testTapPlanlamaCell() {
        let planlamaCell = app.tables.cells.matching(identifier: "menuCell_Planlama").firstMatch
        XCTAssertTrue(planlamaCell.exists)
        planlamaCell.tap()
    }
    
    func testTapQonaqlarCell() {
        let qonaqlamaCell = app.tables.cells.matching(identifier: "menuCell_Qonaqlar").firstMatch
        XCTAssertTrue(qonaqlamaCell.exists)
        qonaqlamaCell.tap()
    }
}
