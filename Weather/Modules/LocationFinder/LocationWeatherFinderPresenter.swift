//
//  LocationWeatherFinderPresenter.swift
//  Weather
//
//  Created by Juan Dario Delgado Lasso on 25/01/23.
//

import Foundation

class LocationWeatherFinderPresenter {
    
    // MARK: - Private properties -
    private let interactor: LocationWeatherFinderInteractorInterface
    private let wireframe: LocationWeatherFinderWireframeInterface
    private unowned let view: LocationWeatherFinderViewInterface
    
    private var query: String = ""
    private var locations: [Location] = []
    
    // MARK: - Lifecycle -
    init(
        wireframe: LocationWeatherFinderWireframeInterface,
        view: LocationWeatherFinderViewInterface,
        interactor: LocationWeatherFinderInteractorInterface
    ) {
        self.wireframe = wireframe
        self.view = view
        self.interactor = interactor
    }
}

// MARK: - LocationWeatherFinderPresenter interface -
extension LocationWeatherFinderPresenter: LocationWeatherFinderPresenterInterface {
    
    var numberOfItemsInSection: Int { locations.count }
    
    func cleanData() {
        locations = []
        view.reloadData()
    }
    
    func getLocationWeatherFinder(at query: String) {
        interactor.getWeatherFinder(at: query) { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .ok(let locations):
                strongSelf.locations = locations
                strongSelf.view.hiddenError()
            case .connectionProblems:
                let actionCallback: (() -> Void)? = {
                    guard let strongSelf = self else { return }
                    strongSelf.getLocationWeatherFinder(at: query)
                }
                
                strongSelf.view.showError(
                    viewModel: ErrorViewModel(
                        actionCallback: actionCallback,
                        imageName: "cloud-error",
                        title: NSLocalizedString("locationWeatherFinder.noInternetConection", comment: ""),
                        titleAction: NSLocalizedString("locationWeatherFinder.tryAgain", comment: "")
                    )
                )
            case .error:
                let actionCallback: (() -> Void)? = {
                    guard let strongSelf = self else { return }
                    strongSelf.getLocationWeatherFinder(at: query)
                }
                
                strongSelf.view.showError(
                    viewModel: ErrorViewModel(
                        actionCallback: actionCallback,
                        imageName: "cloud-error",
                        title: NSLocalizedString("locationWeatherFinder.tryAgainLater", comment: ""),
                        titleAction: NSLocalizedString("locationWeatherFinder.tryAgain", comment: "")
                    )
                )
            }
            strongSelf.view.reloadData()
        }
    }

    func item(at indexPath: IndexPath) -> LocationViewModel {
        let location = locations[indexPath.row]
        return LocationViewModel(
            city: location.name,
            country: location.country
        )
    }
    
    func didSelectItemAt(indexPath: IndexPath) {
        let name = locations[indexPath.item].name
        wireframe.navigate(to: .locationDetail(name: name))
    }
}
