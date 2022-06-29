//
//  MainPageCollectionViewCell.swift
//  WeatherForecast
//
//  Created by Василий Пронин on 29.06.2022.
//

import UIKit
import CoreLocation

class MainPageCollectionViewCell: UICollectionViewCell, Coordinatable {
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, AnyHashable>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable>
    
    static let reuseIdentifier = "MainPageCollectionViewCell"
    
    var coordinator: Coordinator?
    
    private var weatherCollectionView: UICollectionView!
    private var dataSource: DataSource?
    private var currentWeather: CurrentWeather?
    private var forecastData: ForecastData? {
        didSet {
            dataSource?.apply(makeSnapshot(), animatingDifferences: false)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupCollectionView()
        createDataSource()
        registerCells()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with forecastData: ForecastData, and currentWeather: CurrentWeather) {
        self.forecastData = forecastData
        self.currentWeather = currentWeather
    }
    
    private func setupCollectionView() {
        weatherCollectionView = UICollectionView(
            frame: contentView.bounds,
            collectionViewLayout: createCompositionalLayout()
        )
        weatherCollectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        weatherCollectionView.backgroundColor = .systemGray4
        weatherCollectionView.showsVerticalScrollIndicator = false
        weatherCollectionView.contentInsetAdjustmentBehavior = .never
        weatherCollectionView.delegate = self
        
        contentView.addSubview(weatherCollectionView)
    }
    
    private func registerCells() {
        weatherCollectionView.register(
            EmptyCell.self,
            forCellWithReuseIdentifier: EmptyCell.reuseIdentifier
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
            CurrentWeatherHeader.self,
            forSupplementaryViewOfKind: CurrentWeatherHeader.reuseIdentifier,
            withReuseIdentifier: CurrentWeatherHeader.reuseIdentifier
        )
        weatherCollectionView.register(
            GlobalFooter.self,
            forSupplementaryViewOfKind: GlobalFooter.reuseIdentifier,
            withReuseIdentifier: GlobalFooter.reuseIdentifier
        )
        weatherCollectionView.register(
            SectionHeader.self,
            forSupplementaryViewOfKind: SectionHeader.reuseIdentifier,
            withReuseIdentifier: SectionHeader.reuseIdentifier
        )
        weatherCollectionView.register(
            SectionFooterButton.self,
            forSupplementaryViewOfKind: SectionFooterButton.reuseIdentifier,
            withReuseIdentifier: SectionFooterButton.reuseIdentifier
        )
    }

    private func configure<T: SelfConfiguringCell>(_ cellType: T.Type, with model: AnyHashable, andTimeZone offset: Int, for indexPath: IndexPath) -> T {
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
        let globalFooter = createGlobalFooter(
            withKind: GlobalFooter.reuseIdentifier
        )
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.boundarySupplementaryItems = [currentWeatherHeader, globalFooter]
        config.interSectionSpacing = 20
        layout.configuration = config
        layout.register(
            SectionBackgroundView.self,
            forDecorationViewOfKind: SectionBackgroundView.reuseIdentifier
        )
        return layout
    }
}

// - MARK: DataSource

extension MainPageCollectionViewCell {
    
