//
//  Weather.swift
//  WeatherForecast
//
//  Created by Василий Пронин on 25.03.2022.
//

import Foundation

extension ForecastData {
    
    struct CurrentData: Codable, Hashable {
        var id: UUID {
            let id = UUID()
            return id
        }
        
        let temperature: String
        let description: String
        let feelsLike: String
//        let conditionCode: Int
        let systemNameString: String
        
//        init?(model: ForecastData) {
//            temperature = String(format: "%.0f", model.current.temp.rounded(.toNearestOrAwayFromZero))
//            description = model.current.temp.description
//            feelsLike = String(format: "%.0f", model.current.feelsLike.rounded(.toNearestOrAwayFromZero))
////            conditionCode = model.weather.first!.id
//            systemNameString = model.current.weather.first?.systemNameString ?? ""
//        }
//        init?(model: Current) {
//            temperature = String(format: "%.0f", model.temp.rounded(.toNearestOrAwayFromZero))
//            description = model.weather.first?.description ?? ""
//            feelsLike = String(format: "%.0f", model.feelsLike.rounded(.toNearestOrAwayFromZero))
////            conditionCode = model.weather.first!.id
//            systemNameString = model.weather.first?.systemNameString ?? ""
//        }
    }
    
    struct HourlyData: Codable, Hashable {
        var id: UUID {
            let id = UUID()
            return id
        }
        
        let time: String
        let temperature: String
        let probabilityOfPrecipitation: String
//        let conditionCode: Int
        //let systemNameString: String
        
//        init?(model: ForecastData) {
//            time = DateManager.shared.defineDate(withUnixTime: model.hourly.first!.dt, andDateFormat: .time)
//            temperature = String(format: "%.0f", model.hourly.first!.temp.rounded(.toNearestOrAwayFromZero))
//            probabilityOfPrecipitation = "\(model.hourly.first!.pop) %"
//            conditionCode = model.weather.first!.id
            //systemNameString = model.hourly.first!.weather.first!.systemNameString
        }
    }
    
    struct DailyData: Codable, Hashable {
        var id: UUID {
            let id = UUID()
            return id
        }
        
        let date: String
        let weekday: String
        let sunrise: String
        let sunset: String
        let highestTemperature: String
        let lowestTemperature: String
        let probabilityOfPrecipitation: String
//        let conditionCode: Int
        //let systemNameString: String
        
//        init?(model: ForecastData) {
//            date = DateManager.shared.defineDate(withUnixTime: model.daily.first!.dt, andDateFormat: .date)
//            weekday = DateManager.shared.defineDate(withUnixTime: model.daily.first!.dt, andDateFormat: .weekday)
//            sunrise = DateManager.shared.defineDate(withUnixTime: model.daily.first!.sunrise, andDateFormat: .time)
//            sunset = DateManager.shared.defineDate(withUnixTime: model.daily.first!.sunset, andDateFormat: .time)
//            highestTemperature = String(format: "%.0f", model.daily.first!.temperature.max.rounded(.toNearestOrAwayFromZero))
//            lowestTemperature = String(format: "%.0f", model.daily.first!.temperature.min.rounded(.toNearestOrAwayFromZero))
//            probabilityOfPrecipitation = String(format: "%.0f", model.daily.first!.pop.rounded(.toNearestOrAwayFromZero)) + " %"
//            conditionCode = model.weather.first!.id
            //systemNameString = model.daily.first!.weather.first!.systemNameString
        
    
}
