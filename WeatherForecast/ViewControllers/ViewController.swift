//
//  ViewController.swift
//  WeatherForecast
//
//  Created by Василий Пронин on 11.02.2022.
//

import UIKit

//enum Item: Hashable {
//    var identifier: UUID {
//        return UUID()
//    }
//    static func == (lhs: Item, rhs: Item) -> Bool {
//        return lhs.identifier == rhs.identifier
//    }
//
//    func hash(into hasher: inout Hasher) {
//        hasher.combine(identifier)
//    }
//
//    case currentWeather(Current.DiffableNow)
//    case hourlyForecast(Current.DiffableHourly)
//    case dailyForecast(Daily.Diffable)
//}

//enum Section: Hashable {
//    var identifier: UUID {
//        return UUID()
//    }
//    static func == (lhs: Section, rhs: Section) -> Bool {
//        return lhs.identifier == rhs.identifier
//    }
//
//    func hash(into hasher: inout Hasher) {
//        hasher.combine(identifier)
//    }
//    case item([Item])
//}

class ViewController: UIViewController {
    
    //спарсить структуру ForecastData и достать секции из неё
    //попытаться наполнить массивы с данными через NetworkManager
    
    
    
    //let sections = Bundle.main.decode([ForecastData].self, from: "https://api.openweathermap.org/data/2.5/onecall?lat=33.44&lon=-94.04&exclude=current,minutely,daily,alerts&appid=\(apiKey)&units=metric")
    
    enum Section: Int, CaseIterable {
        case current
        case hourly
        case daily
    }
    
    let currentForecasts = Bundle.main.decode([Current].self, from: "CurrentJSON.json")
    let hourlyForecasts = Bundle.main.decode([Hourly].self, from: "HourlyJSON.json")
    var dailyForecasts = Bundle.main.decode([Daily].self, from: "DailyJSON.json")
    
    var dataSource: UICollectionViewDiffableDataSource<Section, AnyHashable>?
    
    var weatherCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        
        weatherCollectionView.register(CurrentWeatherCell.self, forCellWithReuseIdentifier: CurrentWeatherCell.reuseIdentifier)
        weatherCollectionView.register(HourlyForecastCell.self, forCellWithReuseIdentifier: HourlyForecastCell.reuseIdentifier)
        weatherCollectionView.register(DailyForecastCell.self, forCellWithReuseIdentifier: DailyForecastCell.reuseIdentifier)
        
//        NetworkManager.shared.fetchHourly(latitude: 33.44, longitude: -94.04) { result in
//            switch result {
//            case .success(let forecast):
//                self.dailyForecasts.append(forecast)
//            case .failure(let error):
//                print(error)
//            }
//        }

        createDataSource()
        reloadData()
    }
    
    private func setupCollectionView() {
        weatherCollectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionalLayout())
        weatherCollectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        weatherCollectionView.backgroundColor = .systemBlue
        view.addSubview(weatherCollectionView)
    }
    
    private func configure<T: SelfConfiguringCell>(_ cellType: T.Type, with model: AnyHashable, for indexPath: IndexPath) -> T {
        guard let cell = weatherCollectionView.dequeueReusableCell(withReuseIdentifier: cellType.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Unable to dequeue \(cellType)")
        }
        
        cell.configure(with: model)
        return cell
    }
    
    private func createDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, AnyHashable>(collectionView: weatherCollectionView, cellProvider: { collectionView, indexPath, forecast in
            guard let section = Section(rawValue: indexPath.section) else {
                fatalError("Unknown section kind")
            }

            switch section {
            case .current:
                return self.configure(CurrentWeatherCell.self, with: forecast, for: indexPath)
            case .hourly:
                return self.configure(HourlyForecastCell.self, with: forecast, for: indexPath)
            case .daily:
                return self.configure(DailyForecastCell.self, with: forecast, for: indexPath)
            }
        })
    }

    private func reloadData() {
        var snapshot = NSDiffableDataSourceSnapshot<Section,AnyHashable>()
        snapshot.appendSections([.current, .hourly, .daily])
        snapshot.appendItems(currentForecasts, toSection: .current)
        snapshot.appendItems(hourlyForecasts, toSection: .hourly)
        snapshot.appendItems(dailyForecasts, toSection: .daily)
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    private func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(86))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(1))
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            return section
        }
        return layout
    }
    
}
