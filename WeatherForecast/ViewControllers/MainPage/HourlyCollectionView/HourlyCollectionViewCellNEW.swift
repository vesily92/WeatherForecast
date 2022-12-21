//
//  HourlyCollectionViewCellNEW.swift
//  WeatherForecast
//
//  Created by Василий Пронин on 16.12.2022.
//

import UIKit

class HourlyCollectionViewCellNEW: UICollectionViewCell, SelfConfigurable {
    static let reuseIdentifier = "HourlyCollectionViewCell"
    
    private var collectionView: UICollectionView!
    private var forecastData: ForecastData? { didSet { insert() } }
    private lazy var hourly = forecastData!.hourly
    private lazy var daily = forecastData!.daily.prefix(2)
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.estimatedItemSize = CGSize(width: 60, height: 120)
        
        collectionView = UICollectionView(
            frame: CGRect(
                x: 16,
                y: 0,
                width: contentView.bounds.width - 32,
                height: contentView.bounds.height
            ),
            collectionViewLayout: layout
        )
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        
        contentView.addSubview(collectionView)
        
        collectionView.register(
            HourlyCell.self,
            forCellWithReuseIdentifier: HourlyCell.reuseIdentifier
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with forecast: AnyHashable, tzOffset: Int?) {
        guard let forecast = forecast as? ForecastData else { return }
        self.forecastData = forecast
        collectionView.reloadData()
    }
}

extension HourlyCollectionViewCellNEW: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        27
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HourlyCell.reuseIdentifier, for: indexPath) as? HourlyCell else {
            fatalError("Unable to dequeue cell")
        }
        
        guard let forecastData = forecastData else {
            return cell
        }
        let sunriseIndices = getIndices(for: .sunrise)
        let sunsetIndices = getIndices(for: .sunset)
        
        switch indexPath.item {
        case 0:
            let currentData = forecastData.current
            cell.configure(with: currentData, tzOffset: forecastData.timezoneOffset)
            return cell
            
        case sunriseIndices.first:
            let dailyData = forecastData.daily[0]
            cell.isSunrise = true
            cell.configure(with: dailyData, tzOffset: forecastData.timezoneOffset)
            return cell
            
        case sunriseIndices.last:
            let dailyData = forecastData.daily[1]
            cell.isSunrise = true
            cell.configure(with: dailyData, tzOffset: forecastData.timezoneOffset)
            return cell
            
        case sunsetIndices.first:
            let dailyData = forecastData.daily[0]
            cell.isSunrise = false
            cell.configure(with: dailyData, tzOffset: forecastData.timezoneOffset)
            return cell
            
        case sunsetIndices.last:
            let dailyData = forecastData.daily[1]
            cell.isSunrise = false
            cell.configure(with: dailyData, tzOffset: forecastData.timezoneOffset)
            return cell
            
        default:
            let hourlyData = hourly[indexPath.item]
            cell.configure(with: hourlyData, tzOffset: forecastData.timezoneOffset)
            return cell
        }
    }
}

extension HourlyCollectionViewCellNEW {
    
    private enum CellType {
        case hourly
        case sunrise
        case sunset
        case sunriseSunset
    }
    
    private func getTimeArray(for cellType: CellType) -> [Int] {
        switch cellType {
        case .hourly:
            var hourlyTime = [Int]()
            forecastData?.hourly.forEach { hourly in
                hourlyTime.append(hourly.dt)
            }
            return hourlyTime
        case .sunrise:
            var sunriseTime = [Int]()
            daily.forEach { daily in
                sunriseTime.append(daily.sunrise)
            }
            return sunriseTime
        case .sunset:
            var sunsetTime = [Int]()
            daily.forEach { daily in
                sunsetTime.append(daily.sunset)
            }
            return sunsetTime
        case .sunriseSunset:
            var sunTime = [Int]()
            daily.forEach { daily in
                sunTime.append(daily.sunrise)
                sunTime.append(daily.sunset)
            }
            return sunTime.sorted(by: <)
        }
    }
    
    private func getTotalTimeArray() -> [Int] {
        let hourlyTime = getTimeArray(for: .hourly)
        let sunTime = getTimeArray(for: .sunriseSunset)
        var time: [Int] = []
        time.append(contentsOf: hourlyTime)

        if sunTime.first! <= hourlyTime.first! {
            time.append(contentsOf: sunTime.prefix(4).dropFirst())
        } else {
            time.append(contentsOf: sunTime.prefix(4))
        }
        
        return time.sorted(by: <)
    }
    
    private func getIndices(for cellType: CellType) -> [Int] {
        let sortedTime = getTotalTimeArray()
        switch cellType {
        case .hourly:
            let hourlyTime = getTimeArray(for: .hourly)
            return sortedTime.enumerated()
                .filter { hourlyTime.contains($0.element)}
                .map { $0.offset }
            
        case .sunrise:
            let sunriseTime = getTimeArray(for: .sunrise)
            return sortedTime.enumerated()
                .filter { sunriseTime.contains($0.element)}
                .map { $0.offset }
            
        case .sunset:
            let sunsetTime = getTimeArray(for: .sunset)
            return sortedTime.enumerated()
                .filter { sunsetTime.contains($0.element)}
                .map { $0.offset }
            
        case .sunriseSunset:
            let sunTime = getTimeArray(for: .sunriseSunset)
            return sortedTime.enumerated()
                .filter { sunTime.contains($0.element)}
                .map { $0.offset }
        }
    }
    
    private func insert() {
        guard let dummy = hourly.first else { return }
        let indices = getIndices(for: .sunriseSunset)

        indices.forEach { index in
            hourly.insert(dummy, at: index)
        }
    }
}


