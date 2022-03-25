//
//  Current + Extension.swift
//  WeatherForecast
//
//  Created by Василий Пронин on 11.02.2022.
//

import Foundation

extension Current {
    struct Diffable: Decodable, Hashable {
        var id: UUID {
            let id = UUID()
            return id
        }
        
        let temperature: String
        let description: String
        let feelsLike: String
        let conditionCode: Int
        
        var systemNameString: String {
            switch conditionCode {
            case 200...232: return "cloud.bolt.rain.fill" //"11d"
            case 300...321: return "cloud.drizzle.fill" //"09d"
            case 500...531: return "cloud.heavyrain.fill" //"10d"
            case 600...622: return "cloud.snow.fill" //"13d"
            case 700...781: return "cloud.fog.fill" //"50d"
            case 800: return "sun.max.fill" //"01d"
            case 801...804: return "cloud.sun.fill" //"04d"
            default: return "nosign"
            }
        }
        
        init?(model: Current) {
            temperature = String(format: "%.0f", model.temp.rounded(.toNearestOrAwayFromZero))
            description = model.temp.description
            feelsLike = String(format: "%.0f", model.feelsLike.rounded(.toNearestOrAwayFromZero))
            conditionCode = model.weather.first!.id
//            temperature = model.temp ?? 0
//            description = model.weather?.first?.description ?? ""
//            feelsLike = model.feelsLike ?? 0
//            conditionCode = model.weather?.first?.id ?? 0
        }
        
        static func == (lhs: Current.Diffable, rhs: Current.Diffable) -> Bool {
            return lhs.id == rhs.id
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
    }
}
