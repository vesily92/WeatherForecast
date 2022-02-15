//
//  Hourly.swift
//  WeatherForecast
//
//  Created by Василий Пронин on 09.02.2022.
//
import Foundation

//struct HourlyForecast: Codable {
//    var timeString: String {
//        return DateManager.shared.defineDate(withUnixTime: dt, andDateFormat: .time)
//    }
//    
//    var hourlyTemperatureString: String {
//        return String(format: "%.0f", hourlyTemperature.rounded(.toNearestOrAwayFromZero))
//    }
//    
//    var probabilityOfPrecipitationString: String {
//        return "\(probabilityOfPrecipitation)%"
//    }
//    
//    var systemNameString: String {
//        switch conditionCode {
//        case 200...232: return "cloud.bolt.rain.fill" //"11d"
//        case 300...321: return "cloud.drizzle.fill" //"09d"
//        case 500...531: return "cloud.heavyrain.fill" //"10d"
//        case 600...622: return "cloud.snow.fill" //"13d"
//        case 700...781: return "cloud.fog.fill" //"50d"
//        case 800: return "sun.max.fill" //"01d"
//        case 801...804: return "cloud.sun.fill" //"04d"
//        default: return "nosign"
//        }
//    }
//    
//    private let dt: Int
//    private let hourlyTemperature: Double
//    private let probabilityOfPrecipitation: Int
//    private let conditionCode: Int
//    
//    init?(hourly: Current) {
//        dt = hourly.dt
//        hourlyTemperature = hourly.temp
//        probabilityOfPrecipitation = hourly.pop
//        conditionCode = hourly.weather.first!.id
//    }
//}
//
//extension HourlyForecast: Hashable {
//
//    var id: UUID {
//        return UUID()
//    }
//    
//    func hash(into hasher: inout Hasher) {
//        hasher.combine(id)
//    }
//}
