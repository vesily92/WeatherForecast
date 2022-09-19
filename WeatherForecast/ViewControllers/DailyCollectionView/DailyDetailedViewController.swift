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
 
    var coordinator: Coordinator?
    var forecastData: ForecastData? {
        didSet {
            dataSource?.apply(makeSnapshot(), animatingDifferences: false)
            print("snapshot!")
        }
    }
    var currentIndex: Int = 0 {
        didSet {
            print("currentIndex: \(currentIndex)")
        }
    }
    
    private var collectionView: UICollectionView! {
        didSet {
            print("collectionView initialised")
        }
    }
    private var dataSource: DataSource? {
        didSet {
//            moveToTab(at: currentIndex)
            print("dataSource initialised")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
//        moveToTab(at: currentIndex)

        setupCollectionView()
        createDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        switchTheDay(by: currentIndex)
        scrollThePage(to: currentIndex)
    }
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//
//        moveToTab(at: currentIndex)
//    }
    
    func switchTheDay(by index: Int) {
//        collectionView.scrollToItem(
//            at: IndexPath(item: index, section: 0),
//            at: .centeredHorizontally,
//            animated: false
//        )
//        collectionView.scrollToItem(
//            at: IndexPath(item: index, section: 1),
//            at: [.centeredHorizontally, .centeredVertically],
//            animated: true
//        )
        guard let cell = collectionView.cellForItem(at: IndexPath(
            item: index,
            section: 0)
        ) as? DayPickerCell else { return }
        
        
        cell.isSelected = true
        
//        select(cell: DayPickerCell.self, by: index)
        
//        currentIndex = index
    }
    
    func scrollThePage(to index: Int) {
        collectionView.scrollToItem(
            at: IndexPath(item: index, section: 1),
            at: [.centeredHorizontally, .centeredVertically],
            animated: true
        )
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
    
    private func createDataSource() {
        dataSource = DataSource(collectionView: collectionView, cellProvider: { [weak self] collectionView, indexPath, forecast in
            guard let section = DailyDetailedVCSection(rawValue: indexPath.section) else {
                fatalError("Unknown section kind")
            }
            switch section {
            case .dayPicker:
                guard let cell = self?.collectionView.dequeueReusableCell(
                    withReuseIdentifier: DayPickerCell.reuseIdentifier,
                    for: indexPath
                ) as? DayPickerCell else {
                    fatalError("Unable to dequeue DayPickerCell")
                }
                cell.configure(with: forecast.details)
                return cell
            case .meteoInfo:
                guard let cell = self?.collectionView.dequeueReusableCell(
                    withReuseIdentifier: DailyDetailedCollectionViewCell.reuseIdentifier,
                    for: indexPath
                ) as? DailyDetailedCollectionViewCell else {
                    fatalError("Unable to dequeue DailyDetailedCollectionViewCell")
                }
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
            sectionHeader.configure(with: Section.daily)
            return sectionHeader
        }
        
        dataSource?.apply(makeSnapshot())
    }
    
    private func makeSnapshot() -> Snapshot {
        var snapshot = Snapshot()
        
        guard let forecastData = forecastData else {
            fatalError()
        }

        snapshot.appendSections(DailyDetailedVCSection.allCases)
//        snapshot.appendItems([CategorisedDailyVCItems(details: forecastData.daily[currentIndex], category: .dayPicker)], toSection: .dayPicker)
//        snapshot.appendItems([CategorisedDailyVCItems(details: forecastData.daily[currentIndex], category: .meteoInfo)], toSection: .meteoInfo)
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
        section.orthogonalScrollingBehavior = .groupPaging
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
//        section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
        section.orthogonalScrollingBehavior = .groupPagingCentered
        
        section.visibleItemsInvalidationHandler = { items, offset, _ in
            print(offset.y)
            
            let page = Int(offset.x / self.collectionView.frame.size.width)
            print(page)
            self.switchTheDay(by: page)
        }
        
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
    
    
    
    
    
    func select<T: UICollectionViewCell>(cell: T, by index: Int, _ isSelected: Bool = false) {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: cell.reuseIdentifier!,
            for: IndexPath(item: index, section: 0)
        ) as? T else {
            fatalError("Unable to dequeue \(cell)")
        }
        cell.isSelected = isSelected
    }
}

extension DailyDetailedViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switchTheDay(by: indexPath.item)
        scrollThePage(to: indexPath.item)
        
//        guard let cell = collectionView.cellForItem(at: indexPath) as? DayPickerCell else { return }
//
//        cell.isSelected = true
        
//        print(collectionView.visibleCells)
//        let dayIndexPath = IndexPath(item: indexPath.item, section: 0)
//        let meteoIndexPath = IndexPath(item: indexPath.item, section: 1)
//        collectionView.scrollToItem(at: dayIndexPath, at: .centeredHorizontally, animated: true)
//        collectionView.scrollToItem(at: meteoIndexPath, at: .centeredHorizontally, animated: true)
//        self.moveToTab(at: indexPath.item)
//        self.delegate?.didMoveToTab(at: indexPath.item)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? DayPickerCell {
            cell.isSelected = false
        }
    }
    
    
//    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        guard let cell = collectionView.cellForItem(at: indexPath) as? DailyDetailedCollectionViewCell else { return }
//        
//        
//    }
    
//    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
//        if let cell = collectionView.cellForItem(at: indexPath) as? DayPickerCell {
//            cell.highlightCell()
//        }
//    }

    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? DayPickerCell {
            cell.isSelected = false
        }
    }
}
