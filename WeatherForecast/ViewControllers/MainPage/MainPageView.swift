//
//  MainPageView.swift
//  WeatherForecast
//
//  Created by Василий Пронин on 12.12.2022.
//

import UIKit

class MainPageView: UIView {
    
    private struct CategorisedCellItems: Hashable {
        let details: Daily
        let category: ConditionsCell.SectionType
    }

    private enum Item {
        case reusableCell
        case reusableView
        case sectionHeader
    }
    
    private typealias DataSource = UICollectionViewDiffableDataSource<Section, AnyHashable>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable>
       
    // MARK: Callbacks

    var onCellTapped: ((ForecastData, Int) -> Void)?
         
    // MARK: Properties

    private var collectionView: UICollectionView!
    private var dataSource: DataSource?
    private var forecastData: ForecastData? {
        didSet { dataSource?.apply(makeSnapshot()) }
    }
    private let inset: CGFloat = 16
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupCollectionView()
        createDataSource()
        registerCells()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with forecastData: ForecastData) {
        self.forecastData = forecastData
    }
    
    // MARK: Setup UI
    
    private func setupCollectionView() {
        collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: createCompositionalLayout()
        )
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemGray4
        collectionView.showsVerticalScrollIndicator = false
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.delegate = self
        
        self.addSubview(collectionView)
    }
    
    private func registerCells() {
        collectionView.register(
            EmptyCell.self,
            forCellWithReuseIdentifier: EmptyCell.reuseIdentifier
        )
        collectionView.register(
            AlertCell.self,
            forCellWithReuseIdentifier: AlertCell.reuseIdentifier
        )
        collectionView.register(
            HourlyCollectionViewCell.self,
            forCellWithReuseIdentifier: HourlyCollectionViewCell.reuseIdentifier
        )
        collectionView.register(
            DailyCell.self,
            forCellWithReuseIdentifier: DailyCell.reuseIdentifier
        )
        collectionView.register(
            ConditionsCell.self,
            forCellWithReuseIdentifier: ConditionsCell.reuseIdentifier
        )
        collectionView.register(
            GlobalHeader.self,
            forSupplementaryViewOfKind: GlobalHeader.reuseIdentifier,
            withReuseIdentifier: GlobalHeader.reuseIdentifier
        )
        collectionView.register(
            GlobalFooter.self,
            forSupplementaryViewOfKind: GlobalFooter.reuseIdentifier,
            withReuseIdentifier: GlobalFooter.reuseIdentifier
        )
        collectionView.register(
            SectionHeader.self,
            forSupplementaryViewOfKind: SectionHeader.reuseIdentifier,
            withReuseIdentifier: SectionHeader.reuseIdentifier
        )
        collectionView.register(
            SectionFooter.self,
            forSupplementaryViewOfKind: SectionFooter.reuseIdentifier,
            withReuseIdentifier: SectionFooter.reuseIdentifier
        )
    }
    
    // MARK: Setup layout
    
    private func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [unowned self] sectionIndex, layoutEnvironment in
            guard let section = Section(rawValue: sectionIndex) else {
                fatalError("Unknown section kind")
            }
            switch section {
            case .alert:
                if let forecastData = forecastData {
                    if forecastData.alerts != nil {
                        return createAlertSection(using: section)
                    }
                }
                return createEmptySection(using: section)
            case .hourlyCollection:
                return createHourlyCollectionSection(using: section)
            case .daily:
                return createDailySection(using: section, and: layoutEnvironment)
            case .uviAndHumidity:
                return createMeteoInfoSection(using: section)
            case .pressureAndWind:
                return createMeteoInfoSection(using: section)
            }
        }
        let globalHeader = createGlobalHeader(
            withKind: GlobalHeader.reuseIdentifier
        )
        let globalFooter = createGlobalFooter(
            withKind: GlobalFooter.reuseIdentifier
        )
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.boundarySupplementaryItems = [globalHeader, globalFooter]
        config.interSectionSpacing = 16
        layout.configuration = config
        layout.register(
            SectionBackgroundView.self,
            forDecorationViewOfKind: SectionBackgroundView.reuseIdentifier
        )
        return layout
    }
}

// - MARK: DataSource

extension MainPageView {
    
