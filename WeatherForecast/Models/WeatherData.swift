//
//  WeatherData.swift
//  WeatherForecast
//
//  Created by Василий Пронин on 07.02.2022.
//

enum Section: Int, CaseIterable {
    case currentWeather, hourlyForecast, dailyForecast
}

struct CurrentWeatherData: Codable {
    let weather: [Weather]
    let main: Main
    let wind: Wind
    let name: String
}

struct Weather: Codable {
    let id: Int
    let description: String
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


struct Daily: Codable {
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
}

struct Hourly: Codable {
    let dt: Int
    let temp: Double
    let weather: [Weather]
    let pop: Int
    
    enum CodingKeys: String, CodingKey {
        case dt
        case temp
        case weather
        case pop
    }
}

struct Temperature: Codable {
    let min: Double
    let max: Double
    
}


