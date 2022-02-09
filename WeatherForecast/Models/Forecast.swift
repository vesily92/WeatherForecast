//
//  Forecast.swift
//  WeatherForecast
//
//  Created by Василий Пронин on 09.02.2022.
//

struct HourlyForecast {
    let dt: Int
    var time: String {
        return DateManager.shared.defineDate(withUnixTime: dt, andDateFormat: .time)
    }
    
    let hourlyTemperature: Double
    var hourlyTemperatureString: String {
        return String(format: "%.0f", hourlyTemperature.rounded(.toNearestOrAwayFromZero))
    }
    
    let probabilityOfPrecipitation: Int
    var probabilityOfPrecipitationString: String {
        return "\(probabilityOfPrecipitation)%"
    }
    
    let conditionCode: Int
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
}

struct DailyForecast {
    let dt: Int
    var date: String {
        return DateManager.shared.defineDate(withUnixTime: dt, andDateFormat: .date)
    }
    var weekDay: String {
        return DateManager.shared.defineDate(withUnixTime: dt, andDateFormat: .weekDay)
    }
    
    let sunrise: Int
    var sunriseString: String {
        return "\(sunrise)"
    }
    
    let sunset: Int
    var sunsetString: String {
        return "\(sunset)"
    }
    
    let highestTemperature: Double
    var highestTemperatureString: String {
        return String(format: "%.0f", highestTemperature.rounded(.toNearestOrAwayFromZero))
    }
    
    let lowestTemperature: Double
    var lowestTemperatureString: String {
        return String(format: "%.0f", lowestTemperature.rounded(.toNearestOrAwayFromZero))
    }
    
    let windSpeed: Double
    var windSpeedString: String {
        return String(format: "%.0f", windSpeed.rounded(.toNearestOrAwayFromZero)) + " m/s"
    }
    
    let pressure: Int
    var pressureString: String {
        return "\(pressure) mmHg"
    }
    
    let humidity: Int
    var humidityString: String {
        return "\(humidity) %"
    }
    
    let probabilityOfPrecipitation: Double
    var probabilityOfPrecipitationString: String {
        return String(format: "%.0f", probabilityOfPrecipitation.rounded(.toNearestOrAwayFromZero)) + " %"
    }
    
    let uvIndex: Double
    var uvIndexString: String {
        return String(format: "%.0f", uvIndex.rounded(.toNearestOrAwayFromZero))
    }
    
    let conditionCode: Int
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
}