    private func createDataSource() {
        dataSource = DataSource(
            collectionView: collectionView
        ) { [weak self] collectionView, indexPath, forecast in
            
            guard let section = Section(rawValue: indexPath.section) else {
                fatalError("Unknown section kind")
            }
            return self?.cell(
                collectionView: collectionView,
                indexPath: indexPath,
                forecast: forecast,
                section: section
            )
        }
        dataSource?.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
            return self?.supplementaryView(
                collectionView: collectionView,
                indexPath: indexPath,
                kind: kind
            )
        }
    }
    
    private func makeSnapshot() -> Snapshot {
        var snapshot = Snapshot()

        guard let forecastData = forecastData,
              let daily = forecastData.daily.first else {
            fatalError()
        }

        if let alert = forecastData.alerts?.first {
            snapshot.appendSections(Section.allCases)
            snapshot.appendItems([alert], toSection: .alert)
            snapshot.appendItems([forecastData], toSection: .hourlyCollection)
            snapshot.appendItems(forecastData.daily, toSection: .daily)
            
            snapshot.appendItems(
                [CategorisedCellItems(details: daily,category: .uviAndHumidity)],
                toSection: .uviAndHumidity
            )
            snapshot.appendItems(
                [CategorisedCellItems(details: daily, category: .pressureAndWind)],
                toSection: .pressureAndWind
            )
        } else {
            snapshot.appendSections(Section.allCases)
            snapshot.appendItems([forecastData], toSection: .hourlyCollection)
            snapshot.appendItems(forecastData.daily, toSection: .daily)
            
            snapshot.appendItems(
                [CategorisedCellItems(details: daily, category: .uviAndHumidity)],
                toSection: .uviAndHumidity
            )
            snapshot.appendItems(
                [CategorisedCellItems(details: daily, category: .pressureAndWind)],
                toSection: .pressureAndWind
            )
        }
        
        return snapshot
    }
}

// - MARK: Sections

extension MainPageView {
    
