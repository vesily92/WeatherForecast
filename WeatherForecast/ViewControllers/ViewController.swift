//
//  ViewController.swift
//  WeatherForecast
//
//  Created by Василий Пронин on 11.02.2022.
//

import UIKit

class ViewController: UIViewController {

    enum Section: Int, CaseIterable {
        case current
        case hourly
        case daily
    }
    
    var currentForecasts = Bundle.main.decode([Current].self, from: "CurrentJSON.json")
    var hourlyForecasts = Bundle.main.decode([Hourly].self, from: "HourlyJSON.json")
    var dailyForecasts = Bundle.main.decode([Daily].self, from: "DailyJSON.json")
    
    var dataSource: UICollectionViewDiffableDataSource<Section, AnyHashable>?
    
    var weatherCollectionView: UICollectionView!
    
    private let sectionInsetY: CGFloat = 4
    private let sectionInsetX: CGFloat = 16
    private let symbolConfig = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 14))
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        view.backgroundColor = .systemGray4
        setupCollectionView()
        createDataSource()
        reloadData()
    }
    
//    private func setupNavigationBar() {
//        title = "City Name"
//
//
//        let paragraph = NSMutableParagraphStyle()
//        paragraph.alignment = .center
//
//        let appearance = UINavigationBarAppearance()
//        appearance.configureWithTransparentBackground()
//        appearance.backgroundColor = .black
//        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
//        appearance.backgroundColor = .systemGray4
//        appearance.titleTextAttributes = [.foregroundColor: UIColor.white, .font: UIFont.systemFont(ofSize: 32, weight: .bold)]
//
//        navigationController?.navigationBar.prefersLargeTitles = true
//
//        navigationItem.largeTitleDisplayMode = .always
//
//        navigationItem.standardAppearance = appearance
//        navigationItem.scrollEdgeAppearance = appearance
//        navigationItem.compactAppearance = appearance
//
//        edgesForExtendedLayout = []
//    }
    
    private func setupCollectionView() {
        weatherCollectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionalLayout())
//        weatherCollectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        weatherCollectionView.backgroundColor = .systemGray4
        weatherCollectionView.showsVerticalScrollIndicator = false
        weatherCollectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(weatherCollectionView)
        
        NSLayoutConstraint.activate([
            weatherCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            weatherCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            weatherCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            weatherCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        
        weatherCollectionView.register(
            GlobalHeader.self,
            forSupplementaryViewOfKind: GlobalHeader.reuseIdentifier,
            withReuseIdentifier: GlobalHeader.reuseIdentifier
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
            CurrentWeatherCell.self,
            forCellWithReuseIdentifier: CurrentWeatherCell.reuseIdentifier
        )
        weatherCollectionView.register(
            HourlyForecastCell.self,
            forCellWithReuseIdentifier: HourlyForecastCell.reuseIdentifier
        )
        weatherCollectionView.register(
            DailyForecastCell.self,
            forCellWithReuseIdentifier: DailyForecastCell.reuseIdentifier
        )
    }
    
    private func configure<T: SelfConfiguringCell>(_ cellType: T.Type, with model: AnyHashable, for indexPath: IndexPath) -> T {
        guard let cell = weatherCollectionView.dequeueReusableCell(
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
            case .hourly: return self.createHourlySection(using: section)
            case .daily: return self.createDailyListSection(using: section, and: layoutEnvironment)
            default: return self.createCurrentSection(using: section)
            }
        }
        
        let globalHeaderAndFooter = createGlobalHeader(
            withKind: GlobalHeader.reuseIdentifier,
            andFooterWithKind: GlobalFooter.reuseIdentifier
        )
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.boundarySupplementaryItems = globalHeaderAndFooter
        
        layout.configuration = config
        layout.register(
            BackgroundSupplementaryView.self,
            forDecorationViewOfKind: BackgroundSupplementaryView.reuseIdentifier
        )
        return layout
    }
}

// - MARK: DataSource

extension ViewController {
    
    private func createDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, AnyHashable>(collectionView: weatherCollectionView, cellProvider: { collectionView, indexPath, forecast in
            guard let section = Section(rawValue: indexPath.section) else {
                fatalError("Unknown section kind")
            }

            switch section {
            case .current:
                return self.configure(CurrentWeatherCell.self, with: forecast, for: indexPath)
            case .hourly:
                return self.configure(HourlyForecastCell.self, with: forecast, for: indexPath)
            case .daily:
                return self.configure(DailyForecastCell.self, with: forecast, for: indexPath)
            }
        })
        
