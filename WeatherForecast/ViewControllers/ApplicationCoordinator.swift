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
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        navigationController.isNavigationBarHidden = true
    }
    func eventOccurred(with type: Event) {
        switch type {
        case .buttonTapped:
            print("Hello")
        case .dailySectionItemTapped:
            var vc: UIViewController & Coordinatable = DailyDetailedViewController()
            vc.coordinator = self
            navigationController?.present(vc, animated: true)

        }
    }
    
    
    func start() {
        var vc: UIViewController & Coordinatable = MainPageViewController()
        vc.coordinator = self
        navigationController?.setViewControllers([vc], animated: false)
    }
}

