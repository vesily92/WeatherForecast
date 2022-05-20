//
//  ViewController.swift
//  WeatherForecast
//
//  Created by Василий Пронин on 11.02.2022.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {

    typealias DataSource = UICollectionViewDiffableDataSource<Section, AnyHashable>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable>
    
    private var weatherCollectionView: UICollectionView!
    
    private var dataSource: DataSource?
    private var forecastData: ForecastData? {
        didSet {
            print("forecast data fetched")
            print(forecastData?.alerts)
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
    
    let alertsForHeader = Bundle.main.decode(ForecastData.self, from: "AlertJSON.json")
    let alertsForSection = Bundle.main.decode([Alert].self, from: "NilJSON.json")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
//        fetchData()
        
        setupCollectionView()
        createDataSource()
        cellRegister()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestLocation()
        }
    }
    
    private func setupCollectionView() {
        weatherCollectionView = UICollectionView(
            frame: view.bounds,
            collectionViewLayout: createCompositionalLayout()
        )
        weatherCollectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        weatherCollectionView.backgroundColor = .clear
        weatherCollectionView.showsVerticalScrollIndicator = false
        view.addSubview(weatherCollectionView)
    }
    
    private func cellRegister() {
        weatherCollectionView.register(
            CurrentWeatherHeader.self,
            forSupplementaryViewOfKind: CurrentWeatherHeader.reuseIdentifier,
            withReuseIdentifier: CurrentWeatherHeader.reuseIdentifier
        )
        weatherCollectionView.register(
            SectionHeader.self,
            forSupplementaryViewOfKind: SectionHeader.reuseIdentifier,
            withReuseIdentifier: SectionHeader.reuseIdentifier
        )
        weatherCollectionView.register(
            AlertCell.self,
            forCellWithReuseIdentifier: AlertCell.reuseIdentifier
        )
        weatherCollectionView.register(
            HourlyCollectionViewCell.self,
            forCellWithReuseIdentifier: HourlyCollectionViewCell.reuseIdentifier
        )
        weatherCollectionView.register(
            DailyForecastCell.self,
            forCellWithReuseIdentifier: DailyForecastCell.reuseIdentifier
        )
        weatherCollectionView.register(
            EmptyCell.self,
            forCellWithReuseIdentifier: EmptyCell.reuseIdentifier
        )
    }

    private func configure<T: SelfConfiguringCell>(_ cellType: T.Type, with model: AnyHashable, andTimeZoneOffset offset: Int, for indexPath: IndexPath) -> T {
        guard let cell = weatherCollectionView.dequeueReusableCell(
            withReuseIdentifier: cellType.reuseIdentifier,
            for: indexPath
        ) as? T else {
            fatalError("Unable to dequeue \(cellType)")
        }
        
        cell.configure(with: model, andTimezoneOffset: offset)
        return cell
    }
    
    private func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            guard let section = Section(rawValue: sectionIndex) else {
                fatalError("Unknown section kind")
            }

            switch section {
            case .alert:
//                mockup:
//                if self.alertsForSection != nil {
//                    return self.createAlertSection(using: section)
//                }
                if let forecastData = self.forecastData {
                    if forecastData.alerts != nil {
                        print("Alert section created")
                        return self.createAlertSection(using: section)
                    }
                }
                return self.createEmptySection(using: section)
            case .hourlyCollection:
                return self.createHourlyCollectionSection(using: section)
            case .daily:
                return self.createDailySection(using: section, and: layoutEnvironment)
            }
        }
        let currentWeatherHeader = createGlobalHeader(
            withKind: CurrentWeatherHeader.reuseIdentifier
        )

        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.boundarySupplementaryItems = [currentWeatherHeader]
        
        config.interSectionSpacing = 20
        layout.configuration = config
        layout.register(
            BackgroundSupplementaryView.self,
            forDecorationViewOfKind: BackgroundSupplementaryView.reuseIdentifier
        )
        return layout
    }

//    private func fetchData() {
////        NetworkManager.shared.fetchForecastData { forecastData in
////            self.forecastData = forecastData
////        }
//        NetworkManager.shared.onCompletion = { [weak self] currentWeather in
//            guard let self = self else { return }
//            self.currentWeather = currentWeather
//        }
//    }
}

// - MARK: DataSource

extension ViewController {
    
