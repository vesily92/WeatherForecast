//
//  WeatherData.swift
//  WeatherForecast
//
//  Created by Василий Пронин on 07.02.2022.
//
import Foundation

enum Section: Int, Hashable, CaseIterable, CustomStringConvertible {
    var description: String {
        return ""
    }
    
    //case alert
    //case current
    case hourly
    case daily
    
    var headerTitle: String {
        switch self {
        //case .alert: return ""
        //case .current: return ""
        case .hourly: return "Hourly forecast"
        case .daily: return "7-day forecast"
        }
    }
    var headerIcon: String {
        switch self {
        case .hourly: return "clock"
        case .daily: return "calendar"
        }
    }
}

struct ForecastData: Codable {
    enum CodingKeys: String, CodingKey {
        case lat
        case lon
        case timezone
        case timezoneOffset = "timezone_offset"
        case current
        case hourly
        case daily
        case alerts
    }
    
    let lat: Double
    let lon: Double
    let timezone: String
    let timezoneOffset: Int
    let current: Current
    let hourly: [Hourly]
    let daily: [Daily]
    let alerts: [Alert]?
}

struct Current: Codable, Hashable {
    private enum CodingKeys: String, CodingKey {
        case dt
        case sunrise
        case sunset
        case temp
        case feelsLike = "feels_like"
        case weather
    }
    
    let id = UUID()
    let dt: Int
    let sunrise: Int
    let sunset: Int
    let temp: Double
    let feelsLike: Double
    let weather: [Weather]
    
    var sunIsUp: Bool {
        let hour = DateFormatter.getHour(from: dt)
        switch hour {
        case 7...21: return true
        default: return false
        }
    }
    var systemNameString: String {
        switch weather.first!.id {
        case 200...232: return "cloud.bolt.rain.fill"
        case 300...321: return "cloud.drizzle.fill"
        case 500...531: return "cloud.heavyrain.fill"
        case 600...622: return "snowflake"
        case 700...781: return "cloud.fog.fill"
        case 800: return sunIsUp ? "sun.max.fill" : "moon.stars.fill"
        case 801...804: return sunIsUp ? "cloud.sun.fill" : "cloud.moon.fill"
        default: return "nosign"
        }
    }
    
    static func == (lhs: Current, rhs: Current) -> Bool {
        return lhs.id == rhs.id
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct Hourly: Codable, Hashable {
    enum CodingKeys: String, CodingKey {
        case dt
        case temp
        case feelsLike = "feels_like"
        case weather
        case pop
    }
    
    let id = UUID()
    let dt: Int
    let temp: Double
    let feelsLike: Double
    let weather: [Weather]
    let pop: Double
    
    var sunIsUp: Bool {
        let hour = DateFormatter.getHour(from: dt)
        switch hour {
        case 7...21: return true
        default: return false
        }
    }
    var systemNameString: String {
        switch weather.first!.id {
        case 200...232: return "cloud.bolt.rain.fill"
        case 300...321: return "cloud.drizzle.fill"
        case 500...531: return "cloud.heavyrain.fill"
        case 600...622: return "snowflake"
        case 700...781: return "cloud.fog.fill"
        case 800: return sunIsUp ? "sun.max.fill" : "moon.stars.fill"
        case 801...804: return sunIsUp ? "cloud.sun.fill" : "cloud.moon.fill"
        default: return "nosign"
        }
    }
    
    static func == (lhs: Hourly, rhs: Hourly) -> Bool {
        return lhs.id == rhs.id
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct Daily: Codable, Hashable {
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
    
    let id = UUID()
    let dt: Int
    let sunrise: Int
    let sunset: Int
    let temperature: Temperature
    let pressure: Int
    let humidity: Int
    let windSpeed: Double
    let weather: [Weather]
    let pop: Double
    let uvi: Double
    
    static func == (lhs: Daily, rhs: Daily) -> Bool {
        return lhs.id == rhs.id
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct Alert: Codable, Hashable {
    enum CodingKeys: String, CodingKey {
        case senderName = "sender_name"
        case event
        case start
        case end
        case alertDescription = "description"
        case tags
    }
    
    let id = UUID()
    let senderName: String
    let event: String
    let start: Int
    let end: Int
    let alertDescription: String
    let tags: [String]
    
    static func == (lhs: Alert, rhs: Alert) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct Temperature: Codable {
    let min: Double
    let max: Double
    
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
}

