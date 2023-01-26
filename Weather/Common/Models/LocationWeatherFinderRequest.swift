//
//  WeatherList.swift
//  Weather
//
//  Created by Juan Dario Delgado L on 25/01/23.
//

struct LocationWeatherFinderRequest: Encodable {
    let apiKey: String = "de5553176da64306b86153651221606"
    let query: String
    
    enum CodingKeys: String, CodingKey {
        case query = "q"
        case apiKey = "key"
    }
}