    private func createDataSource() {
        print("datasource")
        dataSource = DataSource(collectionView: weatherCollectionView, cellProvider: { collectionView, indexPath, forecast in
            guard let section = Section(rawValue: indexPath.section) else {
                fatalError("Unknown section kind")
            }
            guard let offset = self.forecastData?.timezoneOffset else {
                fatalError()
            }
            
            switch section {
            case .alert:
//            mockup:
//                if self.alertsForSection != nil {
//                    return self.configure(AlertCell.self, with: forecast, andTimeZoneOffset: offset, for: indexPath)
//                }
                if let forecastData = self.forecastData {
                    if forecastData.alerts != nil {
                        print("Alert cell configured")
                        return self.configure(AlertCell.self, with: forecast, andTimeZoneOffset: offset, for: indexPath)
                    }
                }
                return self.configure(EmptyCell.self, with: forecast, andTimeZoneOffset: offset, for: indexPath)
            case .hourlyCollection:
                return self.configure(HourlyCollectionViewCell.self, with: forecast, andTimeZoneOffset: offset, for: indexPath)
            case .daily:
                return self.configure(DailyForecastCell.self, with: forecast, andTimeZoneOffset: offset, for: indexPath)
            }
        })
        
        dataSource?.supplementaryViewProvider = { weatherCollectionView, kind, indexPath in
            switch kind {
            case CurrentWeatherHeader.reuseIdentifier:
                guard let currentWeatherHeader = weatherCollectionView.dequeueReusableSupplementaryView(ofKind: CurrentWeatherHeader.reuseIdentifier, withReuseIdentifier: CurrentWeatherHeader.reuseIdentifier, for: indexPath) as? CurrentWeatherHeader else {
                    fatalError("Unknown header kind")
                }
                print("supplementaryViewProvider")
                
//                if let current = self.forecastData?.current {
//                    currentWeatherHeader.configure(with: current)
//                }
                
                NetworkManager.shared.onCompletion = { currentWeather in
                    currentWeatherHeader.configure(with: currentWeather)
                    print("fetch")
                }
                
                return currentWeatherHeader

            default:
                guard let sectionHeader = weatherCollectionView.dequeueReusableSupplementaryView(
                    ofKind: SectionHeader.reuseIdentifier,
                    withReuseIdentifier: SectionHeader.reuseIdentifier,
                    for: indexPath
                ) as? SectionHeader else {
                    return nil
                }
                guard let section = Section(rawValue: indexPath.section) else {
                    return nil
                }
                
                switch section {
//                case .current: return nil
                case .alert:
//                mockup:
                    if let alertsForHeader = self.alertsForHeader {
                        sectionHeader.configureForAlertSection(with: alertsForHeader)
                    }
//                    if let forecastData = self.forecastData {
//                        if forecastData.alerts != nil {
//                            print("Section Header For Alert Section Created")
//                            sectionHeader.configureForAlertSection(with: forecastData)
//                        }
//                    }
                    sectionHeader.configure(with: section)
                case .hourlyCollection:
                    sectionHeader.configure(with: section)
                case .daily:
                    sectionHeader.configure(with: section)
                }
                return sectionHeader
            }
        }
    }
    
