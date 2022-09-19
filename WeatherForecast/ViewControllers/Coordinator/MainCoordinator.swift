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

class ApplicationCoordinator: Coordinator {

    private var data: AnyHashable?
    private var forecastData: [ForecastData]? {
        didSet { updateInterfaces() }
        
    }
    private weak var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    

    func navigate(with data: ForecastData?, by index: Int) {
        let vc = DetailedDailyViewController()
        vc.coordinator = self
        vc.forecastData = data
//        vc.currentIndex = index
        navigationController?.present(vc, animated: true)
    }
    
    func search(with data: [ForecastData]) {
        let vc = SearchViewController()
        vc.coordinator = self
        vc.forecastData = data
        let navController = UINavigationController(rootViewController: vc)
        navController.modalPresentationStyle = .fullScreen
        navigationController?.present(navController, animated: true)
    }
    
    func showResult(with data: ForecastData, isNew: Bool) {
        let vc = NewLocationViewController()
        vc.coordinator = self
        vc.forecastData = data
        vc.isNew = isNew

        let navController = UINavigationController(rootViewController: vc)
        getTopMostViewController()?.present(navController, animated: true)

    }
    
    func start() {
        showMainPageScreen()
        
//        let vc = DetailedDailyViewController()
//        vc.coordinator = self
//        navigationController?.setViewControllers([vc], animated: true)
//        let vc = MainPageViewController()
////        let vc = ForecastViewController()
////        vc.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 0)
//        vc.coordinator = self
//        navigationController?.setViewControllers([vc], animated: false)
    }
    
//    func navigateToMainPage(with indexPath: IndexPath) {
//        let vc = MainPageViewController()
//        vc.coordinator = self
//        navigationController.dismiss(animated: true)
//        DispatchQueue.main.async {
//            vc.collectionView.scrollToItem(at: indexPath, at: .top, animated: false)
//        }
//    }

    func getTopMostViewController() -> UIViewController? {
        var topMostViewController = UIApplication.shared.windows[0].rootViewController
        while let presentedViewController = topMostViewController?.presentedViewController {
            topMostViewController = presentedViewController
        }
        return topMostViewController
    }
    
    private func showMainPageScreen(with indexPath: IndexPath? = nil) {
        let vc = MainPageViewController()
        vc.coordinator = self
        vc.onSearchTapped = { [weak self] forecastData in
            self?.showSearchScreen(with: forecastData)
        }
        navigationController?.pushViewController(vc, animated: true)
    }

    private func showSearchScreen(with forecastData: [ForecastData]) {
        let vc = SearchVC()
        vc.coordinator = self
        vc.forecastData = forecastData
        vc.onForecastDataChanged = { [weak self] forecastData in
            self?.forecastData = forecastData
        }
        let navController = UINavigationController(rootViewController: vc)
        navController.modalPresentationStyle = .fullScreen
        navigationController?.present(navController, animated: true)
    }

    private func updateInterfaces() {
        guard let forecastData = forecastData else { return }
        navigationController?.viewControllers.forEach {
            ($0 as? UpdatableWithForecastData)?.forecastData = forecastData
        }
    }
}

