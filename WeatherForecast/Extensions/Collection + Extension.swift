//
//  Collection + Extension.swift
//  WeatherForecast
//
//  Created by Василий Пронин on 28.04.2022.
//

import Foundation

extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
