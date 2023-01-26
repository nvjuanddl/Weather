//
//  LocationWeatherDetailInterfaces.swift
//  Weather
//
//  Created by Juan Dario Delgado Lasso on 25/01/23.
//

import Foundation

enum LocationWeatherDetailResult {
    case ok([Weather])
    case connectionProblems
    case error
}

enum LocationWeatherDetailNavigationOption {
    case locationDetail(id: Int)
}

protocol LocationWeatherDetailWireframeInterface: WireframeInterface {
    func navigate(to option: LocationWeatherDetailNavigationOption)
}

protocol LocationWeatherDetailViewInterface: ViewInterface {
    func reloadData()
    func loadTitle(with name: String)
    func selectItem(indexPath: IndexPath)
    func showError(viewModel: ErrorViewModel)
    func hiddenError()
}

protocol LocationWeatherDetailPresenterInterface: PresenterInterface {
    var numberOfItemsInSection: Int { get }
    func item(at indexPath: IndexPath) -> LocationWeatherDetailViewModel
}

protocol LocationWeatherDetailInteractorInterface: InteractorInterface {
    func getLocationWeatherDetail(at location: String, completion: @escaping (LocationWeatherDetailResult) -> Void)
}
