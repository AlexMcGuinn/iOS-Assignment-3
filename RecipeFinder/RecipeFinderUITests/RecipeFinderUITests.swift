//
//  RecipeFinderUITests.swift
//  RecipeFinderUITests
//
//  Created by David on 13/5/2026.
//

import XCTest

final class RecipeFinderUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false

        app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testDiscoverLoads() {
        let mealCardImage = app.images["mealCardImage"].firstMatch
        XCTAssertTrue(mealCardImage.waitForExistence(timeout: 10))
        
        let mealCardText = app.staticTexts["mealCardText"].firstMatch
        XCTAssertTrue(mealCardText.waitForExistence(timeout: 10))
        
        let mealCardCategory = app.staticTexts["mealCardCategory"].firstMatch
        XCTAssertTrue(mealCardCategory.waitForExistence(timeout: 10))
    }
    
    func testSearchFieldNavigatesToResults() {
        let searchField = app.textFields["searchTextField"]

        XCTAssertTrue(searchField.waitForExistence(timeout: 3))
        
        searchField.tap()
        searchField.typeText("Chicken")
        searchField.typeText("\n")

        XCTAssertTrue(app.staticTexts["Results for \"Chicken\""].waitForExistence(timeout: 5))
    }
    
    func testResultsMatchWithSearch() {
        let searchField = app.textFields["searchTextField"]

        XCTAssertTrue(app.textFields["searchTextField"].waitForExistence(timeout: 3))
        
        let searchText = "Chicken"
        searchField.tap()
        searchField.typeText(searchText)
        searchField.typeText("\n")
        
        let mealTitle = app.staticTexts["mealTitle"].firstMatch
        XCTAssertTrue(mealTitle.label.contains(searchText))
    }
    
    func testRecipeDetailLoads() throws {
        let mealCard = app.buttons["mealCard"].firstMatch
        XCTAssertTrue(mealCard.waitForExistence(timeout: 10))
        mealCard.tap()
        
        let recipeTitle = app.staticTexts["recipeTitle"]
        XCTAssertTrue(recipeTitle.waitForExistence(timeout: 10))
        
        XCTAssertFalse(recipeTitle.label.isEmpty)
    }
    
    func uploadImagePageLoads() {
        let uploadImageButton = app.buttons["uploadImageButton"]
        XCTAssertTrue(uploadImageButton.waitForExistence(timeout: 10))
        
        uploadImageButton.tap()
        
        let uploadImageHeading = app.staticTexts["uploadImageHeading"]
        XCTAssertTrue(uploadImageHeading.waitForExistence(timeout: 10))
    }
    
    @MainActor
    func testLaunchPerformance() throws {
        // This measures how long it takes to launch your application.
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }
}