    private func createDataSource() {
        print("datasource")
        dataSource = DataSource(collectionView: weatherCollectionView, cellProvider: { collectionView, indexPath, forecast in
            guard let section = Section(rawValue: indexPath.section) else {
                fatalError("Unknown section kind")
            }
            guard let offset = self.forecastData?.timezoneOffset else {
                fatalError("No date")
            }
            switch section {
            case .alert:
                if let forecastData = self.forecastData {
                    if forecastData.alerts != nil {
                        print("Alert cell configured")
                        return self.configure(
                            AlertCell.self,
                            with: forecast,
                            andTimeZone: offset,
                            for: indexPath
                        )
                    }
                }
                return self.configure(
                    EmptyCell.self,
                    with: forecast,
                    andTimeZone: offset,
                    for: indexPath
                )
            case .hourlyCollection:
                return self.configure(
                    HourlyCollectionViewCell.self,
                    with: forecast,
                    andTimeZone: offset,
                    for: indexPath
                )
            case .daily:
                return self.configure(
                    DailyForecastCell.self,
                    with: forecast,
                    andTimeZone: offset,
                    for: indexPath
                )
            }
        })
        
        dataSource?.supplementaryViewProvider = { weatherCollectionView, kind, indexPath in
            switch kind {
            case CurrentWeatherHeader.reuseIdentifier:
                guard let currentWeatherHeader = weatherCollectionView.dequeueReusableSupplementaryView(
                    ofKind: CurrentWeatherHeader.reuseIdentifier,
                    withReuseIdentifier: CurrentWeatherHeader.reuseIdentifier,
                    for: indexPath
                ) as? CurrentWeatherHeader else {
                    fatalError("Unknown header kind")
                }
                print("supplementaryViewProvider")

                if let currentWeather = self.currentWeather {
                    currentWeatherHeader.configure(with: currentWeather)
                }
                return currentWeatherHeader

            case GlobalFooter.reuseIdentifier:
                guard let globalFooter = weatherCollectionView.dequeueReusableSupplementaryView(
                    ofKind: GlobalFooter.reuseIdentifier,
                    withReuseIdentifier: GlobalFooter.reuseIdentifier,
                    for: indexPath
                ) as? GlobalFooter else {
                    fatalError("Unknown global footer kind")
                }
                if let currentWeather = self.currentWeather {
                    globalFooter.configure(with: currentWeather)
                }
                return globalFooter
                
            case SectionFooterButton.reuseIdentifier:
                guard let sectionFooterButton = weatherCollectionView.dequeueReusableSupplementaryView(
                    ofKind: SectionFooterButton.reuseIdentifier,
                    withReuseIdentifier: SectionFooterButton.reuseIdentifier,
                    for: indexPath
                ) as? SectionFooterButton else {
                    fatalError("Unknown footer kind")
                }
                return sectionFooterButton
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
                case .alert:
                    if let forecastData = self.forecastData {
                        sectionHeader.configureForAlertSection(with: forecastData)
                    }
                case .hourlyCollection:
                    sectionHeader.configure(with: section)
//                case .hourlyCompositional:
//                    sectionHeader.configure(with: section)
                case .daily:
                    sectionHeader.configure(with: section)
                }
                return sectionHeader
            }
        }
    }
    
    private func makeSnapshot() -> Snapshot {
        var snapshot = Snapshot()

        guard let forecastData = forecastData else {
            fatalError()
        }

        let forecasts = Array(repeating: forecastData, count: 1)

        if let alert = forecastData.alerts?.first {
            let alerts = Array(repeating: alert, count: 1)
            snapshot.appendSections(Section.allCases)
            snapshot.appendItems(alerts, toSection: .alert)
            snapshot.appendItems(forecasts, toSection: .hourlyCollection)
//            snapshot.appendItems(forecasts, toSection: .hourlyCompositional)
            snapshot.appendItems(forecastData.daily, toSection: .daily)
        } else {
            snapshot.appendSections(Section.allCases)
            snapshot.appendItems(forecasts, toSection: .hourlyCollection)
//            snapshot.appendItems(forecasts, toSection: .hourlyCompositional)
            snapshot.appendItems(forecastData.daily, toSection: .daily)
        }
        return snapshot
    }
}

