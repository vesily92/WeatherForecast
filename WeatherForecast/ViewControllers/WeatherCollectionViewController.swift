//
//  WeatherCollectionViewController.swift
//  WeatherForecast
//
//  Created by Василий Пронин on 26.03.2022.
//

import UIKit
import SwiftUI

private let reuseIdentifier = "Cell"

class WeatherCollectionViewController: UICollectionViewController {
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, AnyHashable>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable>
    
    private let symbolConfig = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 14))

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        createCompositionalLayout()
        registerCells()
        // Do any additional setup after loading the view.
    }
    
    private func registerCells() {
        collectionView.register(
            HourlyForecastCell.self,
            forCellWithReuseIdentifier: HourlyForecastCell.reuseIdentifier
        )
        collectionView.register(
            DailyForecastCell.self,
            forCellWithReuseIdentifier: DailyForecastCell.reuseIdentifier
        )
        collectionView.register(
            CurrentWeatherHeader.self,
            forSupplementaryViewOfKind: CurrentWeatherHeader.reuseIdentifier,
            withReuseIdentifier: CurrentWeatherHeader.reuseIdentifier
        )
        collectionView.register(
            SectionHeader.self,
            forSupplementaryViewOfKind: SectionHeader.reuseIdentifier,
            withReuseIdentifier: SectionHeader.reuseIdentifier
        )
    }
    
    private func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            guard let section = Section(rawValue: sectionIndex) else {
                fatalError("Unknown section kind")
            }
            switch section {
            case .hourly:
                return self.createHourlySection(using: section)
            case .daily:
                return self.createDailySection(using: section, and: layoutEnvironment)
            }
        }
        let globalCurrentWeatherHeader = createGlobalHeader(
            using: CurrentWeatherHeader.reuseIdentifier
        )
        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        configuration.boundarySupplementaryItems = [globalCurrentWeatherHeader]
        
        layout.configuration = configuration
        layout.register(
            BackgroundSupplementaryView.self,
            forDecorationViewOfKind: BackgroundSupplementaryView.reuseIdentifier
        )
        return layout
    }
    
    private func configure<T: SelfConfiguringCell>(_ cellType: T.Type,
                                                   with model: AnyHashable,
                                                   for indexPath: IndexPath) -> T {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: cellType.reuseIdentifier,
            for: indexPath
        ) as? T else {
            fatalError("Unable to dequeue \(cellType)")
        }
        cell.configure(with: model)
        return cell
    }
    
    private func createDataSouce() -> DataSource {
        let dataSource = DataSource(collectionView: collectionView) { collectionView, indexPath, model in
            guard let section = Section(rawValue: indexPath.section) else {
                fatalError("Unknown section kind")
            }
            switch section {
            case .hourly:
                return self.configure(HourlyForecastCell.self, with: model, for: indexPath)
            case .daily:
                return self.configure(DailyForecastCell.self, with: model, for: indexPath)
            }
        }
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            switch kind {
            case CurrentWeatherHeader.reuseIdentifier:
                guard let globalHeader = collectionView.dequeueReusableSupplementaryView(
                    ofKind: CurrentWeatherHeader.reuseIdentifier,
                    withReuseIdentifier: CurrentWeatherHeader.reuseIdentifier,
                    for: indexPath
                ) as? CurrentWeatherHeader else {
                    fatalError("Unable to dequeue supplementary view with \(kind) identifier")
                }
                // networking
                return globalHeader
            default:
                guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(
                    ofKind: SectionHeader.reuseIdentifier,
                    withReuseIdentifier: SectionHeader.reuseIdentifier,
                    for: indexPath
                ) as? SectionHeader else {
                    fatalError("Unable to dequeue supplementary view with \(kind) identifier")
                }
                guard let section = Section(rawValue: indexPath.section) else {
                    fatalError("Unknown section kind")
                }
                switch section {
                case .hourly:
                    sectionHeader.symbolView.image = UIImage(
                        systemName: section.sectionSystemIcon,
                        withConfiguration: self.symbolConfig
                    )
                    sectionHeader.titleLabel.text = section.sectionName.uppercased()
                case .daily:
                    sectionHeader.symbolView.image = UIImage(
                        systemName: section.sectionSystemIcon,
                        withConfiguration: self.symbolConfig
                    )
                    sectionHeader.titleLabel.text = section.sectionName.uppercased()
                }
                return sectionHeader
            }
        }
        return dataSource
    }
    
    private func createGlobalHeader(using kind: String) -> NSCollectionLayoutBoundarySupplementaryItem {
        let globalHeaderSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(250)
        )
        let globalHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: globalHeaderSize,
            elementKind: kind,
            alignment: .top
        )
        globalHeader.pinToVisibleBounds = true
        return globalHeader
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
        
        let sectionHeader = createSectionHeader(
            using: SectionHeader.reuseIdentifier
        )
        section.boundarySupplementaryItems = [sectionHeader]
        section.supplementariesFollowContentInsets = false
        
        let decorationItem = createBackgroundDecorationItem(
            using: BackgroundSupplementaryView.reuseIdentifier
        )
        section.decorationItems = [decorationItem]
        
        return section
    }
    
    private func createDailySection(using section: Section,
                                    and layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        var configuration = UICollectionLayoutListConfiguration(appearance: .sidebar)
        configuration.separatorConfiguration.topSeparatorVisibility = .visible
        configuration.separatorConfiguration.bottomSeparatorInsets.leading = 0
        configuration.separatorConfiguration.color = .systemGray4
        configuration.backgroundColor = .clear
        
        let section = NSCollectionLayoutSection.list(
            using: configuration,
            layoutEnvironment: layoutEnvironment
        )
        
        let sectionHeader = createSectionHeader(
            using: SectionHeader.reuseIdentifier
        )
        section.boundarySupplementaryItems = [sectionHeader]
        section.supplementariesFollowContentInsets = false
        
        let decorationItem = createBackgroundDecorationItem(
            using: BackgroundSupplementaryView.reuseIdentifier
        )
        section.decorationItems = [decorationItem]
        return section
    }
    
    private func createSectionHeader(using kind: String) -> NSCollectionLayoutBoundarySupplementaryItem {
        let sectionHeaderSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(32)
        )
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: sectionHeaderSize,
            elementKind: kind,
            alignment: .topLeading
        )
        sectionHeader.pinToVisibleBounds = true
        return sectionHeader
    }
    
    private func createBackgroundDecorationItem(using kind: String) -> NSCollectionLayoutDecorationItem {
        let topInset: CGFloat = 8
        let leadingInset: CGFloat = 0
        let decorationItem = NSCollectionLayoutDecorationItem.background(
            elementKind: kind
        )
        decorationItem.contentInsets = NSDirectionalEdgeInsets(
            top: topInset,
            leading: leadingInset,
            bottom: topInset,
            trailing: leadingInset
        )
        return decorationItem
    }
    

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
    
        // Configure the cell
    
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
