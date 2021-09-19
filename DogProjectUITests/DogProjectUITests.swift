//
//  DogProjectUITests.swift
//  DogProjectUITests
//
//  Created by Vijay Adhikari on 18/9/21.
//

import XCTest

class DogProjectUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        XCTAssertEqual(app.tables.count, 1)
        XCTAssertEqual(app.navigationBars.count, 1)

        let table = app.tables.allElementsBoundByIndex[0]

        sleep(3)
        app.buttons["Descending"].tap()

        sleep(3)
        app.buttons["Ascending"].tap()

        sleep(3)
        app.buttons["Ascending"].tap()
        
        sleep(3)
        app.buttons["Refresh"].tap()
      //  XCUIApplication().navigationBars["DogProject.View"].buttons["Refresh"].tap()
                        
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
                
//                let dogprojectViewNavigationBar = XCUIApplication().navigationBars["DogProject.View"]
//                dogprojectViewNavigationBar.buttons["Descending"].tap()
//                dogprojectViewNavigationBar.buttons["Ascending"].tap()
            }
        }
    }
}
