//
//  Coordinator.swift
//  WeatherForecast
//
//  Created by Василий Пронин on 27.06.2022.
//

import UIKit

enum Event {
    case buttonTapped
    case dailySectionItemTapped
}

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController? { get set }
    
    func eventOccurred(with type: Event)
    func start()
}

protocol Coordinatable {
    var coordinator: Coordinator? { get set }
}
