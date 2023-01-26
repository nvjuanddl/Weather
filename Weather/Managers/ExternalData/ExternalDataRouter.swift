//
//  ExternalDataRouter.swift
//  Weather
//
//  Created by Juan Dario Delgado Lasso on 25/01/23.
//

import Foundation
import Alamofire

enum ExternalDataRouter<T: Encodable> {
    
    case locationWeatherFinder(T)
    case locationWeatherDetail(T)
    
    var baseURL: URL {
        return URL(string: "http://api.weatherapi.com/v1")!
    }
        
    var method: HTTPMethod {
        switch self {
        case .locationWeatherFinder,
             .locationWeatherDetail: return .get
        }
    }
    
    var path: String {
        switch self {
        case .locationWeatherFinder: return "/search.json"
        case .locationWeatherDetail: return "/forecast.json"
        }
    }
    
    var parameters: T? {
        switch self {
        case .locationWeatherFinder(let parameters),
             .locationWeatherDetail(let parameters):
            return parameters
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let encoder: ParameterEncoder = method == .get ? URLEncodedFormParameterEncoder.default : JSONParameterEncoder.default
        let url = path.isEmpty ? baseURL : baseURL.appendingPathComponent(path)
        let request = try URLRequest(url: url, method: method, headers: [:])
        return try parameters.map { try encoder.encode($0, into: request) } ?? request
    }
}
