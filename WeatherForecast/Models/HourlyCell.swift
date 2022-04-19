//
//  HourlyCell.swift
//  WeatherForecast
//
//  Created by Василий Пронин on 08.04.2022.
//

import UIKit

struct HourlyCell: Codable, Hashable {
    
    var id: UUID {
        let id = UUID()
        return id
    }
    
    let time: String
    let temperature: String
    let probabilityOfPrecipitation: String
    let iconName: String
    
    static func == (lhs: HourlyCell, rhs: HourlyCell) -> Bool {
        return lhs.id == rhs.id
    }
    
    init?(model: ForecastData) {
        
        var hourlyTime: [Int] {
            var timeArray: [Int] = []
            model.hourly.forEach { hourly in
                timeArray.append(hourly.dt)
            }
            return timeArray
        }
        
        var sunrises: [Int] {
            var timeArray: [Int] = []
            model.daily.forEach { daily in
                timeArray.append(daily.sunrise)
            }
            return timeArray
        }
        
        var sunsets: [Int] {
            var timeArray: [Int] = []
            model.daily.forEach { daily in
                timeArray.append(daily.sunset)
            }
            return timeArray
        }
        
        var iconID: Int {
            var idArray: [Int] = []
            model.hourly.forEach { hourly in
                idArray.append(hourly.weather.first!.id)
            }
            return idArray.removeFirst()
        }
        
        var time: Int {
            var timeArray: [Int] = []
            timeArray.append(contentsOf: hourlyTime)
            timeArray.append(contentsOf: sunrises)
            timeArray.append(contentsOf: sunsets)
            var sorted = timeArray.sorted(by: <)
            return sorted.removeFirst()
        }
        
        var isHourly: Bool {
            hourlyTime.contains(time)
        }
        
        var isSunrise: Bool {
            sunrises.contains(time)
        }
        
        var temp: Double {
            var tempArray: [Double] = []
            model.hourly.forEach { hourly in
                tempArray.append(hourly.temp)
            }
            return tempArray.removeFirst()
        }
        
        var pop: Double {
            var popArray: [Double] = []
            model.hourly.forEach { hourly in
                popArray.append(hourly.pop)
            }
            return popArray.removeFirst()
        }
        
        var systemNameString: String {
            switch iconID {
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
        
        self.time = isHourly
        ? DateFormatter.format(unixTime: time, to: .time)
        : DateFormatter.format(unixTime: time, to: .sunrise)
        
        temperature = isHourly
        ? temp.displayTemp()
        : (isSunrise ? "Sunrise" : "Sunset")
        
        probabilityOfPrecipitation = pop.displayPop() ?? ""
        iconName = isHourly
        ? systemNameString
        : (isSunrise ? "sunrise.fill" : "sunset.fill")
    }
//    
//    init?(sunrise: Daily) {
//        time = DateFormatter.format(unixTime: sunrise.sunrise, to: .sunrise)
//        temperature = "Sunrise"
//        probabilityOfPrecipitation = ""
//        iconName = "sunrise.fill"
//    }
//    
//    init?(sunset: Daily) {
//        time = DateFormatter.format(unixTime: sunset.sunset, to: .sunrise)
//        temperature = "Sunset"
//        probabilityOfPrecipitation = ""
//        iconName = "sunset.fill"
//    }
}
