//
//  GuestsViewControllerUITests.swift
//  OLSUN
//
//  Created by Narmin Baghirova on 01.05.25.
//

import XCTest

final class GuestsViewControllerUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUp() {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = ["-ui-testing"]
        app.launch()
        let qonaqlamaCell = app.tables.cells.matching(identifier: "menuCell_Qonaqlar").firstMatch
        XCTAssertTrue(qonaqlamaCell.exists)
        qonaqlamaCell.tap()
        
        if app.alerts.firstMatch.exists {
            let alert = app.alerts.firstMatch
            let dismissButton = alert.buttons.firstMatch
            if dismissButton.exists {
                dismissButton.tap()
            }
        }
    }

    func testGuestsScreenLoadsCorrectly() {
        let title = app.staticTexts["guestsTitleLabel"]
        XCTAssertTrue(title.waitForExistence(timeout: 2))
        XCTAssertEqual(title.label, "Qonaqların siyahısı")
    }

    func testAddGuestButtonExistsAndTappable() {
        let addButton = app.buttons["addGuestButton"]
        XCTAssertTrue(addButton.waitForExistence(timeout: 2))
        XCTAssertTrue(addButton.isHittable)
        addButton.tap()
    }

    func testGuestsTableIsVisible() {
        let table = app.tables["guestsTableView"]
        XCTAssertTrue(table.exists)
    }

    func testGuestCellTap() {
        let table = app.tables["guestsTableView"]
        let cell = table.cells.firstMatch
        if cell.exists {
            cell.tap()
        }
    }

    func testPullToRefreshWorks() {
        let table = app.tables["guestsTableView"]
        table.swipeDown()
    }
}
