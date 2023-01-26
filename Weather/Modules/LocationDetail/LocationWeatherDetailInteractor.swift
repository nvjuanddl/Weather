//
//  LocationWeatherDetailInteractor.swift
//  Weather
//
//  Created by Juan Dario Delgado Lasso on 25/01/23.
//

import Foundation

class LocationWeatherDetailInteractor {
    
    // MARK: - Private properties -
    // MARK: - Public properties -
}

// MARK: - LocationWeatherDetailInteractor interface -
extension LocationWeatherDetailInteractor: LocationWeatherDetailInteractorInterface {
    
    func getLocationWeatherDetail(at location: String, completion: @escaping (LocationWeatherDetailResult) -> Void) {
        let request: URLRequest
        let externalDataRouter = ExternalDataRouter.locationWeatherDetail(LocationWeatherDetailRequest(query: location))
        
        do {
            request = try externalDataRouter.asURLRequest()
        } catch {
            completion(.error)
            return
        }
        
        ExternalDataManager.execute(request: request) { (result: ExternalDataResult<LocationWeather>) in
            switch result {
            case .success(let data):
                completion(.ok(data.weathers))
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