    private func createEmptySection(using: Section) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .absolute(0.1),
            heightDimension: .absolute(0.1)
            )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(0.1),
            heightDimension: .absolute(0.1)
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
            heightDimension: .absolute(60)
        )
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize,
            subitem: item,
            count: 1
        )
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: inset,
            bottom: 0,
            trailing: inset
        )

        let sectionHeader = createSectionHeader()
        let sectionFooter = createSectionFooter()
        section.boundarySupplementaryItems = [sectionHeader, sectionFooter]
        
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
            heightDimension: .absolute(120.0)
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
            leading: inset,
            bottom: 0,
            trailing: inset
        )
        section.boundarySupplementaryItems = [sectionHeader]
        
        section.visibleItemsInvalidationHandler = { items, offset, _ in
            guard let globalHeader = self.collectionView.visibleSupplementaryViews(ofKind: GlobalHeader.reuseIdentifier).first as? GlobalHeader else { return }
            
            if offset.y < 0 {
                globalHeader.setAlphaForMainLabels(with: 1)
            }
            if offset.y > 30 {
                globalHeader.setAlphaForMainLabels(with: 1 - ((offset.y - 30) / 100))
                globalHeader.reduceZIndex()
            }
            if offset.y > 130 {
                globalHeader.setAlphaForSubheadline(with: 0 + ((offset.y - 130) / 13))
                globalHeader.restoreZIndex()
            } else {
                globalHeader.setAlphaForSubheadline(with: 0 + ((offset.y - 130) / 100))
            }
        }
        return section
    }
    
    private func createDailySection(using: Section, and layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        var configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        
        if #available(iOS 14.5, *) {
            configuration.separatorConfiguration.color = .white
            configuration.separatorConfiguration.bottomSeparatorInsets = NSDirectionalEdgeInsets(
                top: 0,
                leading: inset,
                bottom: 0,
                trailing: inset
            )
        }
        configuration.backgroundColor = .clear
        
        let section = NSCollectionLayoutSection.list(
            using: configuration,
            layoutEnvironment: layoutEnvironment
        )
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: inset,
            bottom: 0,
            trailing: inset
        )
        
        let sectionHeader = createSectionHeader()
        section.boundarySupplementaryItems = [sectionHeader]
        
        let backgroundView = createBackgroundView()
        section.decorationItems = [backgroundView]
        
        return section
    }
    
    private func createMeteoInfoSection(using: Section) -> NSCollectionLayoutSection {
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
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: inset,
            bottom: 0,
            trailing: inset
        )
        return section
    }
    
    private func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(36)
        )
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: SectionHeader.reuseIdentifier,
            alignment: .topLeading
        )
        return sectionHeader
    }
    
    private func createSectionFooter() -> NSCollectionLayoutBoundarySupplementaryItem {
        let footerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(46)
        )
        let sectionFooter = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: footerSize,
            elementKind: SectionFooter.reuseIdentifier,
            alignment: .bottom
        )
        return sectionFooter
    }
    
    private func createGlobalHeader(withKind headerKind: String) -> NSCollectionLayoutBoundarySupplementaryItem {
        let globalHeaderSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(300)
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
            heightDimension: .absolute(200)
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
        let sideInset: CGFloat = inset
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

// MARK: Helpers

extension MainPageView {
    
    private func configure<T: SelfConfigurable>(
        _ viewType: T.Type,
        ofType type: Item = .reusableCell,
        with model: AnyHashable,
        for indexPath: IndexPath
    ) -> T {
        guard let tzOffset = self.forecastData?.timezoneOffset else {
            fatalError("No data")
        }
        
        switch type {
        case .reusableCell:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: viewType.reuseIdentifier,
                for: indexPath
            ) as? T else {
                fatalError("Unable to dequeue \(viewType)")
            }
            
            cell.configure(with: model, tzOffset: tzOffset)
            return cell
            
        case .reusableView:
            guard let reusableView = collectionView.dequeueReusableSupplementaryView(
                ofKind: viewType.reuseIdentifier,
                withReuseIdentifier: viewType.reuseIdentifier,
                for: indexPath
            ) as? T else {
                fatalError("Unable to dequeue \(viewType)")
            }
            
            reusableView.configure(with: model, tzOffset: tzOffset)
            return reusableView
            
        case .sectionHeader:
            guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(
                ofKind: viewType.reuseIdentifier,
                withReuseIdentifier: viewType.reuseIdentifier,
                for: indexPath
            ) as? T,
                  let section = Section(rawValue: indexPath.section) else {
                fatalError("Unable to deque sectionHeader")
            }
            
            switch section {
            case .alert:
                if let forecastData = self.forecastData {
                    sectionHeader.configure(with: forecastData, tzOffset: tzOffset)
                }
            case .hourlyCollection:
                sectionHeader.configure(with: section, tzOffset: tzOffset)
            case .daily:
                sectionHeader.configure(with: section, tzOffset: tzOffset)
            default: break
            }
            return sectionHeader
        }
    }
    
    private func cell(collectionView: UICollectionView, indexPath: IndexPath, forecast: AnyHashable, section: Section) -> UICollectionViewCell {
        
        switch section {
        case .alert:
            if let forecastData = forecastData {
                if forecastData.alerts != nil {
                    return configure(
                        AlertCell.self,
                        with: forecast,
                        for: indexPath
                    )
                }
            }
            return configure(
                EmptyCell.self,
                with: forecast,
                for: indexPath
            )
            
        case .hourlyCollection:
            return configure(
                HourlyCollectionViewCell.self,
                with: forecast,
                for: indexPath
            )
            
        case .daily:
            return configure(
                DailyCell.self,
                with: forecast,
                for: indexPath
            )
            
        case .uviAndHumidity:
            guard let forecast = forecast as? CategorisedCellItems,
                  let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: ConditionsCell.reuseIdentifier,
                    for: indexPath
                  ) as? ConditionsCell else {
                fatalError("Unable to dequeue \(String(describing: cell))")
            }
            cell.configure(for: .uviAndHumidity, with: forecast.details)
            return cell
            
        case .pressureAndWind:
            guard let forecast = forecast as? CategorisedCellItems,
                  let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: ConditionsCell.reuseIdentifier, for: indexPath
                  ) as? ConditionsCell else {
                fatalError("Unable to dequeue \(String(describing: cell))")
            }
            cell.configure(for: .pressureAndWind, with: forecast.details)
            return cell
        }
    }
    
    private func supplementaryView(collectionView: UICollectionView, indexPath: IndexPath, kind: String) -> UICollectionReusableView {
                
        switch kind {
        case GlobalHeader.reuseIdentifier:
            return configure(
                GlobalHeader.self,
                ofType: .reusableView,
                with: forecastData,
                for: indexPath
            )
            
        case GlobalFooter.reuseIdentifier:
            return configure(
                GlobalFooter.self,
                ofType: .reusableView,
                with: forecastData,
                for: indexPath
            )
            
        case SectionFooter.reuseIdentifier:
            return configure(
                SectionFooter.self,
                ofType: .reusableView,
                with: forecastData,
                for: indexPath
            )
            
        default:
            return configure(
                SectionHeader.self,
                ofType: .sectionHeader,
                with: forecastData,
                for: indexPath
            )
        }
    }
}

// MARK: Delegate

extension MainPageView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let section = Section(rawValue: indexPath.section) else {
            fatalError("Unknown section kind")
        }
        guard let forecastData = forecastData else { return }

        if section == .daily {
            NotificationCenter.default.post(
                name: .scrollToItem,
                object: nil
            )
            onCellTapped?(forecastData, indexPath.item)
        }
    }
}