// - MARK: Sections
extension MainPageCollectionViewCell {
    
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
            heightDimension: .estimated(40)
        )
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize,
            subitem: item,
            count: 1
        )
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)

        let sectionHeader = createSectionHeader()
        let sectionFooterButton = createSectionFooterButton()
        section.boundarySupplementaryItems = [sectionHeader, sectionFooterButton]
        
        let backgroundView = createBackgroundView()
        section.decorationItems = [backgroundView]
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
        section.orthogonalScrollingBehavior = .continuous
        
        let backgroundView = createBackgroundView()
        section.decorationItems = [backgroundView]
        
        let sectionHeader = createSectionHeader()
        sectionHeader.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 16,
            bottom: 0,
            trailing: 16
        )
        section.boundarySupplementaryItems = [sectionHeader]
        
        section.visibleItemsInvalidationHandler = { items, offset, _ in
            guard let globalHeader = self.weatherCollectionView.visibleSupplementaryViews(ofKind: CurrentWeatherHeader.reuseIdentifier).first as? CurrentWeatherHeader else { return }
            
            if offset.y < 0 {
                globalHeader.setAlphaForMainLabels(with: 1)
            }
            if offset.y > 50 {
                globalHeader.setAlphaForMainLabels(with: 1 - ((offset.y - 50) / 100))
                globalHeader.reduceZIndex()
            }
            if offset.y > 150 {
                globalHeader.setAlphaForSubheadline(with: 0 + ((offset.y - 150) / 14))
                globalHeader.restoreZIndex()
            } else {
                globalHeader.setAlphaForSubheadline(with: 0 + ((offset.y - 150) / 100))
            }
        }
        return section
    }
    
    private func createDailySection(using: Section, and layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        var configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        configuration.separatorConfiguration.color = .white
        configuration.separatorConfiguration.bottomSeparatorInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 16,
            bottom: 0,
            trailing: 16
        )
        configuration.backgroundColor = .clear
        
        let section = NSCollectionLayoutSection.list(
            using: configuration,
            layoutEnvironment: layoutEnvironment
        )
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
        
        let sectionHeader = createSectionHeader()
        section.boundarySupplementaryItems = [sectionHeader]
        
        let backgroundView = createBackgroundView()
        section.decorationItems = [backgroundView]
        
        return section
    }
    
    private func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(36)
        )
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: SectionHeader.reuseIdentifier,
            alignment: .topLeading
        )
        return sectionHeader
    }
    
    private func createSectionFooterButton() -> NSCollectionLayoutBoundarySupplementaryItem {
        let footerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(20)
        )
        let sectionFooterButton = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: footerSize,
            elementKind: SectionFooterButton.reuseIdentifier,
            alignment: .bottomLeading)
        return sectionFooterButton
    }
    
    private func createGlobalHeader(withKind headerKind: String) -> NSCollectionLayoutBoundarySupplementaryItem {
        let globalHeaderSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(300)
        )
        let globalHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: globalHeaderSize,
            elementKind: headerKind,
            alignment: .top
        )
        globalHeader.pinToVisibleBounds = true
        return globalHeader
    }
    
    private func createGlobalFooter(withKind footerKind: String) -> NSCollectionLayoutBoundarySupplementaryItem {
        let globalFooterSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(200)
        )
        let globalFooter = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: globalFooterSize,
            elementKind: footerKind,
            alignment: .bottom
        )
        return globalFooter
    }

    private func createBackgroundView() -> NSCollectionLayoutDecorationItem {
        let topInset: CGFloat = 0
        let sideInset: CGFloat = 16
        let backgroundItem = NSCollectionLayoutDecorationItem.background(
            elementKind: SectionBackgroundView.reuseIdentifier
        )
        backgroundItem.contentInsets = NSDirectionalEdgeInsets(
            top: topInset,
            leading: sideInset,
            bottom: topInset,
            trailing: sideInset
        )
        return backgroundItem
    }
}


extension MainPageCollectionViewCell: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        coordinator?.eventOccurred(with: .dailySectionItemTapped)
//        guard let section = Section(rawValue: indexPath.section) else {
//            fatalError("Unknown section kind")
//        }
//        if section == .daily {
//            coordinator?.eventOccurred(with: .dailySectionItemTapped)
//        }
        
////
//        switch section {
//        case .alert:
//            <#code#>
//        case .hourlyCollection:
//            <#code#>
//        case .daily:
//            <#code#>
//        }
    }
}
