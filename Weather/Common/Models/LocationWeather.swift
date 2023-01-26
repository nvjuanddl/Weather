//
//  LocationWeather.swift
//  Weather
//
//  Created by Juan Delgado Lasso on 25/01/23.
//

import Foundation

struct LocationWeather: Decodable {
    let weathers: [Weather]
    
    enum CodingKeys: String, CodingKey {
        case current
        case forecast
    }
    
    enum ForecastCodingKeys: String, CodingKey {
        case forecastday
    }
    
    enum ForecastdayCodingKeys: String, CodingKey {
        case forecastday
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let forecastContainer = try container.nestedContainer(keyedBy: ForecastCodingKeys.self, forKey: .forecast)
        weathers = try forecastContainer.decode([Weather].self, forKey: .forecastday)
    }
}


struct Weather: Decodable {
    let date: String
    let day: Day
    
    struct Day: Decodable {
        let avgTemp: Double
        let condition: Condition
        
        enum CodingKeys: String, CodingKey {
            case avgTemp = "avgtemp_c"
            case condition
        }
        
        struct Condition: Decodable {
            let text: String
            let icon: String
        }
    }
}
