//
//  Int + Extension.swift
//  WeatherForecast
//
//  Created by Василий Пронин on 21.06.2022.
//

import Foundation

extension Int {
    func displayPressure() -> String {
        let value = Int(self)
        let newValue = Double(value) / 1.333
        
        return String(format: "%.0f", newValue.rounded())
    }
}
