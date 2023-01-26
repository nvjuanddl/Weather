//
//  LocationWeatherFinderWireframe.swift
//  Weather
//
//  Created by Juan Dario Delgado Lasso on 25/01/23.
//

import UIKit

class LocationWeatherFinderWireframe: BaseWireframe {

    // MARK: - Module setup -
    init() {
        let moduleViewController = LocationWeatherFinderViewController()
        super.init(viewController: moduleViewController)
        let interactor = LocationWeatherFinderInteractor()
        let presenter = LocationWeatherFinderPresenter(
            wireframe: self,
            view: moduleViewController,
            interactor: interactor
        )
        moduleViewController.presenter = presenter
    }
}

// MARK: - LocationWeatherFinderWireframe interface -
extension LocationWeatherFinderWireframe: LocationWeatherFinderWireframeInterface {

    func navigate(to option: LocationWeatherFinderNavigationOption) {
        switch option {
        case .locationDetail(let name):
            let wireframe = LocationWeatherDetailWireframe(locationName: name)
            navigationController?.pushViewController(wireframe.viewController, animated: true)
        }
    }
}