        dataSource?.supplementaryViewProvider = { weatherCollectionView, kind, indexPath in
            switch kind {
            case GlobalHeader.reuseIdentifier:
                guard let globalHeader = weatherCollectionView.dequeueReusableSupplementaryView(ofKind: GlobalHeader.reuseIdentifier, withReuseIdentifier: GlobalHeader.reuseIdentifier, for: indexPath) as? GlobalHeader else {
                    return nil
                }
                globalHeader.titleLabel.text = "City Name"
                return globalHeader
                
            case GlobalFooter.reuseIdentifier:
                guard let globalFooter = weatherCollectionView.dequeueReusableSupplementaryView(ofKind: GlobalFooter.reuseIdentifier, withReuseIdentifier: GlobalFooter.reuseIdentifier, for: indexPath) as? GlobalFooter else {
                    return nil
                }
                globalFooter.titleLabel.text = "Footer"
                return globalFooter
                
            default:
                guard let sectionHeader = weatherCollectionView.dequeueReusableSupplementaryView(ofKind: SectionHeader.reuseIdentifier, withReuseIdentifier: SectionHeader.reuseIdentifier, for: indexPath) as? SectionHeader else {
                    return nil
                }
                guard let section = Section(rawValue: indexPath.section) else {
                    return nil
                }
                switch section {
                case .current:
                    return nil
                case .hourly:
                    sectionHeader.symbolView.image = UIImage(systemName: "clock", withConfiguration: self.symbolConfig)
                    sectionHeader.titleLabel.text = "HOURLY FORECAST"
                case .daily:
                    sectionHeader.symbolView.image = UIImage(systemName: "calendar", withConfiguration: self.symbolConfig)
                    sectionHeader.titleLabel.text = "7-DAY FORECAST"
                }
                return sectionHeader
            }
        }
    }
    
    private func reloadData() {
        var snapshot = NSDiffableDataSourceSnapshot<Section,AnyHashable>()
        snapshot.appendSections([.current, .hourly, .daily])
        snapshot.appendItems(currentForecasts, toSection: .current)
        snapshot.appendItems(hourlyForecasts, toSection: .hourly)
        snapshot.appendItems(dailyForecasts, toSection: .daily)
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
}

// - MARK: Sections
extension ViewController {
    
    private func createCurrentSection(using: Section) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(300)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(1)
        )
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize,
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        
        return section
    }
    
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
        
        return section
    }
    
    private func createSunSection(using: Section) -> NSCollectionLayoutSection {
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
        
        return section
    }
    
    private func createDailyListSection(using: Section, and layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        var configuration = UICollectionLayoutListConfiguration(appearance: .sidebar)
        configuration.separatorConfiguration.bottomSeparatorInsets.leading = 0
        configuration.separatorConfiguration.topSeparatorVisibility = .visible
        configuration.separatorConfiguration.color = .systemGray4
        
        let section = NSCollectionLayoutSection.list(
            using: configuration,
            layoutEnvironment: layoutEnvironment
        )
        
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
        
        return section
    
    }
    
    private func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(30)
        )
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: SectionHeader.reuseIdentifier,
            alignment: .topLeading
        )
        sectionHeader.pinToVisibleBounds = true
        
        return sectionHeader
    }
    
    private func createGlobalHeader(withKind headerKind: String, andFooterWithKind footerKind: String? = nil) -> [NSCollectionLayoutBoundarySupplementaryItem] {
        var globalHeaderAndFooter: [NSCollectionLayoutBoundarySupplementaryItem] = []
        
        let globalHeaderFooterSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(100)
        )

        let globalHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: globalHeaderFooterSize,
            elementKind: headerKind,
            alignment: .top
        )
        globalHeader.pinToVisibleBounds = true
        
        globalHeaderAndFooter.append(globalHeader)
        
        if let footerKind = footerKind {
            let globalFooter = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: globalHeaderFooterSize,
                elementKind: footerKind,
                alignment: .bottom
            )
            globalFooter.pinToVisibleBounds = true
            
            globalHeaderAndFooter.append(globalFooter)
        }
        
        return globalHeaderAndFooter
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
