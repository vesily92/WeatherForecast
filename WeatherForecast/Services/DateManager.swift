//
//  DateManager.swift
//  WeatherForecast
//
//  Created by Василий Пронин on 09.02.2022.
//

import UIKit

enum DefineDateFormat: String {
    case time
    case sunTime
    case weekday
    case date
}

class DateManager {
    
    static let shared = DateManager()
    
    private init() {}
    
    func defineDate(withUnixTime unixTime: Int, andDateFormat dateFormat: DefineDateFormat) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(unixTime))
        let dateFormatter = DateFormatter()
        
        switch dateFormat {
        case .time: dateFormatter.dateFormat = "HH"
        case .sunTime: dateFormatter.dateFormat = "HH MM"
        case .weekday: dateFormatter.dateFormat = "EE"
        case .date: dateFormatter.dateFormat = "d MMMM"
        }
        
        return dateFormatter.string(from: date)
    }
}
