//
//  MainPageCollectionViewCell.swift
//  WeatherForecast
//
//  Created by Василий Пронин on 13.12.2022.
//

import UIKit

class MainPageCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "MainPageCollectionViewCell"
    
    let mainPageView = MainPageView()
    var forecastData: ForecastData! {
        didSet {
            mainPageView.configure(with: forecastData)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with forecastData: ForecastData) {
        self.forecastData = forecastData
    }
    
    private func setupUI() {
        mainPageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(mainPageView)
        
        NSLayoutConstraint.activate([
            mainPageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            mainPageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            mainPageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            mainPageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    
}
