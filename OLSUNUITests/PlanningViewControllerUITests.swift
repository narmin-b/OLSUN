//
//  PlanningViewControllerUITests.swift
//  OLSUN
//
//  Created by Narmin Baghirova on 01.05.25.
//

import XCTest

final class PlanningViewUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUp() {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = ["-ui-testing"]
        app.launch()
        let planlamaCell = app.tables.cells.matching(identifier: "menuCell_Planlama").firstMatch
        XCTAssertTrue(planlamaCell.exists)
        planlamaCell.tap()
        
        if app.alerts.firstMatch.exists {
            let alert = app.alerts.firstMatch
            let dismissButton = alert.buttons.firstMatch
            if dismissButton.exists {
                dismissButton.tap()
            }
        }
    }

    func testPlanningScreenLoadsCorrectly() {
        let title = app.staticTexts["planningTitleLabel"]
        XCTAssertTrue(title.waitForExistence(timeout: 2))
        XCTAssertEqual(title.label, "Planların siyahısı")
    }

    func testAddTaskButtonExistsAndTappable() {
        let addButton = app.buttons["addTaskButton"]
        XCTAssertTrue(addButton.waitForExistence(timeout: 2))
        XCTAssertTrue(addButton.isHittable)
        addButton.tap()
    }

    func testTasksTableIsVisible() {
        let table = app.tables["tasksTableView"]
        XCTAssertTrue(table.exists)
    }

    func testTaskCellTap() {
        let table = app.tables["tasksTableView"]
        let cell = table.cells.firstMatch
        if cell.exists {
            cell.tap()
        }
    }

    func testPullToRefreshWorks() {
        let table = app.tables["tasksTableView"]
        table.swipeDown()
    }
}
