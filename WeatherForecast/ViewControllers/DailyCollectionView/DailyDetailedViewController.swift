//
//  DailyDetailedViewController.swift
//  WeatherForecast
//
//  Created by Василий Пронин on 29.06.2022.
//

import UIKit

class DailyDetailedViewController: UIViewController {
    
    private enum DailyDetailedVCSection: Int, CaseIterable {
        case dayPicker
        case meteoInfo
    }
    
    private struct CategorisedDailyVCItems: Hashable {
        let details: Daily
        let category: DailyDetailedVCSection
    }
    
    private typealias DataSource = UICollectionViewDiffableDataSource<DailyDetailedVCSection, CategorisedDailyVCItems>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<DailyDetailedVCSection, CategorisedDailyVCItems>
    
//    weak var appCoordinator: ApplicationCoordinator?
    var coordinator: Coordinator?
    private var collectionView: UICollectionView!
    private var dataSource: DataSource?
    var forecastData: ForecastData? {
        didSet {
            dataSource?.apply(makeSnapshot(), animatingDifferences: false)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        NetworkManager.shared.fetchOneCallData(withLatitude: 59.9311, longitude: 30.3609) { forecastData in
            self.forecastData = forecastData
        }
        setupCollectionView()
        createDataSouce()
    }

    private func setupCollectionView() {
        collectionView = UICollectionView(
            frame: view.bounds,
            collectionViewLayout: createCompositionalLayout()
        )
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .darkGray
        collectionView.delegate = self
        collectionView.isScrollEnabled = false
        view.addSubview(collectionView)
        
        collectionView.register(
            DayPickerCell.self,
            forCellWithReuseIdentifier: DayPickerCell.reuseIdentifier
        )
        collectionView.register(
            DailyDetailedCollectionViewCell.self,
            forCellWithReuseIdentifier: DailyDetailedCollectionViewCell.reuseIdentifier
        )
        collectionView.register(
            SectionHeader.self,
            forSupplementaryViewOfKind: SectionHeader.reuseIdentifier,
            withReuseIdentifier: SectionHeader.reuseIdentifier
        )
    }
    
    private func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnv in
            guard let section = DailyDetailedVCSection(rawValue: sectionIndex) else {
                fatalError("Unknown section kind")
            }
            
            switch section {
            case .dayPicker:
                return self.createDayPickerSection(using: section)
            case .meteoInfo:
                return self.createMeteoInfoSection(using: section)
            }
        }
        let header = createGlobalHeader()
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.boundarySupplementaryItems = [header]
        layout.configuration = config
        return layout
    }
    
    private func createDataSouce() {
        dataSource = DataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, forecast in
            guard let section = DailyDetailedVCSection(rawValue: indexPath.section) else {
                fatalError("Unknown section kind")
            }
            switch section {
            case .dayPicker:
                guard let cell = self.collectionView.dequeueReusableCell(
                    withReuseIdentifier: DayPickerCell.reuseIdentifier,
                    for: indexPath
                ) as? DayPickerCell else {
                    fatalError("Unable to dequeue DayPickerCell")
                }
//                cell.isPicked = true
                cell.configure(with: forecast.details)
                return cell
            case .meteoInfo:
                guard let cell = self.collectionView.dequeueReusableCell(
                    withReuseIdentifier: DailyDetailedCollectionViewCell.reuseIdentifier,
                    for: indexPath
                ) as? DailyDetailedCollectionViewCell else {
                    fatalError("Unable to dequeue DailyDetailedCollectionViewCell")
                }
//                cell.appCoordinator = self.appCoordinator
                cell.configure(with: forecast.details)
                return cell
            }
        })
        dataSource?.supplementaryViewProvider = { weatherCollectionView, kind, indexPath in
            guard let sectionHeader = weatherCollectionView.dequeueReusableSupplementaryView(
                ofKind: SectionHeader.reuseIdentifier,
                withReuseIdentifier: SectionHeader.reuseIdentifier,
                for: indexPath
            ) as? SectionHeader else {
                return nil
            }
            sectionHeader.configureForLargeState(with: Section.daily)
            return sectionHeader
        }
    }
    
    private func makeSnapshot() -> Snapshot {
        var snapshot = Snapshot()
        
        guard let forecastData = forecastData else {
            fatalError()
        }

        snapshot.appendSections(DailyDetailedVCSection.allCases)
        forecastData.daily.forEach { daily in
            snapshot.appendItems(
                [CategorisedDailyVCItems(details: daily, category: .dayPicker)],
                toSection: .dayPicker
            )
            snapshot.appendItems(
                [CategorisedDailyVCItems(details: daily, category: .meteoInfo)],
                toSection: .meteoInfo
            )
        }
        
        return snapshot
    }
    
    private func createDayPickerSection(using: DailyDetailedVCSection) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1/6),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalWidth(1/6)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
        return section
    }
    
    private func createMeteoInfoSection(using: DailyDetailedVCSection) -> NSCollectionLayoutSection {
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
    
    private func createGlobalHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let globalHeaderSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(80)
        )
        let globalHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: globalHeaderSize,
            elementKind: SectionHeader.reuseIdentifier,
            alignment: .top
        )
        globalHeader.pinToVisibleBounds = true
        return globalHeader
    }
}

extension DailyDetailedViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let section = DailyDetailedVCSection(rawValue: indexPath.section) else { return }
        
        if section == .dayPicker {
            //
        }
    }
    
    
}
