//
//  SelfConfiguringCell.swift
//  WeatherForecast
//
//  Created by Василий Пронин on 10.02.2022.
//

import Foundation

protocol SelfConfiguringCell {
    static var reuseIdentifier: String { get }
    
//    @objc func configure(with: CurrentWeather)
//    @objc func configure(with: HourlyForecast)
//    @objc func configure(with: DailyForecast)
    
    
    func configure(with forecast: AnyHashable)
}
