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
    
//    case current
    case alert
    case hourly
    case daily
//    case grid
    
    var headerTitle: String {
        switch self {
//        case .current: return ""
        case .alert: return "Severe weather"
        case .hourly: return "Hourly forecast"
        case .daily: return "7-day forecast"
//        case .grid: return ""
        }
    }
    var headerIcon: String {
        switch self {
//        case .current: return ""
        case .alert: return "exclamationmark.triangle.fill"
        case .hourly: return "clock"
        case .daily: return "calendar"
//        case .grid: return ""
        }
    }
}

struct ForecastData: Codable, Hashable {
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
    
    let id = UUID()
    
    let lat: Double
    let lon: Double
    let timezone: String
    let timezoneOffset: Int
    let current: Current
    let hourly: [Hourly]
    let daily: [Daily]
    let alerts: [Alert]?
    
    static func == (lhs: ForecastData, rhs: ForecastData) -> Bool {
        return lhs.id == rhs.id
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(lat)
        hasher.combine(lon)
        hasher.combine(timezone)
        hasher.combine(timezoneOffset)
        hasher.combine(current)
        hasher.combine(hourly)
        hasher.combine(daily)
        hasher.combine(alerts)
    }
}

struct Current: Codable, Hashable {
    private enum CodingKeys: String, CodingKey {
        case dt
        case sunrise
        case sunset
        case temp
        case feelsLike = "feels_like"
        case pressure
        case humidity
        case uvi
        case visibility
        case windSpeed = "wind_speed"
        case weather
    }
    
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
    
    static func == (lhs: Current, rhs: Current) -> Bool {
        return lhs.id == rhs.id
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(dt)
        hasher.combine(sunrise)
        hasher.combine(sunset)
        hasher.combine(temp)
        hasher.combine(feelsLike)
        hasher.combine(pressure)
        hasher.combine(humidity)
        hasher.combine(uvi)
        hasher.combine(visibility)
        hasher.combine(windSpeed)
        hasher.combine(weather)
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
    
    static func == (lhs: Hourly, rhs: Hourly) -> Bool {
        return lhs.id == rhs.id
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(dt)
        hasher.combine(temp)
        hasher.combine(feelsLike)
        hasher.combine(weather)
        hasher.combine(pop)
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
        hasher.combine(dt)
        hasher.combine(sunrise)
        hasher.combine(sunset)
        hasher.combine(temperature)
        hasher.combine(pressure)
        hasher.combine(humidity)
        hasher.combine(windSpeed)
        hasher.combine(weather)
        hasher.combine(pop)
        hasher.combine(uvi)
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
    
    static var mockup: [Alert] {
        let alert1 = Alert(
            senderName: "NWS Shreveport (Shreveport)",
            event: "Wind Advisory",
            start: 1648628880,
            end: 1648663200,
            alertDescription: "...WIND ADVISORY REMAINS IN EFFECT UNTIL 1 PM CDT THIS\nAFTERNOON...\n* WHAT...South winds 20 to 25 mph with gusts up to 50 mph\nexpected.\n* WHERE...Portions of north central and northwest Louisiana,\nsouth central and southwest Arkansas and east and northeast\nTexas.\n* WHEN...Through 1 PM CDT this afternoon.\n* IMPACTS...Driving conditions will be hazardous for high\nprofile vehicles and weakly rooted trees and rotted branches\ncould be downed. In addition, strong winds and rough waves on\narea lakes will create hazardous conditions for small craft.",
            tags: [
                "Wind"
            ]
        )
        
        let alert2 = Alert(
            senderName: "NWS Storm Prediction Center (Storm Prediction Center - Norman, Oklahoma)",
            event: "Tornado Watch",
            start: 1648635900,
            end: 1648663200,
            alertDescription: "TORNADO WATCH 75 IS IN EFFECT UNTIL 100 PM CDT FOR THE\nFOLLOWING LOCATIONS\nAR\n.    ARKANSAS COUNTIES INCLUDED ARE\nARKANSAS             BAXTER              BOONE\nBRADLEY              CALHOUN             CLARK\nCLEBURNE             CLEVELAND           COLUMBIA\nCONWAY               DALLAS              DESHA\nDREW                 FAULKNER            FULTON\nGARLAND              GRANT               HEMPSTEAD\nHOT SPRING           HOWARD              INDEPENDENCE\nIZARD                JACKSON             JEFFERSON\nJOHNSON              LAFAYETTE           LAWRENCE\nLINCOLN              LITTLE RIVER        LOGAN\nLONOKE               MARION              MILLER\nMONROE               MONTGOMERY          NEVADA\nNEWTON               OUACHITA            PERRY\nPIKE                 POLK                POPE\nPRAIRIE              PULASKI             RANDOLPH\nSALINE               SCOTT               SEARCY\nSEVIER               SHARP               STONE\nUNION                VAN BUREN           WHITE\nWOODRUFF             YELL",
            tags: [
                "Tornado"
            ]
        )
        return [alert1, alert2]
    }
    
    static func == (lhs: Alert, rhs: Alert) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(senderName)
        hasher.combine(event)
        hasher.combine(start)
        hasher.combine(end)
        hasher.combine(alertDescription)
        hasher.combine(tags)
    }
}

struct Temperature: Codable, Hashable {
    let id = UUID()
    
    let min: Double
    let max: Double
    
    static func == (lhs: Temperature, rhs: Temperature) -> Bool {
        return lhs.id == rhs.id
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(min)
        hasher.combine(max)
    }
}

struct Weather: Codable, Hashable {
    let id: Int
    let description: String
    
    static func == (lhs: Weather, rhs: Weather) -> Bool {
        return lhs.id == rhs.id
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(description)
    }
}

