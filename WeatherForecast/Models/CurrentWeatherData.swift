//
//  CurrentWeatherData.swift
//  WeatherForecast
//
//  Created by Василий Пронин on 07.02.2022.
//

struct CurrentWeatherData: Codable {
    let weather: [Weather]
    let main: Main
    let wind: Wind
    let name: String
}

struct Weather: Codable {
    let id: Int
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
