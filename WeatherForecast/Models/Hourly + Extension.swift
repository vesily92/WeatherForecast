//
//  Hourly + Extension.swift
//  WeatherForecast
//
//  Created by Василий Пронин on 14.02.2022.
//

import Foundation

extension Hourly {

//    struct DiffableHourly {
//        let id: UUID
//
//        let time: String
//        let hourlyTemperature: String
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
//        init?(model: Current) {
//            self.id = model.identifier
//            self.time = DateManager.shared.defineDate(withUnixTime: model.dt ?? 0, andDateFormat: .time)
//            self.hourlyTemperature = String(format: "%.0f", model.temp?.rounded(.toNearestOrAwayFromZero) ?? 0)
//            self.probabilityOfPrecipitation = "\(model.pop ?? 0) %"
//            self.conditionCode = model.weather?.first!.id ?? 0
//        }
//    }
    
    struct Diffable: Decodable, Hashable {
        var id: UUID {
            let id = UUID()
            return id
        }
        
        let time: String
        let hourlyTemperature: String
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
        
//        init?(model: Hourly) {
//            
//            self.time = DateManager.shared.defineDate(withUnixTime: model.dt ?? 0, andDateFormat: .time)
//            self.hourlyTemperature = String(format: "%.0f", model.temp?.rounded(.toNearestOrAwayFromZero) ?? 0)
//            self.probabilityOfPrecipitation = "\(model.pop ?? 0) %"
//            self.conditionCode = model.weather?.first!.id ?? 0
//        }
        
        static func == (lhs: Hourly.Diffable, rhs: Hourly.Diffable) -> Bool {
            return lhs.id == rhs.id
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
    }
}
