//
//  Daily + Extension.swift
//  WeatherForecast
//
//  Created by Василий Пронин on 11.02.2022.
//

import Foundation

extension Daily {
    struct Diffable: Decodable, Hashable {
        var id: UUID {
            let id = UUID()
            return id
        }
        
        let date: String
        let weekday: String
        let sunrise: String
        let sunset: String
        let highestTemperature: String
        let lowestTemperature: String
        let probabilityOfPrecipitation: String
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
        
//        init?(model: Daily) {
//            self.date = DateManager.shared.defineDate(withUnixTime: model.dt ?? 0, andDateFormat: .date)
//            self.weekday = DateManager.shared.defineDate(withUnixTime: model.dt ?? 0, andDateFormat: .weekday)
//            self.sunrise = DateManager.shared.defineDate(withUnixTime: model.sunrise ?? 0, andDateFormat: .time)
//            self.sunset = DateManager.shared.defineDate(withUnixTime: model.sunset ?? 0, andDateFormat: .time)
//            self.highestTemperature = String(format: "%.0f", model.temperature?.max.rounded(.toNearestOrAwayFromZero) ?? 0)
//            self.lowestTemperature = String(format: "%.0f", model.temperature?.min.rounded(.toNearestOrAwayFromZero) ?? 0)
//            self.probabilityOfPrecipitation = String(format: "%.0f", model.pop?.rounded(.toNearestOrAwayFromZero) ?? 0) + " %"
//            self.conditionCode = model.weather?.first!.id ?? 0
//        }
        
        static func == (lhs: Daily.Diffable, rhs: Daily.Diffable) -> Bool {
            return lhs.id == rhs.id
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
    }
}
