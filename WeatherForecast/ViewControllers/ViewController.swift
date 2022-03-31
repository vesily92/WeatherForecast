//
//  ViewController.swift
//  WeatherForecast
//
//  Created by Василий Пронин on 11.02.2022.
//

import UIKit

class ViewController: UIViewController {

    typealias DataSource = UICollectionViewDiffableDataSource<Section, AnyHashable>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable>
    
    private var forecastCollectionView: UICollectionView!
    private var dataSource: DataSource?
    private var forecastData: ForecastData? {
        didSet {
            dataSource?.apply(makeSnapshot(), animatingDifferences: false)
        }
    }
    
    //let alerts = Bundle.main.decode([ForecastData].self, from: "AlertJSON.json")
    //let alerts = Bundle.main.decode([ForecastData]?.self, from: "NilJSON.json")
    //let alerts = Bundle.main.decode([ForecastData].self, from: "HourlyJSON.json")

//    private let sectionInsetY: CGFloat = 4
//    private let sectionInsetX: CGFloat = 16
    private let symbolConfig = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 14))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray4
        
        fetchData()
        setupForecastCollectionView()
        cellRegister()
        createDataSource()
        //makeSnapshot()
    }
    
    private func setupForecastCollectionView() {
        forecastCollectionView = UICollectionView(
            frame: view.bounds,
            collectionViewLayout: createCompositionalLayout()
        )
        forecastCollectionView.backgroundColor = .systemGray4
        forecastCollectionView.showsVerticalScrollIndicator = false
        forecastCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(forecastCollectionView)
        
        NSLayoutConstraint.activate([
            forecastCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            forecastCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            forecastCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            forecastCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        
        print("setupForecastCollectionView")
    }
    
    private func cellRegister() {
        forecastCollectionView.register(
            CurrentWeatherHeader.self,
            forSupplementaryViewOfKind: CurrentWeatherHeader.reuseIdentifier,
            withReuseIdentifier: CurrentWeatherHeader.reuseIdentifier
        )
        forecastCollectionView.register(
            SectionHeader.self,
            forSupplementaryViewOfKind: SectionHeader.reuseIdentifier,
            withReuseIdentifier: SectionHeader.reuseIdentifier
        )
        forecastCollectionView.register(
            AlertCell.self,
            forCellWithReuseIdentifier: AlertCell.reuseIdentifier
        )
        forecastCollectionView.register(
            HourlyForecastCell.self,
            forCellWithReuseIdentifier: HourlyForecastCell.reuseIdentifier
        )
        forecastCollectionView.register(
            DailyForecastCell.self,
            forCellWithReuseIdentifier: DailyForecastCell.reuseIdentifier
        )
        forecastCollectionView.register(
            EmptyCell.self,
            forCellWithReuseIdentifier: EmptyCell.reuseIdentifier
        )
//        forecastCollectionView.register(
//            GridLayoutCell.self,
//            forCellWithReuseIdentifier: GridLayoutCell.reuseIdentifier
//        )
        
        print("cellRegister")
    }

    private func configure<T: SelfConfiguringCell>(_ cellType: T.Type, with model: AnyHashable, for indexPath: IndexPath) -> T {
        guard let cell = forecastCollectionView.dequeueReusableCell(
            withReuseIdentifier: cellType.reuseIdentifier,
            for: indexPath
        ) as? T else {
            fatalError("Unable to dequeue \(cellType)")
        }
        
        cell.configure(with: model)
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
                print("Empty section created")
                return self.createEmptySection(using: section)
            case .hourly:
                print("Hourly section created")
                return self.createHourlySection(using: section)
            case .daily:
                print("Daily section created")
                return self.createDailySection(using: section, and: layoutEnvironment)
//            case .grid:
//                return self.createGridSection(using: section)
            }
        }
        
        let currentWeatherHeader = createGlobalHeader(
            withKind: CurrentWeatherHeader.reuseIdentifier
        )
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.boundarySupplementaryItems = [currentWeatherHeader]

        layout.configuration = config
       
        layout.register(
            BackgroundSupplementaryView.self,
            forDecorationViewOfKind: BackgroundSupplementaryView.reuseIdentifier
        )
        print("ceateCompositionalLayout")
        return layout
    }

    private func fetchData() {
        NetworkManager.shared.fetchForecastData { forecastData in
            self.forecastData = forecastData
        }
    }
}

// - MARK: DataSource

extension ViewController {
    
