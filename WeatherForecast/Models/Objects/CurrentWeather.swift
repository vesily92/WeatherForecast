//
//  CurrentWeather.swift
//  WeatherForecast
//
//  Created by Василий Пронин on 07.02.2022.
//

import Foundation

struct CurrentWeather: Codable {
    
    let cityName: String
    let description: String
    
    var temperatureString: String {
        return String(format: "%.0f", temperature.rounded(.toNearestOrAwayFromZero)) + " °"
    }
    
    
    var feelsLikeString: String {
        return "Feels like: " + String(format: "%.0f", feelsLike.rounded(.toNearestOrAwayFromZero)) + " °"
    }
    
    var systemNameString: String {
        switch conditionCode {
        case 200...232: return "cloud.bolt.rain.fill" //"11d"
        case 300...321: return "cloud.drizzle.fill" //"09d"
        case 500...531: return "cloud.heavyrain.fill" //"10d"
        case 600...622: return "cloud.snow.fill" //"13d"
        case 700...781: return "cloud.fog.fill" //"50d"
        case 800: return "sun.max.fill" //"01d"
        case 801...804: return "cloud.sun.fill" //"04d"
        default: return "nosign"
        }
    }
    private let temperature: Double
    private let feelsLike: Double
    private let conditionCode: Int
    
    init?(currentWeatherData: CurrentWeatherData) {
        cityName = currentWeatherData.name
        temperature = currentWeatherData.main.temp
        description = currentWeatherData.weather.first!.description.capitalized
        feelsLike = currentWeatherData.main.feelsLike
        conditionCode = currentWeatherData.weather.first!.id
    }
}

extension CurrentWeather: Hashable {

    var id: UUID {
        return UUID()
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
