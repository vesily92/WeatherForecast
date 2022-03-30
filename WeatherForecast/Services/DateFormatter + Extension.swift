//
//  DateFormatter + Extension.swift
//  WeatherForecast
//
//  Created by Василий Пронин on 29.03.2022.
//

import Foundation

enum PreferableFormat {
    case time
    case weekday
    case date
}

enum DateFormat {
    case hour
    case day
}

extension DateFormatter {
    static func format(unixTime: Int, to dateFormat: PreferableFormat) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(unixTime))
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        
        switch dateFormat {
        case .time: dateFormatter.dateFormat = "HH"
        case .weekday: dateFormatter.dateFormat = "EE"
        case .date: dateFormatter.dateFormat = "d MMMM"
        }
        
        return dateFormatter.string(from: date)
    }
    
    static func getHour(from unixTime: Int) -> Int {
        let date = Date(timeIntervalSince1970: TimeInterval(unixTime))
        let dateFormatter = DateFormatter()
        
        return dateFormatter.calendar.component(.hour, from: date)
    }
    
    static func compare(_ dateFormat: DateFormat, with unixTime: Int) -> Bool {
        let date = Date(timeIntervalSince1970: TimeInterval(unixTime))
        let currentDate = Date()
        let calendar = Calendar.current
        
        var isNow: Bool {
            let today = calendar.component(.day, from: currentDate)
            let now = calendar.component(.hour, from: currentDate)
            let day = calendar.component(.day, from: date)
            let hour = calendar.component(.hour, from: date)
            
            if today == day && now == hour {
                return true
            } else {
                return false
            }
        }
        switch dateFormat {
        case .hour:
            return isNow ? true : false
        case .day:
            return calendar.isDateInToday(date)
        }
    }
}
