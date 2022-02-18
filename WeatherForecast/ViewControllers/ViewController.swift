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
    
    private let sectionInsetY: CGFloat = 8
    private let sectionInsetX: CGFloat = 16
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        setupNavigationBar()
        setupCollectionView()
        
//        let refreshControl = UIRefreshControl()
//        weatherCollectionView.refreshControl = refreshControl
        
        view.backgroundColor = .systemGray4
        weatherCollectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeader.reuseIdentifier)
        
        weatherCollectionView.register(CurrentWeatherCell.self, forCellWithReuseIdentifier: CurrentWeatherCell.reuseIdentifier)
        weatherCollectionView.register(HourlyForecastCell.self, forCellWithReuseIdentifier: HourlyForecastCell.reuseIdentifier)
        weatherCollectionView.register(DailyForecastCell.self, forCellWithReuseIdentifier: DailyForecastCell.reuseIdentifier)
        
//        NetworkManager.shared.fetchHourly(latitude: 33.44, longitude: -94.04) { result in
//            switch result {
//            case .success(let forecast):
//                self.dailyForecasts.append(forecast)
//            case .failure(let error):
//                print(error)
//            }
//        }

        createDataSource()
        reloadData()
    }
    
    private func setupNavigationBar() {
        title = "City Name"
        
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        
        let appearance = UINavigationBarAppearance()
        
        appearance.configureWithTransparentBackground()
//        appearance.backgroundColor = .black
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        navigationItem.compactAppearance = appearance
        
//        edgesForExtendedLayout = []
    }
    
    private func setupCollectionView() {
        weatherCollectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionalLayout())
        weatherCollectionView.backgroundColor = .systemGray4
        weatherCollectionView.showsVerticalScrollIndicator = false
        
        view.addSubview(weatherCollectionView)
        weatherCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            weatherCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            weatherCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            weatherCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            weatherCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    private func configure<T: SelfConfiguringCell>(_ cellType: T.Type, with model: AnyHashable, for indexPath: IndexPath) -> T {
        guard let cell = weatherCollectionView.dequeueReusableCell(withReuseIdentifier: cellType.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Unable to dequeue \(cellType)")
        }
        
        cell.configure(with: model)
        return cell
    }
    
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
            guard let sectionHeader = weatherCollectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeader.reuseIdentifier, for: indexPath) as? SectionHeader else {
                return nil
            }
            guard let section = Section(rawValue: indexPath.section) else {
                return nil
            }
            
            switch section {
            case .current:
                sectionHeader.title.text = nil
            case .hourly:
                sectionHeader.title.text = "HOURLY FORECAST"
            case .daily:
                sectionHeader.title.text = "7-DAY FORECAST"
            }
            
            return sectionHeader
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
        
        layout.register(BackgroundSupplementaryView.self, forDecorationViewOfKind: BackgroundSupplementaryView.reuseIdentifier)
        return layout
    }
    
    private func createCurrentSection(using: Section) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(300))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(1))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
    
    private func createHourlySection(using: Section) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(65), heightDimension: .estimated(120))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: sectionInsetY, leading: sectionInsetX, bottom: sectionInsetY, trailing: sectionInsetX)
        
        let backgroundView = createBackgroundView()
        section.decorationItems = [backgroundView]
        
        let sectionHeader = createSectionHeader()
        section.boundarySupplementaryItems = [sectionHeader]
        
        return section
    }
    
//    private func createDailySection(using: Section) -> NSCollectionLayoutSection {
//        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
//        let item = NSCollectionLayoutItem(layoutSize: itemSize)
//
//        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(60))
//        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
//
//        let section = NSCollectionLayoutSection(group: group)
//        section.contentInsets = NSDirectionalEdgeInsets(top: sectionInsetY, leading: sectionInsetX, bottom: sectionInsetY, trailing: sectionInsetX)
//
//
//        let backgroundView = createBackgroundView()
//        section.decorationItems = [backgroundView]
//
//        let sectionHeader = createSectionHeader()
//        section.boundarySupplementaryItems = [sectionHeader]
//
//        return section
//    }
    
    private func createDailyListSection(using: Section, and layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        var configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        configuration.separatorConfiguration.bottomSeparatorInsets.leading = 0
        configuration.separatorConfiguration.color = .systemBackground
        
        let section = NSCollectionLayoutSection.list(using: configuration, layoutEnvironment: layoutEnvironment)
        
        section.contentInsets = NSDirectionalEdgeInsets(top: sectionInsetY, leading: sectionInsetX, bottom: sectionInsetY, trailing: sectionInsetX)
        
        let backgroundView = createBackgroundView()
        section.decorationItems = [backgroundView]
        
        let sectionHeader = createSectionHeader()
        section.boundarySupplementaryItems = [sectionHeader]
        
        return section
    
    }
    
    private func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(80))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        return sectionHeader
    }
    
    private func createBackgroundView() -> NSCollectionLayoutDecorationItem {
        
        let topBottomInset: CGFloat = 4
        let leadingTrailingInset: CGFloat = 0
        
        let backgroundItem = NSCollectionLayoutDecorationItem.background(elementKind: BackgroundSupplementaryView.reuseIdentifier)
        backgroundItem.contentInsets = NSDirectionalEdgeInsets(top: topBottomInset, leading: leadingTrailingInset, bottom: topBottomInset, trailing: leadingTrailingInset)
        
        return backgroundItem
    }
    
//    private func createSeparator() -> NSCollectionLayoutSupplementaryItem {
//        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
//        let separator = NSCollectionLayoutSupplementaryItem(layoutSize: itemSize, elementKind: Separator.reuseIdentifier, containerAnchor: NSCollectionLayoutAnchor(edges: [.leading, .top]))
//        return separator
//    }
}
