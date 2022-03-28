//
//  ViewController.swift
//  WeatherForecast
//
//  Created by Василий Пронин on 11.02.2022.
//

import UIKit

class ViewController: UIViewController {

//    enum Section: Int, CaseIterable {
//        case hourly
//        case daily
//    }
    
//    var currentWeather = Bundle.main.decode(Current.Diffable.self, from: "CurrentJSON.json")
//    var currentWeather: Current.Diffable!
//    var hourlyWeather = Bundle.main.decode([Hourly].self, from: "HourlyJSON.json")
//    var dailyWeather = Bundle.main.decode([Daily].self, from: "DailyJSON.json")
    
    var forecastData: ForecastData?
    var hourlyWeather: [Hourly] = []
    var dailyWeather: [Daily] = []
    
    var dataSource: UICollectionViewDiffableDataSource<Section, AnyHashable>?
    
    var forecastCollectionView: UICollectionView!
    
    private let sectionInsetY: CGFloat = 4
    private let sectionInsetX: CGFloat = 16
    private let symbolConfig = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 14))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray4

        setupForecastCollectionView()
        cellRegister()
        createDataSource()
        makeSnapshot()
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
            forecastCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
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
            HourlyForecastCell.self,
            forCellWithReuseIdentifier: HourlyForecastCell.reuseIdentifier
        )
        forecastCollectionView.register(
            DailyForecastCell.self,
            forCellWithReuseIdentifier: DailyForecastCell.reuseIdentifier
        )
        
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
            case .hourly:
                return self.createHourlySection(using: section)
            default:
                return self.createDailyListSection(using: section, and: layoutEnvironment)
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
    
    private func fetchData(with type: Section) {
        switch type {
        case .hourly:
            NetworkManager.shared.fetchData(.hourly) { hourly in
                guard let hourlyData = hourly as? [Hourly] else { return }
                self.hourlyWeather = hourlyData
            }
        case .daily:
            NetworkManager.shared.fetchData(.daily) { daily in
                guard let dailyData = daily as? [Daily] else { return }
                self.dailyWeather = dailyData
            }
        }
    }
}

// - MARK: DataSource

extension ViewController {
    
    private func createDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, AnyHashable>(collectionView: forecastCollectionView, cellProvider: { collectionView, indexPath, forecast in
            guard let section = Section(rawValue: indexPath.section) else {
                fatalError("Unknown section kind")
            }
            
            switch section {
            case .hourly:
                return self.configure(HourlyForecastCell.self, with: forecast, for: indexPath)
            case .daily:
                return self.configure(DailyForecastCell.self, with: forecast, for: indexPath)
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
                }
                return sectionHeader
            }
        }
        print("createDataSource")
    }
    
    private func makeSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section,AnyHashable>()
        fetchData(with: .hourly)
        fetchData(with: .daily)
        
        snapshot.appendSections([.hourly, .daily])
        snapshot.appendItems(hourlyWeather, toSection: .hourly)
        snapshot.appendItems(dailyWeather, toSection: .daily)
        dataSource?.apply(snapshot, animatingDifferences: true)
        
        print("makeSnapshot")
    }
}

// - MARK: Sections
extension ViewController {
    private func createHourlySection(using: Section) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .estimated(65),
            heightDimension: .estimated(120)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: sectionInsetX,
            bottom: sectionInsetY,
            trailing: sectionInsetX
        )
        let backgroundView = createBackgroundView()
        section.decorationItems = [backgroundView]
        
        let sectionHeader = createSectionHeader()
        section.boundarySupplementaryItems = [sectionHeader]
        section.supplementariesFollowContentInsets = false
//        section.visibleItemsInvalidationHandler = { (items, offset, environment) in
//            print(offset.y)
//        }
        
        return section
    }
    
    private func createDailyListSection(using: Section, and layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
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
        
        let sectionHeader = createSectionHeader()
        section.boundarySupplementaryItems = [sectionHeader]
        section.supplementariesFollowContentInsets = false
        
        return section
    
    }
    
    private func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
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
            widthDimension: .fractionalWidth(1),
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

