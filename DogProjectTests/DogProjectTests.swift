//
//  DogProjectTests.swift
//  DogProjectTests
//
//  Created by Vijay Adhikari on 18/9/21.
//

import XCTest
@testable import DogProject

class DogNetworkRequestStub {
    var fetchDogResultData: Result<[DogModel], DogErrorModel>!
    func request(completion: @escaping (Result<[DogModel], DogErrorModel>) -> Void) {
        completion(fetchDogResultData)
    }
}

class DogApiViewModelDelegateStub: DogApiViewModelDelegate {
    var DogApiViewModelDelegateMethods: [String] = []

    func reloadData() {
        DogApiViewModelDelegateMethods.append("reloadData()")
    }

    func showError(message: String) {
        DogApiViewModelDelegateMethods.append("showError(message: \(message))")
    }
    func isLoading(status: Bool) {
        DogApiViewModelDelegateMethods.append("showSpinner: \(status)")
    }
}

class DogApiResponseStub {
    private var name = "Finnish Spitz"
    private var lifeSpan: DogModel.LifeSpanYear = .range(12, 15)!
    private var imageURL = URL(string: "https://cdn2.thedogapi.com/images/7pTie4t9y.jpg")!

    func with(name: String) -> DogApiResponseStub {
        self.name = name
        return self
    }

    func with(imageURL: URL) -> DogApiResponseStub {
        self.imageURL = imageURL
        return self
    }
    
    func with(lifeSpanYear: DogModel.LifeSpanYear) -> DogApiResponseStub {
        self.lifeSpan = lifeSpanYear
        return self
    }

    func createDogModel() -> DogModel {
        return DogModel(name: name, lifeSpan: lifeSpan, imageURL: imageURL)
    }
}

class DogProjectTests: XCTestCase {
    var DogNetworkRequestObj: DogNetworkRequestStub!
    var delegate: DogApiViewModelDelegateStub!
    var DogResultViewModelObj: DogResultViewModel!

    override func setUpWithError() throws {
        DogNetworkRequestObj = DogNetworkRequestStub()
        delegate = DogApiViewModelDelegateStub()
        DogResultViewModelObj = DogResultViewModel()
        DogResultViewModelObj.delegate = delegate
    }

    func testGetResultDataSuccess() {
    
        let American_Foxhound = DogApiResponseStub()
                                .with(name: "Finnish Spitz")
                                .with(imageURL: URL(string: "https://cdn2.thedogapi.com/images/7pTie4t9y.jpg")!)
                                .with(lifeSpanYear: .range(12, 15)).createDogModel()
        
        DogResultViewModelObj.items = [American_Foxhound]
        DogResultViewModelObj.fetchItems()

        XCTAssertEqual(delegate.DogApiViewModelDelegateMethods, ["showSpinner: true"])
        XCTAssertEqual(DogResultViewModelObj.items, [DogApiResponseStub().createDogModel()])
    }
    
    func testSortAscending() {
        let Australian_Terrier = DogApiResponseStub().with(lifeSpanYear: .range(12, 14)).createDogModel()
        let Belgian_Malinois = DogApiResponseStub().with(lifeSpanYear: .range(14, 16)).createDogModel()
        let Border_Collie = DogApiResponseStub().with(lifeSpanYear: .fixedLifeSpan(8)).createDogModel()
        let American_Foxhound = DogApiResponseStub().with(lifeSpanYear: .fixedLifeSpan(9)).createDogModel()
        DogResultViewModelObj.fetchItems()

        DogResultViewModelObj.sort(by: .ascending)
        DogResultViewModelObj.items = [Australian_Terrier, Border_Collie, Belgian_Malinois, American_Foxhound]
        XCTAssertEqual(delegate.DogApiViewModelDelegateMethods, ["showSpinner: true","reloadData()"])
        XCTAssertEqual(DogResultViewModelObj.items, [Australian_Terrier, Border_Collie, Belgian_Malinois, American_Foxhound])
    }

    func testSortDescending() {
        let Australian_Terrier = DogApiResponseStub().with(lifeSpanYear: .range(12, 14)).createDogModel()
        let Belgian_Malinois = DogApiResponseStub().with(lifeSpanYear: .range(14, 16)).createDogModel()
        let Border_Collie = DogApiResponseStub().with(lifeSpanYear: .fixedLifeSpan(8)).createDogModel()
        let American_Foxhound = DogApiResponseStub().with(lifeSpanYear: .fixedLifeSpan(9)).createDogModel()
        DogResultViewModelObj.fetchItems()

        DogResultViewModelObj.sort(by: .descending)
        DogResultViewModelObj.items = [Australian_Terrier, Border_Collie, Belgian_Malinois, American_Foxhound]
        XCTAssertEqual(delegate.DogApiViewModelDelegateMethods, ["showSpinner: true","reloadData()"])
        XCTAssertEqual(DogResultViewModelObj.items, [Australian_Terrier, Border_Collie, Belgian_Malinois, American_Foxhound])
    }
    
    func testValidResponseYear() {
        let response = "12 - 14 years"
        let DogResultViewModelObj = try! DogModel.LifeSpanYear(response: response)
        XCTAssertEqual(DogResultViewModelObj, DogModel.LifeSpanYear.range(12, 14))
    }
    
    func testValidfixedLifeSpan() {
        let response = "9 years"
        let DogResultViewModelObj = try! DogModel.LifeSpanYear(response: response)
        XCTAssertEqual(DogResultViewModelObj, DogModel.LifeSpanYear.fixedLifeSpan(9))
    }
    
    func testWrongYearResponse() {
        let response = "testyear"
        XCTAssertThrowsError(try DogModel.LifeSpanYear(response: response))
    }
    
    func testMissingYearsLifeSpan() {
        let response = "12 13"
        XCTAssertThrowsError(try DogModel.LifeSpanYear(response: response))
    }
}
