//
//  WeatherData.swift
//  WeatherForecast
//
//  Created by Василий Пронин on 07.02.2022.
//
import Foundation

struct CurrentWeatherData: Codable {
    let weather: [Weather]
    let main: Main
    let wind: Wind
    let name: String
}

struct Weather: Codable {
    let id: Int
    let description: String
    
    var systemNameString: String {
        switch id {
        case 200...232: return "cloud.bolt.rain.fill" //"11d"
        case 300...321: return "cloud.drizzle.fill" //"09d"
        case 500...531: return "cloud.heavyrain.fill" //"10d"
        case 600...622: return "snowflake" //"13d"
        case 700...781: return "cloud.fog.fill" //"50d"
        case 800: return "sun.max.fill" //"01d"
        case 801...804: return "cloud.sun.fill" //"04d"
        default: return "nosign"
        }
    }
    
//    var identifier: UUID {
//        return UUID()
//    }
//
//    static func == (lhs: Weather, rhs: Weather) -> Bool {
//        return lhs.identifier == rhs.identifier
//    }
//
//    func hash(into hasher: inout Hasher) {
//        hasher.combine(identifier)
//    }
}

struct Main: Codable {
    let temp: Double
    let feelsLike: Double
    let pressure: Int
    
    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case pressure
    }
}

struct Wind: Codable {
    let speed: Double
}

struct ForecastData: Codable, Hashable {
    let identifier = UUID()
    
    let lat: Double
    let lon: Double
    let timezone: String
    let timezoneOffset: Int
    let current: Current
    let hourly: [Current]
    let daily: [Daily]
    
    enum CodingKeys: String, CodingKey {
        case lat
        case lon
        case timezone
        case timezoneOffset = "timezone_offset"
        case current
        case hourly
        case daily
    }
    
    static func == (lhs: ForecastData, rhs: ForecastData) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
}

struct Current: Codable, Hashable {
    let identifier = UUID()
    
    let dt: Int?
    let temp: Double?
    let feelsLike: Double?
    let weather: [Weather]?
    let pop: Int?
    
    enum CodingKeys: String, CodingKey {
        case dt
        case temp
        case feelsLike = "feels_like"
        case weather
        case pop
    }
    
    static func == (lhs: Current, rhs: Current) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
}

struct Hourly: Codable, Hashable {
    let identifier = UUID()
    
    let dt: Int?
    let temp: Double?
    let feelsLike: Double?
    let weather: [Weather]?
    let pop: Double?
    
    var sectionName = "Hourly Forecast"
    
    enum CodingKeys: String, CodingKey {
        case dt
        case temp
        case feelsLike = "feels_like"
        case weather
        case pop
    }
    
    static func == (lhs: Hourly, rhs: Hourly) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
}

struct Daily: Codable, Hashable {
    let identifier = UUID()
    
    let dt: Int?
    let sunrise: Int?
    let sunset: Int?
    let temperature: Temperature?
    let pressure: Int?
    let humidity: Int?
    let windSpeed: Double?
    let weather: [Weather]?
    let pop: Double?
    let uvi: Double?
    
    var sectionName = "7-Day Forecast"
    
    enum CodingKeys: String, CodingKey {
        case dt
        case sunrise
        case sunset
        case temperature = "temp"
        case pressure
        case humidity
        case windSpeed = "wind_speed"
        case weather
        case pop
        case uvi
    }
    
    static func == (lhs: Daily, rhs: Daily) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
}

struct Temperature: Codable {
    let min: Double
    let max: Double
    
}


