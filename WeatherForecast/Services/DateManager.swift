//
//  DateManager.swift
//  WeatherForecast
//
//  Created by Василий Пронин on 09.02.2022.
//

import UIKit

enum DefineDateFormat: String {
    case time
    case weekDay
    case date
}

class DateManager {
    
    static let shared = DateManager()
    
    private init() {}
    
    func defineDate(withUnixTime unixTime: Int, andDateFormat dateFormat: DefineDateFormat) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(unixTime))
        let dateFormatter = DateFormatter()
        
        switch dateFormat {
        case .time: dateFormatter.dateFormat = "HH:mm"
        case .weekDay: dateFormatter.dateFormat = "EEEE"
        case .date: dateFormatter.dateFormat = "d MMMM"
        }
        
        return dateFormatter.string(from: date)
    }
}
