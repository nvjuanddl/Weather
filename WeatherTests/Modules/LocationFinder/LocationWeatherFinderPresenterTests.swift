//
//  LocationWeatherFinderPresenterTests.swift
//  WeatherTests
//
//  Created by Juan Dario Delgado L on 25/01/23.
//

import Foundation
import XCTest
@testable import Weather

class LocationWeatherFinderPresenterTests: XCTestCase {
    
    private var interactor: TestLocationWeatherFinderInteractorInterface!
    private var wireframe: TestLocationWeatherFinderWireframeInterface!
    private var view: TestLocationWeatherFinderViewInterface!
    private var presenter: LocationWeatherFinderPresenterInterface!
    
    override func setUp() {
        super.setUp()
        interactor = TestLocationWeatherFinderInteractorInterface()
        wireframe = TestLocationWeatherFinderWireframeInterface()
        view = TestLocationWeatherFinderViewInterface()
        presenter = LocationWeatherFinderPresenter(wireframe: wireframe, view: view, interactor: interactor)
    }
    
    override func tearDown() {
        interactor = nil
        wireframe = nil
        presenter = nil
        view = nil
    }
    
    func testGetLocationWeatherFinderSuccess() {
        interactor.isSuccess = true
        presenter.getLocationWeatherFinder(at: "Bogota")
        XCTAssertTrue(interactor.isLocationWeatherFinderCalled)
        XCTAssert(presenter.numberOfItemsInSection != 0)
    }
    
    func testGetLocationWeatherFinderFailure() {
        interactor.isSuccess = false
        presenter.getLocationWeatherFinder(at: "Bogota")
        XCTAssertTrue(interactor.isShowErrorLocationWeatherFinderCalled)
        XCTAssert(presenter.numberOfItemsInSection == 0)
    }
}

extension LocationWeatherFinderPresenterTests {
    
    class TestLocationWeatherFinderWireframeInterface: LocationWeatherFinderWireframeInterface {
        func navigate(to option: LocationWeatherFinderNavigationOption) { }
    }
    
    class TestLocationWeatherFinderInteractorInterface: LocationWeatherFinderInteractorInterface {
        
        var isLocationWeatherFinderCalled = false
        var isShowErrorLocationWeatherFinderCalled = false
        var isSuccess = false
        
        func getWeatherFinder(at location: String, completion: @escaping (LocationWeatherFinderResult) -> Void) {
            if isSuccess {
                isLocationWeatherFinderCalled = true
                let locationList = [Location(id: 0, name: "", country: "")]
                completion(.ok(locationList))
            } else {
                isShowErrorLocationWeatherFinderCalled = true
                completion(.error)
            }
        }
    }
    
    class TestLocationWeatherFinderViewInterface: LocationWeatherFinderViewInterface {
        func reloadData() { }
        func hiddenError() { }
        func showError(viewModel: ErrorViewModel) { }
    }
}

