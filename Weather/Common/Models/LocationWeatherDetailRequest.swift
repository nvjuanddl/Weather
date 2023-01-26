//
//  LocationWeatherDetailRequest.swift
//  Weather
//
//  Created by Juan Delgado Lasso on 25/01/23.
//

import Foundation

struct LocationWeatherDetailRequest: Encodable {
    let apiKey: String = "de5553176da64306b86153651221606"
    let query: String
    let days: Int = 5
    
    enum CodingKeys: String, CodingKey {
        case query = "q"
        case apiKey = "key"
        case days
    }
}