    private func createDataSource() {
        dataSource = DataSource(collectionView: forecastCollectionView, cellProvider: { collectionView, indexPath, forecast in
            guard let section = Section(rawValue: indexPath.section) else {
                fatalError("Unknown section kind")
            }
            
            switch section {
            case .alert:
                if let forecastData = self.forecastData {
                    if forecastData.alerts != nil {
                        print("Alert cell configured")
                        return self.configure(AlertCell.self, with: forecast, for: indexPath)
                    }
                }
                print("Empty cell configured")
                return self.configure(EmptyCell.self, with: forecast, for: indexPath)
            case .hourly:
                print("Hourly cell configured")
                return self.configure(HourlyForecastCell.self, with: forecast, for: indexPath)
            case .daily:
                print("Daily cell configured")
                return self.configure(DailyForecastCell.self, with: forecast, for: indexPath)
//            case .grid:
//                return self.configure(GridLayoutCell.self, with: forecast, for: indexPath)
            }
        })
        
        dataSource?.supplementaryViewProvider = { weatherCollectionView, kind, indexPath in
            switch kind {
            case CurrentWeatherHeader.reuseIdentifier:
                guard let currentWeatherHeader = weatherCollectionView.dequeueReusableSupplementaryView(ofKind: CurrentWeatherHeader.reuseIdentifier, withReuseIdentifier: CurrentWeatherHeader.reuseIdentifier, for: indexPath) as? CurrentWeatherHeader else {
                    fatalError("Unknown header kind")
                }
                NetworkManager.shared.fetchCurrentData { current in
                    currentWeatherHeader.configure(with: current)
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
                case .alert:
                    return nil
                case .hourly:
                    sectionHeader.symbolView.image = UIImage(
                        systemName: section.headerIcon,
                        withConfiguration: self.symbolConfig)
                    sectionHeader.titleLabel.text = section.headerTitle.uppercased()
                case .daily:
                    sectionHeader.symbolView.image = UIImage(
                        systemName: section.headerIcon,
                        withConfiguration: self.symbolConfig)
                    sectionHeader.titleLabel.text = section.headerTitle.uppercased()
//                case .grid:
//                    return nil
                }
                return sectionHeader
            }
        }
        //dataSource?.apply(makeSnapshot(), animatingDifferences: false)
        print("createDataSource")
    }
    
    private func makeSnapshot() -> NSDiffableDataSourceSnapshot<Section, AnyHashable> {
        var snapshot = Snapshot()
        
//        if let forecastData = forecastData {
//            if forecastData.alerts != nil {
//                let forecasts = Array(repeating: forecastData, count: 1)
//                print("Alert SNAPSHOT")
//                snapshot.appendSections([.alert, .hourly, .daily])
//                snapshot.appendItems(forecasts, toSection: .alert)
//                snapshot.appendItems(forecastData.hourly, toSection: .hourly)
//                snapshot.appendItems(forecastData.daily, toSection: .daily)
//            } else {
//                print("NO Alert SNAPSHOT")
//                snapshot.appendSections([.hourly, .daily])
//                snapshot.appendItems(forecastData.hourly, toSection: .hourly)
//                snapshot.appendItems(forecastData.daily, toSection: .daily)
//            }
//        }
        if let forecastData = forecastData {
            let forecasts = Array(repeating: forecastData, count: 1)
            
            snapshot.appendSections([.alert, .hourly, .daily])
            snapshot.appendItems(forecasts, toSection: .alert)
            snapshot.appendItems(forecastData.hourly, toSection: .hourly)
            snapshot.appendItems(forecastData.daily, toSection: .daily)
        }
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
            heightDimension: .estimated(100)
        )
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize,
            subitems: [item]
        )
        let section = NSCollectionLayoutSection(group: group)
        
        let backgroundView = createBackgroundView()
        section.decorationItems = [backgroundView]
        
        return section
    }
    
    private func createHourlySection(using: Section) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .estimated(60),
            heightDimension: .estimated(110)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        
        let backgroundView = createBackgroundView()
        section.decorationItems = [backgroundView]
        
        let sectionHeader = createHeader()
        section.boundarySupplementaryItems = [sectionHeader]
        section.supplementariesFollowContentInsets = false
//        section.visibleItemsInvalidationHandler = { (items, offset, environment) in
//            print(offset.y)
//        }
        
        return section
    }
    
    private func createDailySection(using: Section, and layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        var configuration = UICollectionLayoutListConfiguration(appearance: .sidebar)
        configuration.separatorConfiguration.bottomSeparatorInsets.leading = 0
        configuration.separatorConfiguration.topSeparatorVisibility = .visible
        configuration.separatorConfiguration.color = .systemGray4
        configuration.backgroundColor = .clear
        
        let section = NSCollectionLayoutSection.list(
            using: configuration,
            layoutEnvironment: layoutEnvironment
        )
        let backgroundView = createBackgroundView()
        section.decorationItems = [backgroundView]
        
        let sectionHeader = createHeader()
        section.boundarySupplementaryItems = [sectionHeader]
        section.supplementariesFollowContentInsets = false
        
        return section
    }
    
    private func createGridSection(using: Section) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.5),
            heightDimension: .fractionalHeight(1.0)
        )
        let itemHeader = createHeader()
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize, supplementaryItems: [itemHeader])
//        item.contentInsets =
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(0.5)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        let section = NSCollectionLayoutSection(group: group)
        let backgroundView = createBackgroundView()
        section.decorationItems = [backgroundView]
        
        return section
    }
    
    private func createHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(32)
        )
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: SectionHeader.reuseIdentifier,
            alignment: .topLeading
        )
        sectionHeader.pinToVisibleBounds = true
        return sectionHeader
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
        let topBottomInset: CGFloat = 8
        let leadingTrailingInset: CGFloat = 0
        let backgroundItem = NSCollectionLayoutDecorationItem.background(
            elementKind: BackgroundSupplementaryView.reuseIdentifier
        )
        backgroundItem.contentInsets = NSDirectionalEdgeInsets(
            top: topBottomInset,
            leading: leadingTrailingInset,
            bottom: topBottomInset,
            trailing: leadingTrailingInset
        )
        return backgroundItem
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

