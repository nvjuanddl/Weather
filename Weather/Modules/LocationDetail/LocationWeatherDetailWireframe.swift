//
//  LocationWeatherDetailWireframe.swift
//  Weather
//
//  Created by Juan Dario Delgado Lasso on 25/01/23.
//

import UIKit

class LocationWeatherDetailWireframe: BaseWireframe {

    // MARK: - Module setup -
    init(locationName: String) {
        let moduleViewController = LocationWeatherDetailViewController()
        super.init(viewController: moduleViewController)
        let interactor = LocationWeatherDetailInteractor()
        let presenter = LocationWeatherDetailPresenter(
            wireframe: self,
            view: moduleViewController,
            interactor: interactor,
            locationName: locationName
        )
        moduleViewController.presenter = presenter
    }
}

// MARK: - LocationWeatherDetailWireframe interface -
extension LocationWeatherDetailWireframe: LocationWeatherDetailWireframeInterface {

    func navigate(to option: LocationWeatherDetailNavigationOption) {
    }
}
