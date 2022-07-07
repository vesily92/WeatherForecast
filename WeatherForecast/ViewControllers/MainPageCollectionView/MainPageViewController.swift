//
//  MainPageViewController.swift
//  WeatherForecast
//
//  Created by Василий Пронин on 29.06.2022.
//

import UIKit
import CoreLocation

class MainPageViewController: UIViewController {

    private enum MainPageVCSection: Int, CaseIterable {
        case main
    }
    
    private typealias DataSource = UICollectionViewDiffableDataSource<MainPageVCSection, AnyHashable>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<MainPageVCSection, AnyHashable>
    
//    weak var appCoordinator: ApplicationCoordinator?
    var coordinator: Coordinator?
    
    private var collectionView: UICollectionView!
    private var dataSource: DataSource?
    private var currentWeather: CurrentWeather?
    private var forecastData: ForecastData? {
        didSet {
            dataSource?.apply(makeSnapshot(), animatingDifferences: false)
        }
    }
    
    private lazy var locationManager: CLLocationManager = {
        let lm = CLLocationManager()
        lm.delegate = self
        lm.desiredAccuracy = kCLLocationAccuracyKilometer
        lm.requestWhenInUseAuthorization()
        return lm
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        createDataSouce()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestLocation()
        }
    }
    
//    private func setupNavBar() {
//        let navBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 44))
//        let navItem = UINavigationItem(title: "7-Day Forecast")
//        let dismissButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.close, target: self, action: nil)
//        navItem.rightBarButtonItem = dismissButton
//        navBar.setItems([navItem], animated: false)
//        view.addSubview(navBar)
//    }
    
    private func setupCollectionView() {
        collectionView = UICollectionView(
            frame: view.bounds,
            collectionViewLayout: createCompositionalLayout()
        )
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .darkGray
        collectionView.contentInsetAdjustmentBehavior = .never
        
        view.addSubview(collectionView)
//        navigationController?.isNavigationBarHidden = true

        collectionView.register(
            MainPageCollectionViewCell.self,
            forCellWithReuseIdentifier: MainPageCollectionViewCell.reuseIdentifier
        )
    }
    
    private func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnv in
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
            )
            let group = NSCollectionLayoutGroup.vertical(
                layoutSize: groupSize, subitems: [item]
            )
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .groupPagingCentered
            return section
        }
        return layout
    }
    
    private func createDataSouce() {
        dataSource = DataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, forecast in
            guard let section = MainPageVCSection(rawValue: indexPath.section) else {
                fatalError("Unknown section kind")
            }
            switch section {
            case .main:
                guard let cell = self.collectionView.dequeueReusableCell(
                    withReuseIdentifier: MainPageCollectionViewCell.reuseIdentifier,
                    for: indexPath
                ) as? MainPageCollectionViewCell else {
                    fatalError("Unable to dequeue DailyDetailedCollectionViewCell")
                }
                cell.coordinator = self.coordinator
//                cell.appCoordinator = self.appCoordinator
                guard let forecastData = self.forecastData,
                      let currentWeather = self.currentWeather else { return cell }
                cell.configure(with: forecastData, and: currentWeather)
                return cell
            }
        })
    }
    
    private func makeSnapshot() -> Snapshot {
        var snapshot = Snapshot()
        
        guard let forecastData = forecastData else {
            fatalError()
        }
        let forecasts = Array(repeating: forecastData, count: 1)
        
        snapshot.appendSections(MainPageVCSection.allCases)
        snapshot.appendItems(forecasts, toSection: .main)
        
        return snapshot
    }
}

extension MainPageViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        
        NetworkManager.shared.fetchOneCallData(withLatitude: latitude, longitude: longitude) { forecastData in
            self.forecastData = forecastData
        }
        
        NetworkManager.shared.fetchCurrentWeatherData(forRequestType: .coordinates(latitude: latitude, longitude: longitude))
        NetworkManager.shared.onCompletion = { currentWeather in
            self.currentWeather = currentWeather
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(String(describing: error))
    }
}
