//
//  DailyDetailedCollectionViewCell.swift
//  WeatherForecast
//
//  Created by Василий Пронин on 29.06.2022.
//

import UIKit

class DailyDetailedCollectionViewCell: UICollectionViewCell, Coordinatable {
    
    private enum DailyDetailedCellSection: Int, CaseIterable {
        case dayPicker
        case dailyTempInfo
        case uviAndHumidityInfo
        case pressureAndWindInfo
    }
    
    private struct CategorisedDailyItems: Hashable {
        let details: Daily
        let category: DailyDetailedCellSection
    }
    
    private typealias DataSource = UICollectionViewDiffableDataSource<DailyDetailedCellSection, CategorisedDailyItems>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<DailyDetailedCellSection, CategorisedDailyItems>
    
    static let reuseIdentifier = "DailyDetailedCollectionViewCell"
    
    weak var coordinator: Coordinator?
//    var itemIndex: Int!
    
    private var collectionView: UICollectionView!
    private var dataSource: DataSource?
    private var forecastData: ForecastData? {
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
        guard let forecast = forecast as? ForecastData else { return }
        self.forecastData = forecast
    }
    
    private func setupCollectionView() {
        collectionView = UICollectionView(
            frame: contentView.bounds,
            collectionViewLayout: createCompositionalLayout()
        )
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .darkGray
        collectionView.delegate = self
        contentView.addSubview(collectionView)
        
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
    
    private func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            guard let section = DailyDetailedCellSection(rawValue: sectionIndex) else {
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
    
    private func createDayPickerSection(using: DailyDetailedCellSection) -> NSCollectionLayoutSection {
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
    
    private func createMeteorologicInfoSection(using: DailyDetailedCellSection) -> NSCollectionLayoutSection {
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
 
        snapshot.appendSections(DailyDetailedCellSection.allCases)
        
        for dailyData in forecastData.daily {
            snapshot.appendItems([CategorisedDailyItems(details: dailyData, category: .dayPicker)], toSection: .dayPicker)
        }
        snapshot.appendItems([CategorisedDailyItems(details: forecastData.daily.first!, category: .dailyTempInfo)], toSection: .dailyTempInfo)
        snapshot.appendItems([CategorisedDailyItems(details: forecastData.daily.first!, category: .uviAndHumidityInfo)], toSection: .uviAndHumidityInfo)
        snapshot.appendItems([CategorisedDailyItems(details: forecastData.daily.first!, category: .pressureAndWindInfo)], toSection: .pressureAndWindInfo)

        return snapshot
    }
}

extension DailyDetailedCollectionViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let section = DailyDetailedCellSection(rawValue: indexPath.section) else { return }

        if section == .dayPicker {
            print(indexPath.item)
            
        }
    }
}
