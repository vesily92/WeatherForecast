//
//  WeatherData.swift
//  WeatherForecast
//
//  Created by Василий Пронин on 07.02.2022.
//
import Foundation

enum Section: Int, Hashable, CaseIterable {
   
    case alert
    case hourlyCollection
    case daily
    case uviAndHumidity
    case pressureAndWind
    
    var headerTitle: String {
        switch self {
        case .alert: return "Weather Alert"
        case .hourlyCollection: return "Hourly Forecast"
        case .daily: return "Daily Forecast"
        case .uviAndHumidity: return ""
        case .pressureAndWind: return ""
        }
    }
    var headerIcon: String {
        switch self {
        case .alert: return "exclamationmark.triangle.fill"
        case .hourlyCollection: return "clock"
        case .daily: return "calendar"
        case .uviAndHumidity: return ""
        case .pressureAndWind: return ""
        }
    }
}

struct ForecastData: Codable {
    
    let id = UUID()
    let lat: Double
    let lon: Double
    let timezone: String
    let timezoneOffset: Int
    let current: Current
    let hourly: [Hourly]
    let daily: [Daily]
    let alerts: [Alert]?
    
    enum CodingKeys: String, CodingKey {
        case lat, lon, timezone
        case timezoneOffset = "timezone_offset"
        case current, hourly, daily, alerts
    }
}

extension ForecastData: Hashable {
    static func == (lhs: ForecastData, rhs: ForecastData) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct Current: Codable {
    
    let id = UUID()
    let dt: Int
    let sunrise: Int
    let sunset: Int
    let temp: Double
    let feelsLike: Double
    let pressure: Double
    let humidity: Double
    let uvi: Double
    let visibility: Double
    let windSpeed: Double
    let weather: [Weather]
    
    enum CodingKeys: String, CodingKey {
        case dt, sunrise, sunset, temp
        case feelsLike = "feels_like"
        case pressure, humidity, uvi, visibility
        case windSpeed = "wind_speed"
        case weather
    }
}

extension Current: Hashable {
    static func == (lhs: Current, rhs: Current) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct Hourly: Codable {
    
    let id = UUID()
    let dt: Int
    let temp: Double
    let feelsLike: Double
    let weather: [Weather]
    let pop: Double
    
    enum CodingKeys: String, CodingKey {
        case dt, temp
        case feelsLike = "feels_like"
        case weather, pop
    }
}

extension Hourly: Hashable {
    static func == (lhs: Hourly, rhs: Hourly) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct Daily: Codable {
    
    let id = UUID()
    let dt: Int
    let sunrise: Int
    let sunset: Int
    let temperature: Temperature
    let feelsLike: FeelsLike
    let pressure: Int
    let humidity: Int
    let dewPoint: Double
    let windSpeed: Double
    let windDeg: Int
    let weather: [Weather]
    let pop: Double
    let uvi: Double
    
    enum CodingKeys: String, CodingKey {
        case dt, sunrise, sunset
        case temperature = "temp"
        case feelsLike = "feels_like"
        case pressure, humidity
        case dewPoint = "dew_point"
        case windSpeed = "wind_speed"
        case windDeg = "wind_deg"
        case weather, pop, uvi
    }
}

extension Daily: Hashable {
    static func == (lhs: Daily, rhs: Daily) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct Alert: Codable {
    
    let id = UUID()
    let senderName: String
    let event: String
    let start: Int
    let end: Int
    let alertDescription: String
    let tags: [String]
    
    enum CodingKeys: String, CodingKey {
        case senderName = "sender_name"
        case event, start, end
        case alertDescription = "description"
        case tags
    }
}

extension Alert: Hashable {
    static func == (lhs: Alert, rhs: Alert) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct Temperature: Codable {
    
    let id = UUID()
    let day: Double
    let min: Double
    let max: Double
    let night: Double
    let eve: Double
    let morn: Double
    
    enum CodingKeys: CodingKey {
        case id, day, min, max, night, eve, morn
    }
}

extension Temperature: Hashable {
    static func == (lhs: Temperature, rhs: Temperature) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct FeelsLike: Codable {
    
    let id = UUID()
    let day: Double
    let night: Double
    let eve: Double
    let morn: Double
    
    enum CodingKeys: CodingKey {
        case id, day, night, eve, morn
    }
}

extension FeelsLike: Hashable {
    static func == (lhs: FeelsLike, rhs: FeelsLike) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct Weather: Codable {
    
    let id: Int
    let description: String
    let icon: String
}

extension Weather {
    var sunIsUp: Bool {
        if icon.hasSuffix("d") {
            return true
        }
        return false
    }
    
    var systemNameString: String {
        switch id {
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
    
    var isPopNeeded: Bool {
        switch id {
        case 200...232: return true
        case 300...321: return true
        case 500...531: return true
        case 600...622: return true
        default: return false
        }
    }
}

extension Weather: Hashable {
    static func == (lhs: Weather, rhs: Weather) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
