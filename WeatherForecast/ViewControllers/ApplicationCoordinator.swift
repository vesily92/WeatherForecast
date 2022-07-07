//
//  MainCoordinator.swift
//  WeatherForecast
//
//  Created by Василий Пронин on 28.06.2022.
//

import UIKit

class ApplicationCoordinator: Coordinator {
    
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController?
    var data: AnyHashable?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        navigationController.isNavigationBarHidden = true
    }
    func eventOccurred(with type: Event) {
        switch type {
        case .buttonTapped:
            print("Hello")
        case .dailySectionItemTapped:
            let vc = DailyDetailedViewController()
            vc.coordinator = self
            navigationController?.present(vc, animated: true)
        case .dayPickerItemTapped:
            print("")
        }
    }
    func navigate(with data: ForecastData?) {
        let vc = DailyDetailedViewController()
        vc.coordinator = self
        vc.forecastData = data
        navigationController?.present(vc, animated: true)
    }
    
    func start() {
        let vc = MainPageViewController()
        vc.coordinator = self
        navigationController?.setViewControllers([vc], animated: false)
    }
    
}

