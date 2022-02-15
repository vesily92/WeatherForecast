//
//  SelfConfiguringCell.swift
//  WeatherForecast
//
//  Created by Василий Пронин on 10.02.2022.
//

import Foundation

protocol SelfConfiguringCell {
    static var reuseIdentifier: String { get }

    func configure(with forecast: AnyHashable)
}
