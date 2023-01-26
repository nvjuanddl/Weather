//
//  LocationWeatherFinderInteractor.swift
//  Weather
//
//  Created by Juan Dario Delgado Lasso on 25/01/23.
//

import Foundation

class LocationWeatherFinderInteractor {
    
    // MARK: - Private properties -
    // MARK: - Public properties -
}

// MARK: - LocationWeatherFinderInteractor interface -
extension LocationWeatherFinderInteractor: LocationWeatherFinderInteractorInterface {
    
    func getWeatherFinder(at location: String, completion: @escaping (LocationWeatherFinderResult) -> Void) {
        let request: URLRequest
        let externalDataRouter = ExternalDataRouter.locationWeatherFinder(LocationWeatherFinderRequest(query: location))
        
        do {
            request = try externalDataRouter.asURLRequest()
        } catch {
            completion(.error)
            return
        }
        
        ExternalDataManager.execute(request: request) { [weak self] (result: ExternalDataResult<[Location]>) in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let data):
                completion(.ok(data))
            case .failure(let data):
                switch data {
                case .api, .decoding:
                    completion(.error)
                case .networkConnectionLost, .notConnectedToInternet:
                    completion(.connectionProblems)
                }
            }
        }
    }
}
