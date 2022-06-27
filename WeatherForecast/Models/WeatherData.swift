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
    
    var headerTitle: String {
        switch self {
        case .alert: return "Weather Alert"
        case .hourlyCollection: return "Hourly Forecast"
        case .daily: return "7-Day Forecast"
        }
    }
    var headerIcon: String {
        switch self {
        case .alert: return "exclamationmark.triangle.fill"
        case .hourlyCollection: return "clock"
        case .daily: return "calendar"
        }
    }
}

struct CurrentWeatherData: Codable {
    let name: String
    let dt: Int
    let weather: [Weather]
    let main: Main
    let visibility: Int
//    let wind: Wind
    let clouds: Clouds
    let sys: Sys
    let timezone: Int
}

struct Main: Codable {
    let temp: Double
    let feelsLike: Double
    let tempMin: Double
    let tempMax: Double
    let pressure: Int
    let humidity: Int
    
    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure
        case humidity
    }
}

struct Wind: Codable {
    let speed, deg: Int?
}

struct Clouds: Codable {
    let all: Int
}

struct Sys: Codable {
    let type: Int
    let id: Int
    let country: String
    let sunrise: Int
    let sunset: Int
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
        case feelsLike = "feels_like"
        case pressure
        case humidity
        case dewPoint = "dew_point"
        case windSpeed = "wind_speed"
        case windDeg = "wind_deg"
        case weather
        case pop
        case uvi
    }
    
//    let id = UUID()
    var id: UUID = {
        let id = UUID()
        return id
    }()
    
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
    
//    var windDirections: String {
//        switch windDeg {
//        case 349...360, 0...11: return "N"
//        case 12...33: return "NNE"
//        case 34...56: return "NE"
//        case 57...78: return "ENE"
//        case 79...101: return "E"
//        case 102...123: return "ESE"
//        case 124...146: return "SE"
//        case 147...168: return "SSE"
//        case 169...191: return "S"
//        case 192...213: return "SSW"
//        case 214...236: return "SW"
//        case 237...258: return "WSW"
//        case 259...281: return "W"
//        case 282...303: return "WNW"
//        case 304...326: return "NW"
//        case 327...348: return "NNW"
//        default: return ""
//        }
//    }
//    
//    var systemNameString: String {
//        switch windDeg {
//        case 338...360, 0...23: return "arrow.up.circle.fill" //"arrow.up"
//        case 23...68: return "arrow.up.right.circle.fill" //"arrow.up.right"
//        case 69...113: return "arrow.right.circle.fill" //"arrow.right"
//        case 114...158: return "arrow.down.right.circle.fill" //"arrow.down.right"
//        case 159...203: return "arrow.down.circle.fill" //"arrow.down"
//        case 204...248: return "arrow.down.left.circle.fill" //"arrow.down.left"
//        case 249...293: return "arrow.left.circle.fill" //"arrow.left"
//        case 293...337: return "arrow.up.left.circle.fill" //"arrow.up.left"
//        default: return "nosign"
//            
//        }
//    }
//    
//    var uviDescription: String {
//        switch uvi {
//        case 0.0...3.0: return "Low"
//        case 4.0...5.0: return "Moderate"
//        case 6.0...7.0: return "High"
//        case 8.0...10.0: return "Very High"
//        default: return ""
//        }
//    }
    
    static func == (lhs: Daily, rhs: Daily) -> Bool {
        return lhs.id == rhs.id
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(dt)
        hasher.combine(sunrise)
        hasher.combine(sunset)
        hasher.combine(temperature)
        hasher.combine(feelsLike)
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
    enum CodingKeys: CodingKey {
        case id, day, min, max, night, eve, morn
    }
    let id = UUID()
    
    let day: Double
    let min: Double
    let max: Double
    let night: Double
    let eve: Double
    let morn: Double
    
    static func == (lhs: Temperature, rhs: Temperature) -> Bool {
        return lhs.id == rhs.id
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(day)
        hasher.combine(min)
        hasher.combine(max)
        hasher.combine(night)
        hasher.combine(eve)
        hasher.combine(morn)
    }
}

struct FeelsLike: Codable, Hashable {
    enum CodingKeys: CodingKey {
        case id, day, night, eve, morn
    }
    let id = UUID()
    
    let day: Double
    let night: Double
    let eve: Double
    let morn: Double
    
    static func == (lhs: FeelsLike, rhs: FeelsLike) -> Bool {
        return lhs.id == rhs.id
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(day)
        hasher.combine(night)
        hasher.combine(eve)
        hasher.combine(morn)
    }
}

struct Weather: Codable, Hashable {
    let id: Int
    let description: String
    let icon: String
    
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
    
    static func == (lhs: Weather, rhs: Weather) -> Bool {
        return lhs.id == rhs.id
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(description)
        hasher.combine(icon)
    }
}
