//
//  Daily.swift
//  WeatherForecast
//
//  Created by Василий Пронин on 10.02.2022.
//

import Foundation

//struct DailyForecast: Codable {
//    var dateString: String {
//        return DateManager.shared.defineDate(withUnixTime: dt, andDateFormat: .date)
//    }
//    var weekdayString: String {
//        return DateManager.shared.defineDate(withUnixTime: dt, andDateFormat: .weekday)
//    }
//    var sunriseString: String { return "\(sunrise)" }
//    var sunsetString: String { return "\(sunset)" }
//    var highestTemperatureString: String {
//        return String(format: "%.0f", highestTemperature.rounded(.toNearestOrAwayFromZero))
//    }
//    var lowestTemperatureString: String {
//        return String(format: "%.0f", lowestTemperature.rounded(.toNearestOrAwayFromZero))
//    }
//    var windSpeedString: String {
//        return String(format: "%.0f", windSpeed.rounded(.toNearestOrAwayFromZero)) + " m/s"
//    }
//    var pressureString: String { return "\(pressure) mmHg" }
//    var humidityString: String { return "\(humidity) %" }
//    var probabilityOfPrecipitationString: String {
//        return String(format: "%.0f", probabilityOfPrecipitation.rounded(.toNearestOrAwayFromZero)) + " %"
//    }
//    var uvIndexString: String {
//        return String(format: "%.0f", uvIndex.rounded(.toNearestOrAwayFromZero))
//    }
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
//    private let sunrise: Int
//    private let sunset: Int
//    private let highestTemperature: Double
//    private let lowestTemperature: Double
//    private let windSpeed: Double
//    private let pressure: Int
//    private let humidity: Int
//    private let probabilityOfPrecipitation: Double
//    private let uvIndex: Double
//    private let conditionCode: Int
//    
//    init?(daily: Daily) {
//        dt = daily.dt
//        sunrise = daily.sunrise
//        sunset = daily.sunset
//        highestTemperature = daily.temperature.max
//        lowestTemperature = daily.temperature.min
//        windSpeed = daily.windSpeed
//        pressure = daily.pressure
//        humidity = daily.humidity
//        probabilityOfPrecipitation = daily.pop
//        uvIndex = daily.uvi
//        conditionCode = daily.weather.first!.id
//    }
//}
//
//extension DailyForecast: Hashable {
//
//    var identifier: UUID {
//        return UUID()
//    }
//    
//    func hash(into hasher: inout Hasher) {
//        hasher.combine(identifier)
//    }
//}
