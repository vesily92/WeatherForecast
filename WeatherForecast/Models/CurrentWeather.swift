//
//  CurrentWeather.swift
//  WeatherForecast
//
//  Created by Василий Пронин on 07.02.2022.
//

struct CurrentWeather {
    let cityName: String
    
    let temperature: Double
    var temperatureString: String {
        return String(format: "%0f", temperature)
    }
    
    let feelsLike: Double
    var feelsLikeString: String {
        return String(format: "%0f", feelsLike)
    }
    
    let conditionCode: Int
    
    init?(currentWeatherData: CurrentWeatherData) {
        cityName = currentWeatherData.name
        temperature = currentWeatherData.main.temp
        feelsLike = currentWeatherData.main.feelsLike
        conditionCode = currentWeatherData.weather.first!.id
    }
}
