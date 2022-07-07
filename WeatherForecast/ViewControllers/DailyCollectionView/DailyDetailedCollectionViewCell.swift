//
//  DailyDetailedCollectionViewCell.swift
//  WeatherForecast
//
//  Created by Василий Пронин on 29.06.2022.
//

import UIKit

class DailyDetailedCollectionViewCell: UICollectionViewCell {
    
    private enum DailyDetailedCellSection: Int, CaseIterable {
//        case dayPicker
        case dailyTempInfo
        case uviAndHumidityInfo
        case pressureAndWindInfo
    }
    
    private struct CategorisedDailyCellItems: Hashable {
        let details: Daily
        let category: DailyDetailedCellSection
    }
    
    private typealias DataSource = UICollectionViewDiffableDataSource<DailyDetailedCellSection, CategorisedDailyCellItems>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<DailyDetailedCellSection, CategorisedDailyCellItems>
    
    static let reuseIdentifier = "DailyDetailedCollectionViewCell"
    
//    weak var appCoordinator: ApplicationCoordinator?
    weak var coordinator: Coordinator?

    private var collectionView: UICollectionView!
    private var dataSource: DataSource?
    
    private var dailyData: Daily? {
        didSet {
            dataSource?.apply(makeSnapshot(), animatingDifferences: false)
        }
    }

    private let inset: CGFloat = 16
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupCollectionView()
        createDataSource()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configure(with forecast: AnyHashable) {
        guard let forecast = forecast as? Daily else { return }
        self.dailyData = forecast
    }
    
    private func setupCollectionView() {
        collectionView = UICollectionView(
            frame: contentView.bounds,
            collectionViewLayout: createCompositionalLayout()
        )
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .darkGray
        contentView.addSubview(collectionView)

        collectionView.register(
            DailyTempCell.self,
            forCellWithReuseIdentifier: DailyTempCell.reuseIdentifier
        )
        collectionView.register(
            MeteoInfoCell.self,
            forCellWithReuseIdentifier: MeteoInfoCell.reuseIdentifier
        )
    }
    
    private func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            guard let section = DailyDetailedCellSection(rawValue: sectionIndex) else {
                fatalError("Unknown section kind")
            }
            
            switch section {
            case .dailyTempInfo:
                return self.createDailyTempSection(using: section)
            case .uviAndHumidityInfo, .pressureAndWindInfo:
                return self.createMeteoInfoSection(using: section)
            }
        }

        return layout
    }
    
    private func createDailyTempSection(using: DailyDetailedCellSection) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalWidth(1 / 2)
        )
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize,
            subitems: [item]
        )
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset / 2, trailing: inset)
        return section
    }
    
    private func createMeteoInfoSection(using: DailyDetailedCellSection) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalWidth(1/2)
        )
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize,
            subitems: [item]
        )
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: inset / 2, leading: inset, bottom: inset / 2, trailing: inset)
        return section
    }
    
    private func createDataSource() {
        dataSource = DataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, forecast in
            guard let section = DailyDetailedCellSection(rawValue: indexPath.section) else {
                fatalError("Unknown section kind")
            }
//            guard let offset = self.forecastData?.timezoneOffset else {
//                fatalError("No date")
//            }

            switch section {
            case .dailyTempInfo:
                guard let cell = self.collectionView.dequeueReusableCell(
                    withReuseIdentifier: DailyTempCell.reuseIdentifier,
                    for: indexPath
                ) as? DailyTempCell else {
                    fatalError("Unable to dequeue cell")
                }
                cell.configure(with: forecast.details)
                return cell
            case .uviAndHumidityInfo:
                guard let meteorologicCell = self.collectionView.dequeueReusableCell(
                    withReuseIdentifier: MeteoInfoCell.reuseIdentifier,
                    for: indexPath
                ) as? MeteoInfoCell else {
                    fatalError("Unable to dequeue MeteorologicInfoCell")
                }
                meteorologicCell.configure(for: .uviAndHumidity, with: forecast.details)
                return meteorologicCell
            case .pressureAndWindInfo:
                guard let meteorologicCell = self.collectionView.dequeueReusableCell(
                    withReuseIdentifier: MeteoInfoCell.reuseIdentifier,
                    for: indexPath
                ) as? MeteoInfoCell else {
                    fatalError("Unable to dequeue MeteorologicInfoCell")
                }
                meteorologicCell.configure(for: .pressureAndWind, with: forecast.details)
                return meteorologicCell
            }

        })
    }
    
    private func makeSnapshot() -> Snapshot {
        var snapshot = Snapshot()

        guard let dailyData = dailyData else {
            fatalError()
        }

        snapshot.appendSections(DailyDetailedCellSection.allCases)
        snapshot.appendItems(
            [CategorisedDailyCellItems(details: dailyData, category: .dailyTempInfo)],
            toSection: .dailyTempInfo
        )
        snapshot.appendItems(
            [CategorisedDailyCellItems(details: dailyData, category: .uviAndHumidityInfo)],
            toSection: .uviAndHumidityInfo
        )
        snapshot.appendItems(
            [CategorisedDailyCellItems(details: dailyData, category: .pressureAndWindInfo)],
            toSection: .pressureAndWindInfo
        )
        
        return snapshot
    }
}