    private func makeSnapshot() -> NSDiffableDataSourceSnapshot<Section, AnyHashable> {
        var snapshot = Snapshot()
//        mockup
        
//        guard let forecastData = forecastData,
//              let alert = alertsForSection?.first else {
//                  fatalError()
//              }
//        let forecasts = Array(repeating: forecastData, count: 1)
//        let alerts = Array(repeating: alert, count: 1)
//        snapshot.appendSections(Section.allCases)
//        snapshot.appendItems(alerts, toSection: .alert)
//        print("alert")
//        snapshot.appendItems(forecasts, toSection: .hourlyCollection)
//        print("hourly")
//        snapshot.appendItems(forecastData.daily, toSection: .daily)
//        print("daily")
        
        guard let forecastData = forecastData else {
            fatalError()
        }
        
        let forecasts = Array(repeating: forecastData, count: 1)
        
        if let alert = forecastData.alerts?.first {
            let alerts = Array(repeating: alert, count: 1)
            snapshot.appendSections(Section.allCases)
            snapshot.appendItems(alerts, toSection: .alert)
            print("alert")
            snapshot.appendItems(forecasts, toSection: .hourlyCollection)
            print("hourly")
            snapshot.appendItems(forecastData.daily, toSection: .daily)
            print("daily")
        } else {
            snapshot.appendSections([.hourlyCollection, .daily])
            snapshot.appendItems(forecasts, toSection: .hourlyCollection)
            print("hourly")
            snapshot.appendItems(forecastData.daily, toSection: .daily)
            print("daily")
        }
        
        
//        if let forecastData = forecastData {
//            if let alert = alertsForSection?.first {
////                let current = Array(repeating: forecastData.current, count: 1)
//                let alerts = Array(repeating: alert, count: 1)
//                snapshot.appendSections(Section.allCases)
////                print("snapshot sections")
////                snapshot.appendItems(current, toSection: .current)
//                snapshot.appendItems(alerts, toSection: .alert)
////                print("snapshot alert items")
//                snapshot.appendItems(forecastData.hourly, toSection: .hourly)
////                print("snapshot hourly items")
//                snapshot.appendItems(forecastData.daily, toSection: .daily)
////                print("snapshot daily items")
//            }
//        }
//        if let forecastData = forecastData {
//            if let alerts = forecastData.alerts {
//                snapshot.appendSections(Section.allCases)
//                print("snapshot sections")
//                snapshot.appendItems(alerts, toSection: .alert)
//                print("snapshot alert items")
//                snapshot.appendItems(forecastData.hourly, toSection: .hourly)
//                print("snapshot hourly items")
//                snapshot.appendItems(forecastData.daily, toSection: .daily)
//                print("snapshot daily items")
//            } else {
//                snapshot.appendSections(Section.allCases)
//                print("snapshot sections")
//                snapshot.appendItems(forecastData.hourly, toSection: .hourly)
//                print("snapshot hourly items")
//                snapshot.appendItems(forecastData.daily, toSection: .daily)
//                print("snapshot daily items")
//            }
//        }
        return snapshot
    }
}

// - MARK: Sections
extension ViewController {
    private func createEmptySection(using: Section) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .absolute(0.1),
            heightDimension: .absolute(0.1)
            )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .estimated(0.1),
            heightDimension: .estimated(0.1)
        )
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize,
            subitems: [item]
        )
        let section = NSCollectionLayoutSection(group: group)

        return section
    }
    
    private func createAlertSection(using: Section) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(110)
        )
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize,
            subitem: item,
            count: 1
        )
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)

        let sectionHeader = createHeader()
        section.boundarySupplementaryItems = [sectionHeader]

        return section
    }
    
    
    private func createAlertSection(using: Section, and layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        var configuration = UICollectionLayoutListConfiguration(appearance: .sidebar)
        configuration.separatorConfiguration.color = .systemGray4

        let section = NSCollectionLayoutSection.list(
            using: configuration,
            layoutEnvironment: layoutEnvironment
        )
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)

        let backgroundView = createBackgroundView()
        section.decorationItems = [backgroundView]


        let sectionHeader = createHeader()
        section.boundarySupplementaryItems = [sectionHeader]
//        section.supplementariesFollowContentInsets = false
        
//        section.visibleItemsInvalidationHandler = { items, offset, environment in
////            print("Alert Section offset \(offset.y)")
//
////            guard let globalHeader = self.weatherCollectionView.visibleSupplementaryViews(ofKind: CurrentWeatherHeader.reuseIdentifier).first as? CurrentWeatherHeader else { return }
//            items.forEach { item in
//
//                guard let cell = self.weatherCollectionView.cellForItem(at: item.indexPath) as? AlertCell else { return }
//
//                guard let header = self.weatherCollectionView.supplementaryView(forElementKind: SectionHeader.reuseIdentifier, at: item.indexPath) as? SectionHeader else { return }
//
//
//                let sectionPosition = header.frame.origin.y
//                let frameMAX = item.frame.maxY
//                let frameMIN = item.frame.minY
//
//
//                let boundsMIN = header.bounds.minY
//                let boundsMAX = header.bounds.maxY
//
//                let headerBounds = header.bounds.size.height
//                let itemBounds = item.bounds.size.height
//                let distance = itemBounds - headerBounds
//
//                print("-------------------------")
//                print("alert: \(sectionPosition)")
//                print("offset: \(offset.y)")
//                print("-------------------------")
//                print("FRAME MIN: \(frameMIN)")
//                print("FRAME MAX: \(frameMAX)")
//                print("-------------------------")
//                print("BOUNDS MIN: \(boundsMIN)")
//                print("BOUNDS MAX: \(boundsMAX)")
//                print("BOUNDS HEIGHT: \(itemBounds)")
//                print("-------------------------")
////                print("DDISTANCE: \(distance)")
//                print("-------------------------")
////                print("custom offset: \(offsetY)")
//
//
//
////                if sectionPosition <= 180 {
////                    globalHeader.setAlphaValue(with: sectionPosition / 180)
////                }
//                let alphaOffset = (offset.y + self.weatherCollectionView.contentInset.top) / 100
//
//                let alpha = 1 - (alphaOffset - (sectionPosition / 100))
//
//
//                print(alpha)
//
//                if sectionPosition >= distance {
//                    header.setAlphaValue(with: alpha)
//
//
////                    cell.transform = CGAffineTransform(scaleX: 1, y: 0.5)
////
////                    item.transform = CGAffineTransform(scaleX: 1, y: 0.1)
//                    header.layer.zPosition = 0
//                    item.isHidden = true
//                    cell.isHidden = true
//                } else {
////                    header.transform = CGAffineTransform(translationX: 0, y: 0)
//                    header.setAlphaValue(with: 1)
//
//                    cell.isHidden = false
//                    item.isHidden = false
//                    header.isHidden = false
//                }
//            }
//        }

        return section
    }
    
    private func createHourlyCollectionSection(using: Section) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(120.0)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        
