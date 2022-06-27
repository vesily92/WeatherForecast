//
//  DetailedDailyForecastViewController.swift
//  WeatherForecast
//
//  Created by Василий Пронин on 20.06.2022.
//

import UIKit

class DetailedDailyForecastViewController: UIViewController {
    
    private enum DetailedDailySection: Int, CaseIterable {
        case dayPicker
        case dailyTempInfo
        case uviAndHumidityInfo
        case pressureAndWindInfo
    }
    
    private struct CategorisedDailyItems: Hashable {
        let details: Daily
        let category: DetailedDailySection
    }
    
    private typealias DataSource = UICollectionViewDiffableDataSource<DetailedDailySection, CategorisedDailyItems>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<DetailedDailySection, CategorisedDailyItems>
    
    private var collectionView: UICollectionView!
    private var dataSource: DataSource?
    private var forecastData: ForecastData? {
        didSet {
            dataSource?.apply(makeSnapshot(), animatingDifferences: false)
        }
    }
    private let inset: CGFloat = 16

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
            DayPickerCell.self,
            forCellWithReuseIdentifier: DayPickerCell.reuseIdentifier
        )
        collectionView.register(
            DailyTempCell.self,
            forCellWithReuseIdentifier: DailyTempCell.reuseIdentifier
        )
        collectionView.register(
            MeteorologicInfoCell.self,
            forCellWithReuseIdentifier: MeteorologicInfoCell.reuseIdentifier
        )
    }
    
    private func createCompositionalGridLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            guard let section = DetailedDailySection(rawValue: sectionIndex) else {
                fatalError("Unknown section kind")
            }
            
            switch section {
            case .dayPicker:
                return self.createDayPickerSection(using: section)
            case .dailyTempInfo:
                return self.createDailyTempSection(using: section)
            case .uviAndHumidityInfo, .pressureAndWindInfo:
                return self.createMeteorologicInfoSection(using: section)
            }
        }

        return layout
    }
    
    private func createDailyTempSection(using: DetailedDailySection) -> NSCollectionLayoutSection {
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
    
    private func createDayPickerSection(using: DetailedDailySection) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .estimated(68),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .estimated(68),
            heightDimension: .estimated(90.0)
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
    
    private func createMeteorologicInfoSection(using: DetailedDailySection) -> NSCollectionLayoutSection {
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
            guard let section = DetailedDailySection(rawValue: indexPath.section) else {
                fatalError("Unknown section kind")
            }
            guard let offset = self.forecastData?.timezoneOffset else {
                fatalError("No date")
            }

            switch section {
            case .dayPicker:
                guard let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: DayPickerCell.reuseIdentifier, for: indexPath) as? DayPickerCell else {
                    fatalError("Unable to dequeue DayPickerCell")
                }
                cell.configure(with: forecast.details)
                return cell
            case .dailyTempInfo:
                guard let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: DailyTempCell.reuseIdentifier, for: indexPath) as? DailyTempCell else {
                    fatalError("Unable to dequeue cell")
                }
                cell.configure(with: forecast.details, andTimeZoneOffset: offset)
                return cell
            case .uviAndHumidityInfo:
                guard let meteorologicCell = self.collectionView.dequeueReusableCell(withReuseIdentifier: MeteorologicInfoCell.reuseIdentifier, for: indexPath) as? MeteorologicInfoCell else {
                    fatalError("Unable to dequeue MeteorologicInfoCell")
                }
                meteorologicCell.configure(for: .uviAndHumidity, with: forecast.details, andTimeZoneOffset: offset)
                return meteorologicCell
            case .pressureAndWindInfo:
                guard let meteorologicCell = self.collectionView.dequeueReusableCell(withReuseIdentifier: MeteorologicInfoCell.reuseIdentifier, for: indexPath) as? MeteorologicInfoCell else {
                    fatalError("Unable to dequeue MeteorologicInfoCell")
                }
                meteorologicCell.configure(for: .pressureAndWind, with: forecast.details, andTimeZoneOffset: offset)
                return meteorologicCell
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
        
        for dailyData in forecastData.daily {
            snapshot.appendItems([CategorisedDailyItems(details: dailyData, category: .dayPicker)], toSection: .dayPicker)
        }
        snapshot.appendItems([CategorisedDailyItems(details: forecastData.daily.first!, category: .dailyTempInfo)], toSection: .dailyTempInfo)
        snapshot.appendItems([CategorisedDailyItems(details: forecastData.daily.first!, category: .uviAndHumidityInfo)], toSection: .uviAndHumidityInfo)
        snapshot.appendItems([CategorisedDailyItems(details: forecastData.daily.first!, category: .pressureAndWindInfo)], toSection: .pressureAndWindInfo)

        return snapshot
    }
}
