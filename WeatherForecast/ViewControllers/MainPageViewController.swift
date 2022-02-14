//
//  MainPageViewController.swift
//  WeatherForecast
//
//  Created by Василий Пронин on 08.02.2022.
//

import UIKit

class MainPageViewController: UIViewController {
    
    enum Section: Int, CaseIterable, Hashable {
        case currentWeather //, hourlyForecast, dailyForecast
    }
    
    var weatherCollectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, [AnyHashable]>!
    
    private var currentForecasts: [CurrentWeather] = []
    //private var hourlyForecasts: [HourlyForecast] = []
    //private var dailyForecasts: [DailyForecast] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weatherCollectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionalLayout())
        weatherCollectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        weatherCollectionView.backgroundColor = .systemBackground
        view.addSubview(weatherCollectionView)
        
        weatherCollectionView.register(CurrentWeatherCell.self, forCellWithReuseIdentifier: CurrentWeatherCell.reuseIdentifier)
//        createDataSource()
    }
    
    
//    private func configure<T: SelfConfiguringCell>(_ cellType: T.Type, with hashable: AnyHashable, for indexPath: IndexPath) -> T {
//        guard let cell = weatherCollectionView.dequeueReusableCell(withReuseIdentifier: cellType.reuseIdentifier, for: indexPath) as? T else {
//            fatalError("Unable to dequeue \(cellType)")
//        }
//        guard let model = hashable as? T.DataType else {
//            fatalError()
//        }
//        cell.configure(with: model)
//        return cell
//    }
    
//    private func createDataSource() {
//        dataSource = UICollectionViewDiffableDataSource<Section, [AnyHashable]>(collectionView: weatherCollectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
//            let sections = Section.allCases
//            switch sections[indexPath.section] {
//
//            case .currentWeather: return self.configure(CurrentWeatherCell.self, with: itemIdentifier, for: indexPath)
//            }
//        })
//    }
    
//    private func reloadData() {
//        let sections = Section.allCases
//        var snapShot = NSDiffableDataSourceSnapshot<Section, AnyHashable>()
//        snapShot.appendSections(sections)
//
//        for section in sections {
//            snapShot.appendItems(currentForecasts, toSection: section)
//        }
//    }
    
    private func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            let section = Section.allCases[sectionIndex]
            
            switch section {
            case .currentWeather: return self.createCurrentWeatherSection(using: section)
//            case .hourlyForecast: return
//            case .dailyForecast: return
            }
        }
        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        layout.configuration = configuration
        return layout
    }
    
    private func createCurrentWeatherSection(using section: Section) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
    
}
