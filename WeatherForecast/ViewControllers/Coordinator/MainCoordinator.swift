//
//  MainCoordinator.swift
//  WeatherForecast
//
//  Created by Василий Пронин on 28.06.2022.
//

import UIKit

protocol UpdatableWithForecastData: AnyObject {
    var forecastData: [ForecastData] { get set }
}

class MainCoordinator: Coordinator {

    private var forecastData: [ForecastData]? {
        didSet { updateInterfaces() }
    }
    
    private weak var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showMainPageScreen()
    }
    
    private func showMainPageScreen(with indexPath: IndexPath? = nil) {
        let vc = MainPageViewController()
        vc.coordinator = self

        vc.onSearchTapped = { [weak self] forecastData in
            self?.forecastData = forecastData
            self?.showSearchScreen(with: forecastData)
        }

        vc.onCellDidTap = { [weak self] forecast, index in
            self?.showDetailedDailyScreen(with: forecast, and: index)
        }

        navigationController?.pushViewController(vc, animated: true)
    }

    private func showSearchScreen(with forecastData: [ForecastData]) {
        let vc = SearchViewController()
        vc.forecastData = forecastData
        
        vc.onForecastDataChanged = { [weak self] forecastData in
            self?.forecastData = forecastData
        }
        
        vc.onSearchResultTapped = { [weak self] forecast, geocodingData, isNew in
            self?.showNewLocationVC(
                withForecast: forecast,
                andGeocodingData: geocodingData,
                isNew: isNew
            )
        }
        
        let navController = UINavigationController(rootViewController: vc)
        navController.modalPresentationStyle = .fullScreen
        navigationController?.present(navController, animated: true)
    }
    
    private func showNewLocationVC(withForecast forecast: ForecastData, andGeocodingData data: GeocodingData, isNew: Bool) {
        let vc = MainPageNewLocationViewController()
        vc.forecastData = forecast
        vc.geocodingData = data
        vc.isNew = isNew

        let navController = UINavigationController(rootViewController: vc)
        getTopMostViewController()?.present(navController, animated: true)
    }
    
    private func showDetailedDailyScreen(with data: ForecastData, and index: Int) {
        let vc = DetailedDailyViewController()
        vc.forecastData = data
        vc.index = index
        
        let navController = UINavigationController(rootViewController: vc)
        navigationController?.present(navController, animated: true)
    }

    private func updateInterfaces() {
        guard let forecastData = forecastData else { return }
        navigationController?.viewControllers.forEach {
            ($0 as? UpdatableWithForecastData)?.forecastData = forecastData
        }
    }
    
    private func getTopMostViewController() -> UIViewController? {
        var topMostViewController = UIApplication.shared.windows[0].rootViewController
        while let presentedViewController = topMostViewController?.presentedViewController {
            topMostViewController = presentedViewController
        }
        return topMostViewController
    }
    
    
}

