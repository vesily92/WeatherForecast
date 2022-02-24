//
//  HourlyForecastViewController.swift
//  WeatherForecast
//
//  Created by Василий Пронин on 23.02.2022.
//

import UIKit

class HourlyForecastViewController: UIViewController {
    
    enum HourlySection: Int, CaseIterable {
        case weather
        case sunrise
        case sunset
    }
    
    let hourlyForecasts = Bundle.main.decode([Hourly].self, from: "HourlyJSON.json")
    let sunriseTime = Bundle.main.decode([Current].self, from: "CurrentJSON.json")
    let sunsetTime = Bundle.main.decode([Current].self, from: "CurrentJSON.json")
    
    var hourlyForecastCollectionView: UICollectionView!
    
    var dataSource: UICollectionViewDiffableDataSource<HourlySection, AnyHashable>?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionView()
        createDataSource()
        reloadData()
    }
    
    private func setupCollectionView() {
        hourlyForecastCollectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionalLayout())
        hourlyForecastCollectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(hourlyForecastCollectionView)
    }
    
    private func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            guard let section = HourlySection(rawValue: sectionIndex) else {
                fatalError("Unknown section kind")
            }
            return self.createSection(using: section)
        }
        
        return layout
    }
    
    private func configure<T: SelfConfiguringCell>(_ cellType: T.Type, with model: AnyHashable, for indexPath: IndexPath) -> T {
        guard let cell = hourlyForecastCollectionView.dequeueReusableCell(
            withReuseIdentifier: cellType.reuseIdentifier,
            for: indexPath
        ) as? T else {
            fatalError("Unable to dequeue \(cellType)")
        }
        
        cell.configure(with: model)
        return cell
    }
    
    private func createDataSource() {
        dataSource = UICollectionViewDiffableDataSource<HourlySection, AnyHashable>(collectionView: hourlyForecastCollectionView, cellProvider: { collectionView, indexPath, forecast in
            guard let section = HourlySection(rawValue: indexPath.section) else {
                fatalError("Unknown section kind")
            }
            switch section {
            case .weather:
                return self.configure(HourlyForecastCell.self, with: forecast, for: indexPath)
            case .sunrise:
                return self.configure(SunriseCell.self, with: forecast, for: indexPath)
            case .sunset:
                return self.configure(SunsetCell.self, with: forecast, for: indexPath)
            }
        })
    }
    
    private func reloadData() {
        var snapshot = NSDiffableDataSourceSnapshot<HourlySection, AnyHashable>()
        snapshot.appendSections([.weather, .sunrise, .sunset])
        snapshot.appendItems(hourlyForecasts, toSection: .weather)
        snapshot.appendItems(sunriseTime, toSection: .sunrise)
        snapshot.appendItems(sunsetTime, toSection: .sunset)
        dataSource?.apply(snapshot)
        
    }
    
    private func createSection(using: HourlySection) -> NSCollectionLayoutSection {
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
//        section.contentInsets = NSDirectionalEdgeInsets(
//            top: 0,
//            leading: sectionInsetX,
//            bottom: sectionInsetY,
//            trailing: sectionInsetX)
        
        return section
    }
}
