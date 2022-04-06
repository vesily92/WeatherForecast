//
//  Double + Extension.swift
//  WeatherForecast
//
//  Created by Василий Пронин on 05.04.2022.
//

import Foundation

extension Double {
    
    func roundDecimal(_ scale: Int = 0, mode: NSDecimalNumber.RoundingMode = .plain) -> Double {
        var value = Decimal(self)
        var result = Decimal()
        NSDecimalRound(&result, &value, scale, mode)
        return NSDecimalNumber(decimal: result).doubleValue
    }
    
    func displayPop() -> String? {
        let doubleValue = Double(self)
        
        if doubleValue <= 0.3 {
            return nil
        } else {
            let roundedValue = doubleValue.roundDecimal(1)
            return String(format: "%.0f",roundedValue * 100) + " %"
        }
    }
    
    func displayTemp() -> String {
        String(format: "%.0f", self.roundDecimal()) + "°"
    }
}
