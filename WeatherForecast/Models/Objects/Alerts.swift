//
//  Alerts.swift
//  WeatherForecast
//
//  Created by Василий Пронин on 23.05.2022.
//

import Foundation

struct Alerts: Codable {
    let senderName: String
    let event: String
    let start: Int
    let end: Int
    let alertDescription: String
    let tags: [String]
    
    init?(model: Alert) {
        senderName = model.senderName
        event = model.event
        start = model.start
        end = model.end
        alertDescription = model.alertDescription
        tags = model.tags
    }
}

extension Alerts: Hashable {
    
    var id: UUID {
        return UUID()
    }
    
    static func == (lhs: Alerts, rhs: Alerts) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(senderName)
        hasher.combine(event)
        hasher.combine(start)
        hasher.combine(end)
        hasher.combine(alertDescription)
        hasher.combine(tags)
    }
}
