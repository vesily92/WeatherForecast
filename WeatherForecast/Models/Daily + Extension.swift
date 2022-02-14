//
//  Daily + Extension.swift
//  WeatherForecast
//
//  Created by Василий Пронин on 11.02.2022.
//

import Foundation

extension Daily {
//    struct Diffable {
//        let id: UUID
//
//        let date: String
//        let weekday: String
//        let sunrise: String
//        let sunset: String
//        let highestTemperature: String
//        let lowestTemperature: String
//        let probabilityOfPrecipitation: String
//        let conditionCode: Int
//
//        var systemNameString: String {
//            switch conditionCode {
//            case 200...232: return "cloud.bolt.rain.fill" //"11d"
//            case 300...321: return "cloud.drizzle.fill" //"09d"
//            case 500...531: return "cloud.heavyrain.fill" //"10d"
//            case 600...622: return "cloud.snow.fill" //"13d"
//            case 700...781: return "cloud.fog.fill" //"50d"
//            case 800: return "sun.max.fill" //"01d"
//            case 801...804: return "cloud.sun.fill" //"04d"
//            default: return "nosign"
//            }
//        }
//
//        init?(model: Daily) {
//            self.id = model.identifier
//
//            self.date = DateManager.shared.defineDate(withUnixTime: model.dt, andDateFormat: .date)
//            self.weekday = DateManager.shared.defineDate(withUnixTime: model.dt, andDateFormat: .weekday)
//            self.sunrise = DateManager.shared.defineDate(withUnixTime: model.sunrise ?? 0, andDateFormat: .time)
//            self.sunset = DateManager.shared.defineDate(withUnixTime: model.sunset ?? 0, andDateFormat: .time)
//            self.highestTemperature = String(format: "%.0f", model.temperature.max.rounded(.toNearestOrAwayFromZero))
//            self.lowestTemperature = String(format: "%.0f", model.temperature.min.rounded(.toNearestOrAwayFromZero))
//            self.probabilityOfPrecipitation = String(format: "%.0f", model.pop.rounded(.toNearestOrAwayFromZero)) + " %"
//            self.conditionCode = model.weather.first!.id
//        }
//    }
    
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
        
        init?(model: Daily) {
            
            self.date = DateManager.shared.defineDate(withUnixTime: model.dt, andDateFormat: .date)
            self.weekday = DateManager.shared.defineDate(withUnixTime: model.dt, andDateFormat: .weekday)
            self.sunrise = DateManager.shared.defineDate(withUnixTime: model.sunrise ?? 0, andDateFormat: .time)
            self.sunset = DateManager.shared.defineDate(withUnixTime: model.sunset ?? 0, andDateFormat: .time)
            self.highestTemperature = String(format: "%.0f", model.temperature.max.rounded(.toNearestOrAwayFromZero))
            self.lowestTemperature = String(format: "%.0f", model.temperature.min.rounded(.toNearestOrAwayFromZero))
            self.probabilityOfPrecipitation = String(format: "%.0f", model.pop.rounded(.toNearestOrAwayFromZero)) + " %"
            self.conditionCode = model.weather.first!.id
        }
        
        static func == (lhs: Daily.Diffable, rhs: Daily.Diffable) -> Bool {
            return lhs.id == rhs.id
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
    }
}
