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

struct Weather: Codable, Hashable {
    let id: Int
    let description: String
    
    var identifier: UUID {
        return UUID()
    }
    
    static func == (lhs: Weather, rhs: Weather) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
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
    
    let dt: Int
    let sunrise: Int?
    let sunset: Int?
    let temperature: Temperature
    let pressure: Int
    let humidity: Int
    let windSpeed: Double
    let weather: [Weather]
    let pop: Double
    let uvi: Double
    
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