//        ????????????????????????????????????????????????????
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
//        ????????????????????????????????????????????????????
        section.orthogonalScrollingBehavior = .continuous
        
        let backgroundView = createBackgroundView()
        section.decorationItems = [backgroundView]
        
        let sectionHeader = createHeader()
        section.boundarySupplementaryItems = [sectionHeader]

        return section
    }
    
    private func createDailySection(using: Section, and layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        var configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        configuration.separatorConfiguration.bottomSeparatorInsets.leading = 16
        configuration.separatorConfiguration.color = .white
        configuration.backgroundColor = .clear
        
        let section = NSCollectionLayoutSection.list(
            using: configuration,
            layoutEnvironment: layoutEnvironment
        )
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 16, bottom: 10, trailing: 16)
        
        let sectionHeader = createHeader()
        section.boundarySupplementaryItems = [sectionHeader]
//        section.supplementariesFollowContentInsets = false
        
        let backgroundView = createBackgroundView()
        section.decorationItems = [backgroundView]
        
        return section
    }
    
    private func createHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(50)
        )
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: SectionHeader.reuseIdentifier,
            alignment: .topLeading
        )

        return sectionHeader
    }
    
    private func createFooter() -> NSCollectionLayoutBoundarySupplementaryItem {
        let footerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(50)
        )
        let sectionFooter = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: footerSize,
            elementKind: SectionFooter.reuseIdentifier,
            alignment: .bottom
        )
        return sectionFooter
    }
    
    private func createGlobalHeader(withKind headerKind: String) -> NSCollectionLayoutBoundarySupplementaryItem {
        let globalHeaderSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(250)
        )
        let globalHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: globalHeaderSize,
            elementKind: headerKind,
            alignment: .top
        )
        globalHeader.pinToVisibleBounds = true
        
        return globalHeader
    }

    private func createBackgroundView() -> NSCollectionLayoutDecorationItem {
        let topInset: CGFloat = 50
        let sideInset: CGFloat = 16
        
        let backgroundItem = NSCollectionLayoutDecorationItem.background(
            elementKind: BackgroundSupplementaryView.reuseIdentifier
        )

        backgroundItem.contentInsets = NSDirectionalEdgeInsets(
            top: topInset,
            leading: sideInset,
            bottom: 0,
            trailing: sideInset
        )
        return backgroundItem
    }
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        
        NetworkManager.shared.fetchOneCallData(withLatitude: latitude, longitude: longitude) { forecastData in
            self.forecastData = forecastData
        }
        
        NetworkManager.shared.fetchCurrentWeatherData(forRequestType: .coordinates(latitude: latitude, longitude: longitude))
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(String(describing: error))
    }
}

import SwiftUI

struct ViewControllerProvider: PreviewProvider {
    static var previews: some View {
        Group {
            ContainerView().edgesIgnoringSafeArea(.all)
        }
    }

    struct ContainerView: UIViewControllerRepresentable {
        let viewController = ViewController()

        func makeUIViewController(context: UIViewControllerRepresentableContext<ViewControllerProvider.ContainerView>) -> ViewController {
            return viewController
        }
        func updateUIViewController(_ uiViewController: ViewControllerProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<ViewControllerProvider.ContainerView>) {
        }
    }
}

