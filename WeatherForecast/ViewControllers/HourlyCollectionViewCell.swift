//
//  HourlyCollectionViewCell.swift
//  WeatherForecast
//
//  Created by Василий Пронин on 22.04.2022.
//

import UIKit
import SwiftUI

class HourlyCollectionViewCell: UICollectionViewCell, SelfConfiguringCell {
    static let reuseIdentifier = "HourlyCollectionViewCell"
    
    private var collectionView: UICollectionView!
    private var forecastData: ForecastData?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.estimatedItemSize = CGSize(width: 60, height: 120)
        
        collectionView = UICollectionView(
            frame: contentView.bounds,
            collectionViewLayout: layout
        )
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(collectionView)
        
        collectionView.register(
            HourlyForecastCell.self,
            forCellWithReuseIdentifier: HourlyForecastCell.reuseIdentifier
        )
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with forecast: AnyHashable, andTimezoneOffset: Int) {
        guard let forecast = forecast as? ForecastData else { return }
        self.forecastData = forecast
        collectionView.reloadData()
    }
}

extension HourlyCollectionViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        27
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HourlyForecastCell.reuseIdentifier, for: indexPath) as? HourlyForecastCell else {
            fatalError("Unable to dequeue cell")
        }
        
        guard let forecastData = forecastData else {
            return cell
        }
        
//        let hourlyIndices = getIndices(for: .hourly)
        let sunriseIndices = getIndices(for: .sunrise)
        let sunsetIndices = getIndices(for: .sunset)
        
//        let difference = hourlyIndices[indexPath.item] - indexPath.item
        
        if indexPath.item == 0 {
            let currentData = forecastData.current
            cell.configure(with: currentData, andTimezoneOffset: forecastData.timezoneOffset)
            return cell
            
        } else if sunriseIndices.contains(indexPath.item) {
            cell.isSunrise = true
            
            if sunriseIndices.first == indexPath.item {
                let dailyData = forecastData.daily[0]
                cell.configure(with: dailyData, andTimezoneOffset: forecastData.timezoneOffset)
                
            } else {
                let dailyData = forecastData.daily[1]
                cell.configure(with: dailyData, andTimezoneOffset: forecastData.timezoneOffset)
            }
            return cell
            
        } else if sunsetIndices.contains(indexPath.item) {
            cell.isSunrise = false
            
            if sunsetIndices.first == indexPath.item {
                let dailyData = forecastData.daily[0]
                cell.configure(with: dailyData, andTimezoneOffset: forecastData.timezoneOffset)
                
            } else {
                let dailyData = forecastData.daily[1]
                cell.configure(with: dailyData, andTimezoneOffset: forecastData.timezoneOffset)
            }
            return cell
            
        } else {
            let hourlyData = forecastData.hourly[indexPath.item]
            cell.configure(with: hourlyData, andTimezoneOffset: forecastData.timezoneOffset)
            return cell
        }
    }
}

extension HourlyCollectionViewCell {
    
    private enum CellType {
        case hourly
        case sunrise
        case sunset
    }
    
    private func getTimeArray(for cellType: CellType) -> [Int] {
        switch cellType {
        case .hourly:
            var hourlyTime: [Int] = []
            forecastData?.hourly.forEach { hourly in
                hourlyTime.append(hourly.dt)
            }
            return hourlyTime
        case .sunrise:
            var sunriseTime: [Int] = []
            forecastData?.daily.forEach { daily in
                sunriseTime.append(daily.sunrise)
            }
            return sunriseTime
        case .sunset:
            var sunsetTime: [Int] = []
            forecastData?.daily.forEach { daily in
                sunsetTime.append(daily.sunset)
            }
            return sunsetTime
        }
    }
    
    private func getTotalTimeArray() -> [Int] {
        let hourlyTime = getTimeArray(for: .hourly)
        let sunriseTime = getTimeArray(for: .sunrise)
        let sunsetTime = getTimeArray(for: .sunset)
        var time: [Int] = []
        
        time.append(contentsOf: hourlyTime)
        
        if sunriseTime.first! <= hourlyTime.first! {
            time.append(contentsOf: sunriseTime.prefix(2).dropFirst())
        } else {
            time.append(contentsOf: sunriseTime.prefix(2))
        }
        if sunsetTime.first! <= hourlyTime.first! {
            time.append(contentsOf: sunsetTime.prefix(2).dropFirst())
        } else {
            time.append(contentsOf: sunsetTime.prefix(2))
        }
        return time.sorted(by: <)
    }
    
    private func getSortedTimeArray(with sunriseTime: [Int], _ sunsetTime: [Int]) -> [Int] {
        let currentTime = forecastData?.current.dt
        var sortedTime = getTotalTimeArray()
        var offset = 0

        sortedTime.forEach { time in
            let index = sortedTime.firstIndex(where: { $0 == time }) ?? 0
            if time <= currentTime! {
                sortedTime.remove(at: index)
            }
            if sunriseTime.contains(time) {
                sortedTime.swapAt(index, index - offset)
                offset += 1
            }
            if sunsetTime.contains(time) {
                sortedTime.swapAt(index, index - offset)
                offset += 1
            }
        }
        return sortedTime
    }
    
    private func getIndices(for cellType: CellType) -> [Int] {
        let hourlyTime = getTimeArray(for: .hourly)
        let sunriseTime = getTimeArray(for: .sunrise)
        let sunsetTime = getTimeArray(for: .sunset)
        let sortedTime = getSortedTimeArray(with: sunriseTime, sunsetTime)

        switch cellType {
        case .hourly:
            return sortedTime.enumerated().filter { hourlyTime.contains($0.element)}.map { $0.offset }
        case .sunrise:
            return sortedTime.enumerated().filter { sunriseTime.contains($0.element)}.map { $0.offset }
        case .sunset:
            return sortedTime.enumerated().filter { sunsetTime.contains($0.element)}.map { $0.offset }
        }
    }
}

