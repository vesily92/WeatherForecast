//
//  CurrentWeather.swift
//  WeatherForecast
//
//  Created by Василий Пронин on 07.02.2022.
//

import Foundation

struct CurrentWeather: Codable {
    let cityName: String
    let time: Int
    let sunrise: Int
    let sunset: Int
    let temp: Double
    let feelsLike: Double
    let description: String
    let visibility: Int
    let pressure: Int
    let humidity: Int
    let timezone: Int
//    let windSpeed: Int
//    let windDirection: Int
    let conditionCode: Int
    
    var timeString: String {
        return DateFormatter.format(time, to: .detailed, withTimeZoneOffset: timezone)
    }
    var sunriseString: String {
        return DateFormatter.format(sunrise, to: .sunrise, withTimeZoneOffset: timezone)
    }
    var sunsetString: String {
        return DateFormatter.format(sunset, to: .sunrise, withTimeZoneOffset: timezone)
    }
    var tempString: String {
        return temp.displayTemp()
    }
    var feelsLikeString: String {
        return "Feels like: " + feelsLike.displayTemp()
    }
    var descriptionString: String {
        return description.capitalized
    }
    var visibilityString: String {
        return "\(visibility)"
    }
    var pressureString: String {
        return "\(pressure)"
    }
    var humidityString: String {
        return "\(humidity)"
    }
//    var windSpeedString: String {
//        return "\(windSpeed)"
//    }
//    var windDirectionString: String {
//        return "\(windDirection)"
//    }
    var sunIsUp: Bool = false
    var systemNameString: String {
        switch conditionCode {
        case 200...232: return "cloud.bolt.rain.fill"
        case 300...321: return "cloud.drizzle.fill"
        case 500...531: return "cloud.heavyrain.fill"
        case 600...622: return "cloud.snow.fill"
        case 700...781: return "cloud.fog.fill"
        case 800: return sunIsUp ? "sun.max.fill" : "moon.stars.fill"
        case 801...804: return sunIsUp ? "cloud.sun.fill" : "cloud.moon.fill"
        default: return "nosign"
        }
    }
    
    init?(model: CurrentWeatherData) {
        
        if model.weather.first!.icon.hasSuffix("d") {
            sunIsUp = true
        }
        
        cityName = model.name
        time = model.dt
        sunrise = model.sys.sunrise
        sunset = model.sys.sunset
        temp = model.main.temp
        feelsLike = model.main.feelsLike
        description = model.weather.first!.description
        visibility = model.visibility
        pressure = model.main.pressure
        humidity = model.main.humidity
        timezone = model.timezone
//        windSpeed = model.wind.speed ?? 0
//        windDirection = model.wind.deg ?? 0
        conditionCode = model.weather.first!.id
    }
}

extension CurrentWeather: Hashable {
    
    var id: UUID {
        return UUID()
    }
    
    static func == (lhs: CurrentWeather, rhs: CurrentWeather) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(cityName)
        hasher.combine(time)
        hasher.combine(sunrise)
        hasher.combine(sunset)
        hasher.combine(temp)
        hasher.combine(feelsLike)
        hasher.combine(description)
        hasher.combine(visibility)
        hasher.combine(pressure)
        hasher.combine(humidity)
//        hasher.combine(windSpeed)
//        hasher.combine(windDirection)
        hasher.combine(conditionCode)
    }
}
