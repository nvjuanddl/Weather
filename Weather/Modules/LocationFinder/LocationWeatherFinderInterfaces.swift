//
//  LocationWeatherFinderInterfaces.swift
//  Weather
//
//  Created by Juan Dario Delgado Lasso on 25/01/23.
//

import Foundation

enum LocationWeatherFinderResult {    
    case ok([Location])
    case connectionProblems
    case error
}

enum LocationWeatherFinderNavigationOption {
    case locationDetail(name: String)
}

protocol LocationWeatherFinderWireframeInterface: WireframeInterface {
    func navigate(to option: LocationWeatherFinderNavigationOption)
}

protocol LocationWeatherFinderViewInterface: ViewInterface {
    func reloadData()
    func showError(viewModel: ErrorViewModel)
    func hiddenError()
}

protocol LocationWeatherFinderPresenterInterface: PresenterInterface {
    var numberOfItemsInSection: Int { get }
    func cleanData() 
    func didSelectItemAt(indexPath: IndexPath)
    func getLocationWeatherFinder(at query: String)
    func item(at indexPath: IndexPath) -> LocationViewModel
}

protocol LocationWeatherFinderInteractorInterface: InteractorInterface {
    func getWeatherFinder(at location: String, completion: @escaping (LocationWeatherFinderResult) -> Void)
}
