//
//  LocationWeatherDetailPresenterTests.swift
//  WeatherTests
//
//  Created by Juan Dario Delgado L on 25/01/23.
//

import Foundation
import XCTest
@testable import Weather

class LocationWeatherDetailPresenterTests: XCTestCase {
    
    private var interactor: TestLocationWeatherDetailInteractorInterface!
    private var wireframe: TestLocationWeatherDetailWireframeInterface!
    private var view: TestLocationWeatherDetailViewInterface!
    private var presenter: LocationWeatherDetailPresenterInterface!
    
    override func setUp() {
        super.setUp()
        interactor = TestLocationWeatherDetailInteractorInterface()
        wireframe = TestLocationWeatherDetailWireframeInterface()
        view = TestLocationWeatherDetailViewInterface()
        presenter = LocationWeatherDetailPresenter(wireframe: wireframe, view: view, interactor: interactor, locationName: "Bogota")
    }
    
    override func tearDown() {
        interactor = nil
        wireframe = nil
        presenter = nil
        view = nil
    }
    
    func testGetLocationWeatherDetailSuccess() {
        interactor.isSuccess = true
        presenter.viewDidLoad()
        XCTAssertTrue(interactor.isLocationWeatherDetailCalled)
        XCTAssert(presenter.numberOfItemsInSection != 0)
    }
    
    func testGetLocationWeatherDetailFailure() {
        interactor.isSuccess = false
        presenter.viewDidLoad()
        XCTAssertTrue(interactor.isShowErrorLocationWeatherDetailCalled)
        XCTAssert(presenter.numberOfItemsInSection == 0)
    }
}

extension LocationWeatherDetailPresenterTests {
    
    class TestLocationWeatherDetailWireframeInterface: LocationWeatherDetailWireframeInterface {
        func navigate(to option: LocationWeatherDetailNavigationOption) { }
    }
    
    class TestLocationWeatherDetailInteractorInterface: LocationWeatherDetailInteractorInterface {

        var isLocationWeatherDetailCalled = false
        var isShowErrorLocationWeatherDetailCalled = false
        var isSuccess = false
        
        func getLocationWeatherDetail(at location: String, completion: @escaping (LocationWeatherDetailResult) -> Void) {
            if isSuccess {
                isLocationWeatherDetailCalled = true
                let weatherList = [Weather(date: "", day: Weather.Day(avgTemp: .zero, condition: Weather.Day.Condition(text: "", icon: "")))]
                completion(.ok(weatherList))
            } else {
                isShowErrorLocationWeatherDetailCalled = true
                completion(.error)
            }
        }
    }
    
    class TestLocationWeatherDetailViewInterface: LocationWeatherDetailViewInterface {
        func loadTitle(with name: String) { }
        func selectItem(indexPath: IndexPath) {}
        func reloadData() { }
        func hiddenError() { }
        func showError(viewModel: ErrorViewModel) { }
    }
}

