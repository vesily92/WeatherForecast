//
//  CurrentWeatherData.swift
//  WeatherForecast
//
//  Created by Василий Пронин on 07.02.2022.
//

struct CurrentWeatherData {
    let coord: Coordinates
    let weather: [Weather]
    let main: Main
    let wind: Wind
    let name: String?
}

struct Coordinates {
    let lon: Double?
    let lat: Double?
}

struct Weather {
    let id: Int?
    let main: String?
    let description: String?
}

struct Main {
    let temp: Double?
    let feelsLike: Double?
    let pressure: Int?
    
    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case pressure
    }
}

struct Wind {
    let speed: Double?
}
