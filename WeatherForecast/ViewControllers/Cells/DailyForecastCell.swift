//
//  DailyForecastCell.swift
//  WeatherForecast
//
//  Created by Василий Пронин on 09.02.2022.
//

import UIKit

class DailyForecastCell: UICollectionViewCell {
    let dateLabel = UILabel()
    let weekdayLabel = UILabel()
    let highestTemperatureLabel = UILabel()
    let lowestTemperatureLabel = UILabel()
    let weatherIconView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .systemPink
        
        let subStackView = UIStackView(arrangedSubviews: [
            dateLabel,
            weekdayLabel
        ])
        subStackView.axis = .vertical
        subStackView.alignment = .leading
        
        let mainStackView = UIStackView(arrangedSubviews: [
            subStackView,
            weatherIconView,
            highestTemperatureLabel,
            lowestTemperatureLabel
        ])
        mainStackView.axis = .horizontal
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with dailyForecast: DailyForecast) {
        dateLabel.text = dailyForecast.dateString
        weekdayLabel.text = dailyForecast.weekdayString
        highestTemperatureLabel.text = dailyForecast.highestTemperatureString
        lowestTemperatureLabel.text = dailyForecast.lowestTemperatureString
        weatherIconView.image = UIImage(systemName: dailyForecast.systemNameString)
    }
    
    fileprivate func setupConstraints(for uiView: UIView) {
        contentView.addSubview(uiView)
        
        NSLayoutConstraint.activate([
            uiView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            uiView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            uiView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
