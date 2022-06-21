//
//  DetailedDailyForecastViewController.swift
//  WeatherForecast
//
//  Created by Василий Пронин on 20.06.2022.
//

import UIKit

class DetailedDailyForecastViewController: UIViewController {
    
    private enum DetailedDailySection: Int, CaseIterable {
//        case dailyTemp
        case detailedInfo
    }
    
    private typealias DataSource = UICollectionViewDiffableDataSource<DetailedDailySection, Daily>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<DetailedDailySection, Daily>
    
    private var collectionView: UICollectionView!
    private var dataSource: DataSource?
    
    private var forecastData: ForecastData? {
        didSet {
            dataSource?.apply(makeSnapshot(), animatingDifferences: false)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionView()
        createDataSource()
        NetworkManager.shared.fetchOneCallData(withLatitude: 59.9311, longitude: 30.3609) { forecastData in
            self.forecastData = forecastData
        }
    }
    
    private func setupCollectionView() {
        collectionView = UICollectionView(
            frame: view.bounds,
            collectionViewLayout: createCompositionalGridLayout()
        )
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .black
        view.addSubview(collectionView)
        
        collectionView.register(
            DetailedDailyTempCell.self,
            forCellWithReuseIdentifier: DetailedDailyTempCell.reuseIdentifier
        )
        collectionView.register(
            DetailedDailyForecastCell.self,
            forCellWithReuseIdentifier: DetailedDailyForecastCell.reuseIdentifier
        )
        collectionView.register(
            DetailedDailyForecastHeader.self,
            forSupplementaryViewOfKind: DetailedDailyForecastHeader.reuseIdentifier,
            withReuseIdentifier: DetailedDailyForecastHeader.reuseIdentifier
        )
    }
    
    private func createCompositionalGridLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            guard let section = DetailedDailySection(rawValue: sectionIndex) else {
                fatalError("Unknown section kind")
            }
            
            switch section {
//            case .dailyTemp:
//                return self.createTempSection(using: section)
            case .detailedInfo:
                return self.createDetailedInfoSection(using: section)
            }
        }
        
        let detailedDailyForecastHeader = createGlobalHeader()
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.boundarySupplementaryItems = [detailedDailyForecastHeader]
        layout.configuration = config
        
        return layout
    }
    
    private func createTempSection(using: DetailedDailySection) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(150)
        )
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize,
            subitems: [item]
        )
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
    
    private func createDetailedInfoSection(using: DetailedDailySection) -> NSCollectionLayoutSection {
        let fraction: CGFloat = 1/2
        let inset: CGFloat = 8
        
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(fraction),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalWidth(fraction)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
//        group.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)
        return section
    }
    
    private func createGlobalHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let globalHeaderSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(200)
        )
        let globalHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: globalHeaderSize,
            elementKind: DetailedDailyForecastHeader.reuseIdentifier,
            alignment: .top
        )
        globalHeader.pinToVisibleBounds = true
        
        return globalHeader
    }
    
    private func createDataSource() {
        dataSource = DataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, forecast in
            guard let section = DetailedDailySection(rawValue: indexPath.section) else {
                fatalError("Unknown section kind")
            }
//            guard let offset = self.forecastData?.timezoneOffset else {
//                fatalError("No date")
//            }
            
            switch section {
//            case .dailyTemp:
//                guard let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: DetailedDailyTempCell.reuseIdentifier, for: indexPath) as? DetailedDailyTempCell else {
//                    fatalError("Unable to dequeue cell")
//                }
//                cell.configure(with: forecast)
//                return cell
            case .detailedInfo:
                guard let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: DetailedDailyForecastCell.reuseIdentifier, for: indexPath) as? DetailedDailyForecastCell else {
                    fatalError("Unable to dequeue cell")
                }
                switch indexPath.item {
                case 0: cell.configure(for: .temp, with: forecast)
                case 1: cell.configure(for: .feelsLike, with: forecast)
                case 2: cell.configure(for: .uvi, with: forecast)
                case 3: cell.configure(for: .humidity, with: forecast)
                case 4: cell.configure(for: .pressure, with: forecast)
                case 5: cell.configure(for: .wind, with: forecast)
                default: return cell
                }
                return cell
            }
            
        })
        dataSource?.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard let globalHeader = collectionView.dequeueReusableSupplementaryView(
                ofKind: DetailedDailyForecastHeader.reuseIdentifier,
                withReuseIdentifier: DetailedDailyForecastHeader.reuseIdentifier,
                for: indexPath
            ) as? DetailedDailyForecastHeader else {
                fatalError("Unknown header kind")
            }
            
            return globalHeader
        }
    }
    
    private func makeSnapshot() -> Snapshot {
        var snapshot = Snapshot()
        
        guard let forecastData = forecastData else {
            fatalError()
        }
        
        snapshot.appendSections(DetailedDailySection.allCases)
//        snapshot.appendItems(forecastData.daily, toSection: .dailyTemp)
        snapshot.appendItems(forecastData.daily, toSection: .detailedInfo)
        
        return snapshot
    }
}
