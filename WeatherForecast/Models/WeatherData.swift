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
}

enum Section2: Int, Hashable, CaseIterable, CustomStringConvertible {
    case alert
    case current
    case hourly
    case daily
    
    var description: String {
        switch self {
        case .alert: return ""
        case .current: return ""
        case .hourly: return ""
        case .daily: return ""
        }
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

struct ForecastData: Codable {
    let identifier = UUID()
    
    let lat: Double
    let lon: Double
    let timezone: String
    let timezoneOffset: Int
    let current: Current
    let hourly: [Hourly]
    let daily: [Daily]
    let alerts: [Alert]
    
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
}

struct Current: Codable {
    let dt: Int
    let sunrise: Int
    let sunset: Int
    let temp: Double
    let feelsLike: Double
    let weather: [Weather]
    
    private enum CodingKeys: String, CodingKey {
        case dt
        case sunrise
        case sunset
        case temp
        case feelsLike = "feels_like"
        case weather
    }
}

extension Current: Hashable {
    var id: UUID {
        let id = UUID()
        return id
    }
    
    static func == (lhs: Current, rhs: Current) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

//extension Current: Hashable {
//    var identifier: UUID {
//        let id = UUID()
//        return id
//    }
//    
//    static func == (lhs: Current, rhs: Current) -> Bool {
//        return lhs.identifier == rhs.identifier
//    }
//
//    func hash(into hasher: inout Hasher) {
//        hasher.combine(identifier)
//    }
//}

struct Hourly: Codable, Hashable {
    let identifier = UUID()
    
    let dt: Int
    let temp: Double
    let feelsLike: Double
    let weather: [Weather]
    let pop: Double
    
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

struct Alert: Codable, Hashable {
    let identifier = UUID()
    
    let senderName: String
    let event: String
    let start: Int
    let end: Int
    let alertDescription: String
    let tags: [String]
    
    enum CodingKeys: String, CodingKey {
        case senderName = "sender_name"
        case event
        case start
        case end
        case alertDescription = "description"
        case tags
    }
    
    static func == (lhs: Alert, rhs: Alert) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
}

