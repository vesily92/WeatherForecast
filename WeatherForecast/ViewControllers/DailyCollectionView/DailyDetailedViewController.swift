//
//  DailyDetailedViewController.swift
//  WeatherForecast
//
//  Created by Василий Пронин on 29.06.2022.
//

import UIKit

class DailyDetailedViewController: UIViewController, Coordinatable {
    
    private enum DailyDetailedVCSections: Int, CaseIterable {
        case main
    }
    
    private typealias DataSource = UICollectionViewDiffableDataSource<DailyDetailedVCSections, AnyHashable>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<DailyDetailedVCSections, AnyHashable>
    
    var coordinator: Coordinator?
    
    private var collectionView: UICollectionView!
    private var dataSource: DataSource?
    private var forecastData: ForecastData? {
        didSet {
            dataSource?.apply(makeSnapshot(), animatingDifferences: false)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        NetworkManager.shared.fetchOneCallData(withLatitude: 59.9311, longitude: 30.3609) { forecastData in
            self.forecastData = forecastData
        }
        setupNavBar()
        setupCollectionView()
        createDataSouce()
    }
    
    private func setupNavBar() {
        let navBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 44))
        let navItem = UINavigationItem(title: "7-Day Forecast")
        let dismissButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.close, target: self, action: nil)
        navItem.rightBarButtonItem = dismissButton
        navBar.setItems([navItem], animated: false)
        view.addSubview(navBar)
    }
    
    private func setupCollectionView() {
        collectionView = UICollectionView(
            frame: view.bounds,
            collectionViewLayout: createCompositionalLayout()
        )
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .darkGray
        view.addSubview(collectionView)
        
        collectionView.register(
            DailyDetailedCollectionViewCell.self,
            forCellWithReuseIdentifier: DailyDetailedCollectionViewCell.reuseIdentifier
        )
    }
    
    private func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnv in
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
        return layout
    }
    
    private func createDataSouce() {
        dataSource = DataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, forecast in
            guard let section = DailyDetailedVCSections(rawValue: indexPath.section) else {
                fatalError("Unknown section kind")
            }
            switch section {
            case .main:
                guard let cell = self.collectionView.dequeueReusableCell(
                    withReuseIdentifier: DailyDetailedCollectionViewCell.reuseIdentifier,
                    for: indexPath
                ) as? DailyDetailedCollectionViewCell else {
                    fatalError("Unable to dequeue DailyDetailedCollectionViewCell")
                }
                cell.coordinator = self.coordinator
                cell.configure(with: forecast)
                return cell
            }
        })
    }
    
    private func makeSnapshot() -> Snapshot {
        var snapshot = Snapshot()
        
        guard let forecastData = forecastData else {
            fatalError()
        }
        let forecasts = Array(repeating: forecastData, count: 1)
        
        snapshot.appendSections(DailyDetailedVCSections.allCases)
        snapshot.appendItems(forecasts, toSection: .main)
        
        return snapshot
    }
}

