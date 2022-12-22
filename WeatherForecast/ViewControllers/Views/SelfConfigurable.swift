//
//  SelfConfigurable.swift
//  WeatherForecast
//
//  Created by Василий Пронин on 10.02.2022.
//

import Foundation

protocol SelfConfigurable {
    static var reuseIdentifier: String { get }

    func configure(with forecast: AnyHashable, tzOffset offset: Int?)
}
