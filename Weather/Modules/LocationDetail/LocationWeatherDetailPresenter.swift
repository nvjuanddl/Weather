//
//  LocationWeatherDetailPresenter.swift
//  Weather
//
//  Created by Juan Dario Delgado Lasso on 25/01/23.
//

import Foundation

class LocationWeatherDetailPresenter {
    
    // MARK: - Private properties -
    private let interactor: LocationWeatherDetailInteractorInterface
    private let wireframe: LocationWeatherDetailWireframeInterface
    private unowned let view: LocationWeatherDetailViewInterface
    
    private var locationName: String
    private var weathers: [Weather] = []
    
    // MARK: - Lifecycle -
    init(
        wireframe: LocationWeatherDetailWireframeInterface,
        view: LocationWeatherDetailViewInterface,
        interactor: LocationWeatherDetailInteractorInterface,
        locationName: String
    ) {
        self.wireframe = wireframe
        self.view = view
        self.interactor = interactor
        self.locationName = locationName
    }
    
    private func getLocationWeatherDetail() {
        interactor.getLocationWeatherDetail(at: locationName) { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .ok(let weathers):
                strongSelf.weathers = weathers
                strongSelf.view.hiddenError()
            case .connectionProblems:
                let actionCallback: (() -> Void)? = {
                    guard let strongSelf = self else { return }
                    strongSelf.getLocationWeatherDetail()
                }
                
                strongSelf.view.showError(
                    viewModel: ErrorViewModel(
                        actionCallback: actionCallback,
                        imageName: "cloud-error",
                        title: NSLocalizedString("locationWeatherDetail.noInternetConection", comment: ""),
                        titleAction: NSLocalizedString("locationWeatherDetail.tryAgain", comment: "")
                    )
                )
            case .error:
                let actionCallback: (() -> Void)? = {
                    guard let strongSelf = self else { return }
                    strongSelf.getLocationWeatherDetail()
                }
                
                strongSelf.view.showError(
                    viewModel: ErrorViewModel(
                        actionCallback: actionCallback,
                        imageName: "cloud-error",
                        title: NSLocalizedString("locationWeatherDetail.tryAgainLater", comment: ""),
                        titleAction: NSLocalizedString("locationWeatherDetail.tryAgain", comment: "")
                    )
                )
            }
            strongSelf.view.reloadData()
        }
    }
}

// MARK: - LocationWeatherDetailPresenter interface -
extension LocationWeatherDetailPresenter: LocationWeatherDetailPresenterInterface {
    
    var numberOfItemsInSection: Int {weathers.count }
    
    func viewDidLoad() {
        view.loadTitle(with: locationName)
        getLocationWeatherDetail()
    }

    func item(at indexPath: IndexPath) -> LocationWeatherDetailViewModel {
        let weather = weathers[indexPath.row]
        let url = URL(string: weather.day.condition.icon.replacingOccurrences(of: "//", with: "http://"))
        let relativeDateFormatter = DateFormatter()
        relativeDateFormatter.timeStyle = .none
        relativeDateFormatter.dateStyle = .medium
        relativeDateFormatter.locale = Locale(identifier: "en_US_POSIX")
        relativeDateFormatter.doesRelativeDateFormatting = true
        
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        let date = relativeDateFormatter.string(from: inputFormatter.date(from: weather.date) ?? Date())

        
        return LocationWeatherDetailViewModel(
            description: weather.day.condition.text,
            date: date,
            avgTemp: weather.day.avgTemp,
            icon: url
        )
    }
}
