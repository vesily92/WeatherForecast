//
//  Notification.Name + Extension.swift
//  WeatherForecast
//
//  Created by Василий Пронин on 07.09.2022.
//

import Foundation

extension Notification.Name {
    static var appendData: Notification.Name {
        return .init(rawValue: "AppendData")
    }
    
    static var removeData: Notification.Name {
        return .init(rawValue: "RemoveData")
    }
    
    static var scrollToItem: Notification.Name {
        return .init(rawValue: "ScrollToItem")
    }
    
    static let forecastDidChange = Notification.Name("ForecastDidChange")
    static let forecastDidDelete = Notification.Name("ForecastDidDelete")
    static let forecastDidAppend = Notification.Name("ForecastDidAppend")
}

enum NotificationKeys: String {
    case data
    case indexPath
}
