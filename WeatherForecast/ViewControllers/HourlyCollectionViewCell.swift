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
    
    private var hourlyCollectionView: UICollectionView!
    private var forecastData: ForecastData?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.estimatedItemSize = CGSize(width: 60, height: 120)
        
        hourlyCollectionView = UICollectionView(
            frame: contentView.bounds,
            collectionViewLayout: layout
        )
        hourlyCollectionView.backgroundColor = .clear
        hourlyCollectionView.showsHorizontalScrollIndicator = false
        hourlyCollectionView.delegate = self
        hourlyCollectionView.dataSource = self
        hourlyCollectionView.register(
            HourlyForecastCell.self,
            forCellWithReuseIdentifier: HourlyForecastCell.reuseIdentifier
        )

        hourlyCollectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentView.addSubview(hourlyCollectionView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with forecast: AnyHashable, andTimezoneOffset: Int) {
        guard let forecast = forecast as? ForecastData else { return }
        self.forecastData = forecast
        hourlyCollectionView.reloadData()
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
        guard let forecastData = forecastData else {
            fatalError("No data")
        }
        
        let hourlyIndices = getIndices(for: .hourly)
        let sunriseIndices = getIndices(for: .sunrise)
        let sunsetIndices = getIndices(for: .sunset)
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HourlyForecastCell.reuseIdentifier, for: indexPath) as? HourlyForecastCell else {
            fatalError("Unable to dequeue cell")
        }
        
        let item = indexPath.item
        
        var index = indexPath.item
        
        let difference = hourlyIndices[item] - item
        
        if item == 0 {
            let currentData = forecastData.current
            cell.configure(with: currentData, andTimezoneOffset: forecastData.timezoneOffset)
            return cell
            
        } else if sunriseIndices.contains(item) {
            cell.isSunrise = true
            
            if sunriseIndices.first == item {
                let dailyData = forecastData.daily[0]
                cell.configure(with: dailyData, andTimezoneOffset: forecastData.timezoneOffset)
                
            } else {
                let dailyData = forecastData.daily[1]
                cell.configure(with: dailyData, andTimezoneOffset: forecastData.timezoneOffset)
            }
            return cell
            
        } else if sunsetIndices.contains(item) {
            cell.isSunrise = false
            
            if sunsetIndices.first == item {
                let dailyData = forecastData.daily[0]
                cell.configure(with: dailyData, andTimezoneOffset: forecastData.timezoneOffset)
                
            } else {
                let dailyData = forecastData.daily[1]
                cell.configure(with: dailyData, andTimezoneOffset: forecastData.timezoneOffset)
            }
            return cell
            
        } else {
            let hourlyData = forecastData.hourly[item]
            cell.configure(with: hourlyData, andTimezoneOffset: forecastData.timezoneOffset)
            print(index)
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
    
    private func getIndices(for cellType: CellType) -> [Int] {
        
        let currentTime = forecastData?.current.dt
        
        var hourlyTime: [Int] = []
        var sunriseTime: [Int] = []
        var sunsetTime: [Int] = []
        
        forecastData?.hourly.forEach { hourly in
            hourlyTime.append(hourly.dt)
        }
        
        forecastData?.daily.forEach { daily in
            sunriseTime.append(daily.sunrise)
            sunsetTime.append(daily.sunset)
        }
        
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
        
        var sortedTime = time.sorted(by: <)
        var offset = 0
        sortedTime.forEach { time in
            

            let index = sortedTime.firstIndex(where: { $0 == time }) ?? 0
            
            if time <= currentTime! {
                sortedTime.remove(at: index)
            }
//
//            if sunriseTime.contains(time) {
//                sortedTime.swapAt(index, index - offset)
//                offset += 1
//            }
//
//            if sunsetTime.contains(time) {
//                sortedTime.swapAt(index, index - offset)
//                offset += 1
//            }
        }

        switch cellType {
        case .hourly:
//            return hourlyTime.sorted().enumerated().map { $0.offset }
            return sortedTime.enumerated().filter { hourlyTime.contains($0.element)}.map { $0.offset }
        case .sunrise:
            return sortedTime.enumerated().filter { sunriseTime.contains($0.element)}.map { $0.offset }
        case .sunset:
            return sortedTime.enumerated().filter { sunsetTime.contains($0.element)}.map { $0.offset }
        }
    }
}

