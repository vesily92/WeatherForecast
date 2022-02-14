//
//  StartPageViewController.swift
//  WeatherForecast
//
//  Created by Василий Пронин on 10.02.2022.
//

import UIKit
import CoreLocation

//class StartPageViewController: UIViewController {
//    
//    enum Section: Int, CaseIterable {
//        case main
//    }
//
//    var hourlyForecasts: [Current] = []
//
//
//    var weatherCollectionView: UICollectionView!
//    var dataSource: UICollectionViewDiffableDataSource<Section, Current>?
//
//    private lazy var locationManager: CLLocationManager = {
//        let lm = CLLocationManager()
//        lm.delegate = self
//        lm.desiredAccuracy = kCLLocationAccuracyHundredMeters
//        lm.requestWhenInUseAuthorization()
//        return lm
//    }()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        weatherCollectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionalLayout())
//        weatherCollectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        weatherCollectionView.backgroundColor = .systemBackground
//        view.addSubview(weatherCollectionView)
//
////        weatherCollectionView.delegate = self
////        weatherCollectionView.dataSource = self
//
////        NetworkManager.shared.fetchHourly(latitude: 33.44, longitude: -94.04) { result in
////            switch result {
////            case .success(let hourlyForecast):
////                self.hourlyForecasts.append(hourlyForecast)
////            case .failure(let error):
////                print(error)
////            }
////        }
//
//        if CLLocationManager.locationServicesEnabled() {
//            locationManager.requestLocation()
//        }
//
//        createDataSource()
//        reloadData()
//    }
//
//    private func configure<T: SelfConfiguringCell>(_ cellType: T.Type, with hourly: Current, for indexPath: IndexPath) -> T {
//        guard let cell = weatherCollectionView.dequeueReusableCell(withReuseIdentifier: cellType.reuseIdentifier, for: indexPath) as? T else {
//            fatalError("Unable to dequeue \(cellType)")
//        }
//        cell.configure(with: hourly)
//        return cell
//    }
//
//    private func createDataSource() {
//        dataSource = UICollectionViewDiffableDataSource<Section, Current>(collectionView: weatherCollectionView, cellProvider: { collectionView, indexPath, hourly in
//            guard let section = Section(rawValue: indexPath.section) else {
//                fatalError("Unknown section kind")
//            }
//
//            switch section {
//            case .main:
//                return self.configure(HourlyForecastCell.self, with: hourly, for: indexPath)
//            }
//        })
//    }
//
//    private func reloadData() {
//        var snapshot = NSDiffableDataSourceSnapshot<Section,Current>()
//        snapshot.appendSections([.main])
//        snapshot.appendItems(hourlyForecasts, toSection: .main)
//        dataSource?.apply(snapshot, animatingDifferences: true)
//
//
//    }
//
//    private func createCompositionalLayout() -> UICollectionViewLayout {
//        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
//            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(86))
//            let item = NSCollectionLayoutItem(layoutSize: itemSize)
//
//            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(1))
//            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
//
//            let section = NSCollectionLayoutSection(group: group)
//            return section
//        }
//        return layout
//    }
//}
//
////extension StartPageViewController: UICollectionViewDataSource, UICollectionViewDelegate {
////    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
////        return 5
////    }
////
////    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
////        let cell = weatherCollectionView.dequeueReusableCell(withReuseIdentifier: "cellid", for: indexPath)
////        cell.backgroundColor = .systemBlue
////        return cell
////    }
////}
//
//extension StartPageViewController: CLLocationManagerDelegate {
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        guard let location = locations.last else { return }
//        let latitude = location.coordinate.latitude
//        let longitude = location.coordinate.longitude
//
//        NetworkManager.shared.fetchHourly(latitude: latitude, longitude: longitude) { result in
//            switch result {
//            case .success(let hourlyForecast):
//                self.hourlyForecasts.append(hourlyForecast)
//            case .failure(let error):
//                print(error)
//            }
//        }
//    }
//
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        print(error.localizedDescription)
//    }
//}
