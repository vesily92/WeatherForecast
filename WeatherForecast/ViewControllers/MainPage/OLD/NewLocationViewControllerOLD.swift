//
//  NewLocationViewControllerOLD.swift
//  WeatherForecast
//
//  Created by Василий Пронин on 26.08.2022.
//

import UIKit

//class NewLocationViewControllerOLD: UIViewController {
//
//    private typealias DataSource = UICollectionViewDiffableDataSource<Section, AnyHashable>
//    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable>
//
////    var onAddLocationTapped: ((ForecastData) -> Void)?
//
//    var isNew: Bool!
//    var forecastData: ForecastData?
//    private var collectionView: UICollectionView!
//    private var dataSource: DataSource?
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupNavBar()
//        setupCollectionView()
//        createDataSource()
//        registerCells()
//
//        reloadData()
//    }
//
//    @objc private func addNewLocation() {
//        if let forecastData = forecastData {
//            NotificationCenter.default.post(
//                name: .appendData,
//                object: [NotificationKeys.data: forecastData]
//            )
////
//
////            onAddLocationTapped?(forecastData)
////            print(forecastData.current.dt)
//            dismiss(animated: true)
//        }
//    }
//
//    @objc private func cancel() {
//        dismiss(animated: true)
//    }
//
//    private func setupNavBar() {
//        let config = UIImage.SymbolConfiguration(weight: .semibold)
//        let image = UIImage(systemName: "plus", withConfiguration: config)
//        navigationItem.leftBarButtonItem = UIBarButtonItem(
//            barButtonSystemItem: .cancel,
//            target: self,
//            action: #selector(cancel)
//        )
//        if isNew {
//            navigationItem.rightBarButtonItem = UIBarButtonItem(
//                image: image,
//                style: .plain,
//                target: self,
//                action: #selector(addNewLocation)
//            )
//            navigationItem.rightBarButtonItem?.tintColor = .white
//        }
//        navigationItem.leftBarButtonItem?.tintColor = .white
//        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
//        navigationController?.navigationBar.shadowImage = UIImage()
//        navigationController?.navigationBar.layoutIfNeeded()
//    }
//
//    private func setupCollectionView() {
//        collectionView = UICollectionView(
//            frame: view.bounds,
//            collectionViewLayout: createCompositionalLayout()
//        )
//        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        collectionView.backgroundColor = .systemGray4
//        collectionView.showsVerticalScrollIndicator = false
//        collectionView.contentInsetAdjustmentBehavior = .never
//
//        view.addSubview(collectionView)
//    }
//
//    private func registerCells() {
//        collectionView.register(
//            EmptyCell.self,
//            forCellWithReuseIdentifier: EmptyCell.reuseIdentifier
//        )
//        collectionView.register(
//            AlertCell.self,
//            forCellWithReuseIdentifier: AlertCell.reuseIdentifier
//        )
//        collectionView.register(
//            HourlyCollectionViewCell.self,
//            forCellWithReuseIdentifier: HourlyNestedCollectionViewCell.reuseIdentifier
//        )
//        collectionView.register(
//            DailyCell.self,
//            forCellWithReuseIdentifier: DailyCell.reuseIdentifier
//        )
//        collectionView.register(
//            GlobalHeader.self,
//            forSupplementaryViewOfKind: GlobalHeader.reuseIdentifier,
//            withReuseIdentifier: GlobalHeader.reuseIdentifier
//        )
//        collectionView.register(
//            GlobalFooter.self,
//            forSupplementaryViewOfKind: GlobalFooter.reuseIdentifier,
//            withReuseIdentifier: GlobalFooter.reuseIdentifier
//        )
//        collectionView.register(
//            SectionHeader.self,
//            forSupplementaryViewOfKind: SectionHeader.reuseIdentifier,
//            withReuseIdentifier: SectionHeader.reuseIdentifier
//        )
//    }
//
////    private func configure<T: SelfConfiguringCell>(_ cellType: T.Type, with model: AnyHashable, andTimeZone offset: Int, for indexPath: IndexPath) -> T {
////        guard let cell = collectionView.dequeueReusableCell(
////            withReuseIdentifier: cellType.reuseIdentifier,
////            for: indexPath
////        ) as? T else {
////            fatalError("Unable to dequeue \(cellType)")
////        }
////
////        cell.configure(with: model, tzOffset: offset)
////        return cell
////    }
//
//    private func configure<T: SelfConfigurable>(
//        _ cellType: T.Type,
//        with model: AnyHashable,
//        for indexPath: IndexPath
//    ) -> T {
//        guard let cell = collectionView.dequeueReusableCell(
//            withReuseIdentifier: cellType.reuseIdentifier,
//            for: indexPath
//        ) as? T else {
//            fatalError("Unable to dequeue \(cellType)")
//        }
//
//        guard let tzOffset = self.forecastData?.timezoneOffset else {
//            fatalError("No data")
//        }
//
//        cell.configure(with: model, tzOffset: tzOffset)
//        return cell
//    }
//
//    private func cell(collectionView: UICollectionView, indexPath: IndexPath, forecast: AnyHashable, section: Section) -> UICollectionViewCell {
//
//        switch section {
//        case .alert:
//            if let forecastData = forecastData {
//                if forecastData.alerts != nil {
//                    return configure(AlertCell.self, with: forecast, for: indexPath)
//                }
//            }
//            return configure(EmptyCell.self, with: forecast, for: indexPath)
//        case .hourlyCollection:
//            return configure(HourlyNestedCollectionViewCell.self, with: forecast, for: indexPath)
//        case .daily:
//            return configure(DailyCell.self, with: forecast, for: indexPath)
//        }
//    }
//
//    private func supplementaryView(collectionView: UICollectionView, indexPath: IndexPath, kind: String) -> UICollectionReusableView {
//
//        switch kind {
//        case GlobalHeader.reuseIdentifier:
//            guard let globalHeader = collectionView.dequeueReusableSupplementaryView(
//                ofKind: kind,
//                withReuseIdentifier: kind,
//                for: indexPath
//            ) as? GlobalHeader else {
//                fatalError("Unknown header kind")
//            }
//            if let forecastData = self.forecastData {
//                globalHeader.configure(with: forecastData)
//            }
//            return globalHeader
//
//        case GlobalFooter.reuseIdentifier:
//            guard let globalFooter = collectionView.dequeueReusableSupplementaryView(
//                ofKind: kind,
//                withReuseIdentifier: kind,
//                for: indexPath
//            ) as? GlobalFooter else {
//                fatalError("Unknown global footer kind")
//            }
//            if let forecastData = self.forecastData {
//                globalFooter.configure(with: forecastData)
//            }
//            return globalFooter
//
//        default:
//            guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(
//                ofKind: SectionHeader.reuseIdentifier,
//                withReuseIdentifier: SectionHeader.reuseIdentifier,
//                for: indexPath
//            ) as? SectionHeader,
//                  let section = Section(rawValue: indexPath.section) else {
//                fatalError("Unable to deque sectionHeader")
//            }
//
//            switch section {
//            case .alert:
//                if let forecastData = self.forecastData {
//                    sectionHeader.configure(with: forecastData)
//                }
//            case .hourlyCollection:
//                sectionHeader.configure(with: section)
//            case .daily:
//                sectionHeader.configure(with: section)
//            }
//            return sectionHeader
//        }
//    }
//
//    private func createCompositionalLayout() -> UICollectionViewLayout {
//        let layout = UICollectionViewCompositionalLayout { [unowned self] sectionIndex, layoutEnvironment in
//            guard let section = Section(rawValue: sectionIndex) else {
//                fatalError("Unknown section kind")
//            }
//            switch section {
//            case .alert:
//                if let forecastData = forecastData {
//                    if forecastData.alerts != nil {
//                        return createAlertSection(using: section)
//                    }
//                }
//                return createEmptySection(using: section)
//            case .hourlyCollection:
//                return createHourlyCollectionSection(using: section)
//            case .daily:
//                return createDailySection(using: section, and: layoutEnvironment)
//            }
//        }
//        let currentWeatherHeader = createGlobalHeader(
//            withKind: GlobalHeader.reuseIdentifier
//        )
//        let globalFooter = createGlobalFooter(
//            withKind: GlobalFooter.reuseIdentifier
//        )
//        let config = UICollectionViewCompositionalLayoutConfiguration()
//        config.boundarySupplementaryItems = [currentWeatherHeader, globalFooter]
//        config.interSectionSpacing = 20
//        layout.configuration = config
//        layout.register(
//            SectionBackgroundView.self,
//            forDecorationViewOfKind: SectionBackgroundView.reuseIdentifier
//        )
//
//        return layout
//    }
//}
//
//// - MARK: DataSource
//
//extension NewLocationViewControllerOLD {
//
//    private func createDataSource() {
//        dataSource = DataSource(collectionView: collectionView) { [weak self] collectionView, indexPath, forecast in
//            guard let section = Section(rawValue: indexPath.section) else {
//                fatalError("Unknown section kind")
//            }
//
//            return self?.cell(
//                collectionView: collectionView,
//                indexPath: indexPath,
//                forecast: forecast,
//                section: section
//            )
//
////            guard let offset = self?.forecastData?.timezoneOffset else {
////                fatalError("No data")
////            }
////
////            switch section {
////            case .alert:
////                if let forecastData = self?.forecastData {
////                    if forecastData.alerts != nil {
////                        return self?.configure(
////                            AlertCell.self,
////                            with: forecast,
////                            andTimeZone: offset,
////                            for: indexPath
////                        )
////                    }
////                }
////                return self?.configure(
////                    EmptyCell.self,
////                    with: forecast,
////                    andTimeZone: offset,
////                    for: indexPath
////                )
////            case .hourlyCollection:
////                return self?.configure(
////                    HourlyNestedCollectionViewCell.self,
////                    with: forecast,
////                    andTimeZone: offset,
////                    for: indexPath
////                )
////            case .daily:
////                return self?.configure(
////                    DailyCell.self,
////                    with: forecast,
////                    andTimeZone: offset,
////                    for: indexPath
////                )
////            }
//        }
//
//        dataSource?.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
//
//            return self?.supplementaryView(
//                collectionView: collectionView,
//                indexPath: indexPath,
//                kind: kind
//            )
////            switch kind {
////            case GlobalHeader.reuseIdentifier:
////                guard let currentWeatherHeader = weatherCollectionView.dequeueReusableSupplementaryView(
////                    ofKind: GlobalHeader.reuseIdentifier,
////                    withReuseIdentifier: GlobalHeader.reuseIdentifier,
////                    for: indexPath
////                ) as? GlobalHeader else {
////                    fatalError("Unknown header kind")
////                }
////
////                if let forecastData = self?.forecastData {
////                    currentWeatherHeader.configure(with: forecastData)
////                }
////
////                return currentWeatherHeader
////
////            case GlobalFooter.reuseIdentifier:
////                guard let globalFooter = weatherCollectionView.dequeueReusableSupplementaryView(
////                    ofKind: GlobalFooter.reuseIdentifier,
////                    withReuseIdentifier: GlobalFooter.reuseIdentifier,
////                    for: indexPath
////                ) as? GlobalFooter else {
////                    fatalError("Unknown global footer kind")
////                }
////
////                if let forecastData = self?.forecastData {
////                    globalFooter.configure(with: forecastData)
////                }
////                return globalFooter
////
////            default:
////                guard let sectionHeader = weatherCollectionView.dequeueReusableSupplementaryView(
////                    ofKind: SectionHeader.reuseIdentifier,
////                    withReuseIdentifier: SectionHeader.reuseIdentifier,
////                    for: indexPath
////                ) as? SectionHeader else {
////                    return nil
////                }
////                guard let section = Section(rawValue: indexPath.section) else {
////                    return nil
////                }
////
////                switch section {
////                case .alert:
////                    if let forecastData = self?.forecastData {
////                        sectionHeader.configureForAlertSection(with: forecastData)
////                    }
////                case .hourlyCollection:
////                    sectionHeader.configure(with: section)
////                case .daily:
////                    sectionHeader.configure(with: section)
////                }
////                return sectionHeader
////            }
//        }
//    }
//
//    private func reloadData() {
//        var snapshot = Snapshot()
//
//        guard let forecastData = forecastData else {
//            fatalError()
//        }
//
//        let forecasts = Array(repeating: forecastData, count: 1)
//
//        if let alert = forecastData.alerts?.first {
//            let alerts = Array(repeating: alert, count: 1)
//            snapshot.appendSections(Section.allCases)
//            snapshot.appendItems(alerts, toSection: .alert)
//            snapshot.appendItems(forecasts, toSection: .hourlyCollection)
//            snapshot.appendItems(forecastData.daily, toSection: .daily)
//        } else {
//            snapshot.appendSections(Section.allCases)
//            snapshot.appendItems(forecasts, toSection: .hourlyCollection)
//            snapshot.appendItems(forecastData.daily, toSection: .daily)
//        }
//        dataSource?.apply(snapshot, animatingDifferences: true)
//    }
//
//}
//
//// - MARK: Sections
//extension NewLocationViewControllerOLD {
//
//    private func createEmptySection(using: Section) -> NSCollectionLayoutSection {
//        let itemSize = NSCollectionLayoutSize(
//            widthDimension: .absolute(0.1),
//            heightDimension: .absolute(0.1)
//            )
//        let item = NSCollectionLayoutItem(layoutSize: itemSize)
//
//        let groupSize = NSCollectionLayoutSize(
//            widthDimension: .estimated(0.1),
//            heightDimension: .estimated(0.1)
//        )
//        let group = NSCollectionLayoutGroup.vertical(
//            layoutSize: groupSize,
//            subitems: [item]
//        )
//        let section = NSCollectionLayoutSection(group: group)
//        return section
//    }
//
//    private func createAlertSection(using: Section) -> NSCollectionLayoutSection {
//        let itemSize = NSCollectionLayoutSize(
//            widthDimension: .fractionalWidth(1.0),
//            heightDimension: .fractionalHeight(1.0)
//        )
//        let item = NSCollectionLayoutItem(layoutSize: itemSize)
//
//        let groupSize = NSCollectionLayoutSize(
//            widthDimension: .fractionalWidth(1.0),
//            heightDimension: .estimated(90)
//        )
//        let group = NSCollectionLayoutGroup.vertical(
//            layoutSize: groupSize,
//            subitem: item,
//            count: 1
//        )
//        let section = NSCollectionLayoutSection(group: group)
//        section.contentInsets = NSDirectionalEdgeInsets(
//            top: 0,
//            leading: 16,
//            bottom: 0,
//            trailing: 16
//        )
//
//        let sectionHeader = createSectionHeader()
//        section.boundarySupplementaryItems = [sectionHeader]
//
//        let backgroundView = createBackgroundView()
//        section.decorationItems = [backgroundView]
//        return section
//    }
//
//    private func createHourlyCollectionSection(using: Section) -> NSCollectionLayoutSection {
//        let itemSize = NSCollectionLayoutSize(
//            widthDimension: .fractionalWidth(1.0),
//            heightDimension: .fractionalHeight(1.0)
//        )
//        let item = NSCollectionLayoutItem(layoutSize: itemSize)
//
//        let groupSize = NSCollectionLayoutSize(
//            widthDimension: .fractionalWidth(1.0),
//            heightDimension: .estimated(120.0)
//        )
//        let group = NSCollectionLayoutGroup.horizontal(
//            layoutSize: groupSize,
//            subitems: [item]
//        )
//        let section = NSCollectionLayoutSection(group: group)
//        section.orthogonalScrollingBehavior = .continuous
//
//        let backgroundView = createBackgroundView()
//        section.decorationItems = [backgroundView]
//
//        let sectionHeader = createSectionHeader()
//        sectionHeader.contentInsets = NSDirectionalEdgeInsets(
//            top: 0,
//            leading: 16,
//            bottom: 0,
//            trailing: 16
//        )
//        section.boundarySupplementaryItems = [sectionHeader]
//
//        section.visibleItemsInvalidationHandler = { items, offset, _ in
//            guard let globalHeader = self.collectionView.visibleSupplementaryViews(ofKind: GlobalHeader.reuseIdentifier).first as? GlobalHeader else { return }
//
//            if offset.y < 0 {
//                globalHeader.setAlphaForMainLabels(with: 1)
//            }
//            if offset.y > 30 {
//                globalHeader.setAlphaForMainLabels(with: 1 - ((offset.y - 30) / 100))
//                globalHeader.reduceZIndex()
//            }
//            if offset.y > 130 {
//                globalHeader.setAlphaForSubheadline(with: 0 + ((offset.y - 130) / 13))
//                globalHeader.restoreZIndex()
//            } else {
//                globalHeader.setAlphaForSubheadline(with: 0 + ((offset.y - 130) / 100))
//            }
//        }
//        return section
//    }
//
//    private func createDailySection(using: Section, and layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
//        var configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
//        configuration.separatorConfiguration.color = .white
//        configuration.separatorConfiguration.bottomSeparatorInsets = NSDirectionalEdgeInsets(
//            top: 0,
//            leading: 16,
//            bottom: 0,
//            trailing: 16
//        )
//        configuration.backgroundColor = .clear
//
//        let section = NSCollectionLayoutSection.list(
//            using: configuration,
//            layoutEnvironment: layoutEnvironment
//        )
//        section.contentInsets = NSDirectionalEdgeInsets(
//            top: 0,
//            leading: 16,
//            bottom: 0,
//            trailing: 16
//        )
//
//        let sectionHeader = createSectionHeader()
//        section.boundarySupplementaryItems = [sectionHeader]
//
//        let backgroundView = createBackgroundView()
//        section.decorationItems = [backgroundView]
//
//        return section
//    }
//
//    private func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
//        let headerSize = NSCollectionLayoutSize(
//            widthDimension: .fractionalWidth(1.0),
//            heightDimension: .estimated(36)
//        )
//        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
//            layoutSize: headerSize,
//            elementKind: SectionHeader.reuseIdentifier,
//            alignment: .topLeading
//        )
//        return sectionHeader
//    }
//
//    private func createGlobalHeader(withKind headerKind: String) -> NSCollectionLayoutBoundarySupplementaryItem {
//        let globalHeaderSize = NSCollectionLayoutSize(
//            widthDimension: .fractionalWidth(1.0),
//            heightDimension: .estimated(300)
//        )
//        let globalHeader = NSCollectionLayoutBoundarySupplementaryItem(
//            layoutSize: globalHeaderSize,
//            elementKind: headerKind,
//            alignment: .top
//        )
//        globalHeader.pinToVisibleBounds = true
//        return globalHeader
//    }
//
//    private func createGlobalFooter(withKind footerKind: String) -> NSCollectionLayoutBoundarySupplementaryItem {
//        let globalFooterSize = NSCollectionLayoutSize(
//            widthDimension: .fractionalWidth(1.0),
//            heightDimension: .estimated(200)
//        )
//        let globalFooter = NSCollectionLayoutBoundarySupplementaryItem(
//            layoutSize: globalFooterSize,
//            elementKind: footerKind,
//            alignment: .bottom
//        )
//        return globalFooter
//    }
//
//    private func createBackgroundView() -> NSCollectionLayoutDecorationItem {
//        let topInset: CGFloat = 0
//        let sideInset: CGFloat = 16
//        let backgroundItem = NSCollectionLayoutDecorationItem.background(
//            elementKind: SectionBackgroundView.reuseIdentifier
//        )
//        backgroundItem.contentInsets = NSDirectionalEdgeInsets(
//            top: topInset,
//            leading: sideInset,
//            bottom: topInset,
//            trailing: sideInset
//        )
//        return backgroundItem
//    }
//}
