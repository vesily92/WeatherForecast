//
//  Coordinator.swift
//  WeatherForecast
//
//  Created by Василий Пронин on 27.06.2022.
//

import UIKit

protocol Coordinator: AnyObject {
    func start()
    func navigate(with data: ForecastData?, by index: Int)
    func search(with data: [ForecastData])
    func showResult(with data: ForecastData, isNew: Bool)
}

