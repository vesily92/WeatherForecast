//
//  HourlyWeather.swift
//  WeatherForecast
//
//  Created by Василий Пронин on 17.05.2022.
//

import Foundation

struct HourlyWeather: Codable {
    let time: Int
    let temp: Double
    let pop: Double
    let conditionCode: Int
    
//    var timeString: String {
//        return DateFormatter.format(time, to: .detailed)
//    }
    var tempString: String {
        return temp.displayTemp()
    }
    var popString: String {
        return pop.displayPop() ?? ""
    }
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
    
    init?(model: Hourly) {
        
        if model.weather.first!.icon.hasSuffix("d") {
            sunIsUp = true
        }
        
        time = model.dt
        temp = model.temp
        pop = model.pop
        conditionCode = model.weather.first!.id
        
    }
}

extension HourlyWeather: Hashable {
    
    var id: UUID {
        return UUID()
    }
    
    static func == (lhs: HourlyWeather, rhs: HourlyWeather) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(time)
        hasher.combine(temp)
        hasher.combine(pop)
        hasher.combine(conditionCode)
    }
}
