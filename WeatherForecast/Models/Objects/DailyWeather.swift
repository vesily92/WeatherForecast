//
//  DailyWeather.swift
//  WeatherForecast
//
//  Created by Василий Пронин on 17.05.2022.
//

import Foundation

struct DailyWeather {
    
    let sunrise: Int
    let sunset: Int
    let minTemp: Double
    let maxTemp: Double
    let pressure: Int
    let humidity: Int
    let windSpeed: Double
    let pop: Double
    let uvi: Double
    let conditionCode: Int
    
//    var sunriseString: String {
//        return
//    }
//    var sunsetString: String {
//        return
//    }
    var minTempString: String {
        return minTemp.displayTemp()
    }
    var maxTempString: String {
        return maxTemp.displayTemp()
    }
    var pressureString: String {
        return "\(pressure)"
    }
    var humidityString: String {
        return "\(humidity)"
    }
    var windSpeedString: String {
        return "\(windSpeed)"
    }
    var popString: String {
        return pop.displayPop() ?? ""
    }
    var uviString: String {
        return "\(uvi)"
    }
    var systemNameString: String {
        switch conditionCode {
        case 200...232: return "cloud.bolt.rain.fill"
        case 300...321: return "cloud.drizzle.fill"
        case 500...531: return "cloud.heavyrain.fill"
        case 600...622: return "cloud.snow.fill"
        case 700...781: return "cloud.fog.fill"
        case 800: return "sun.max.fill"
        case 801...804: return "cloud.sun.fill"
        default: return "nosign"
        }
    }
    
    init?(model: Daily) {
        sunrise = model.sunrise
        sunset = model.sunset
        minTemp = model.temperature.min
        maxTemp = model.temperature.max
        pressure = model.pressure
        humidity = model.humidity
        windSpeed = model.windSpeed
        pop = model.pop
        uvi = model.uvi
        conditionCode = model.weather.first!.id
    }
}

extension DailyWeather: Hashable {
    
    var id: UUID {
        return UUID()
    }
    
    static func == (lhs: DailyWeather, rhs: DailyWeather) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(sunrise)
        hasher.combine(sunset)
        hasher.combine(minTemp)
        hasher.combine(maxTemp)
        hasher.combine(pressure)
        hasher.combine(humidity)
        hasher.combine(windSpeed)
        hasher.combine(pop)
        hasher.combine(uvi)
        hasher.combine(conditionCode)
    }
}
