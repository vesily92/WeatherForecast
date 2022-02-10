//
//  HourlyForecastCell.swift
//  WeatherForecast
//
//  Created by Василий Пронин on 09.02.2022.
//

import UIKit

class HourlyForecastCell: UICollectionViewCell {
    let timeLabel = UILabel()
    let probabilityOfPrecipitationLabel = UILabel()
    let temperatureLabel = UILabel()
    let weatherIconView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .systemGray
        
        let stackView = UIStackView(arrangedSubviews: [
            timeLabel,
            weatherIconView,
            probabilityOfPrecipitationLabel,
            temperatureLabel
        ])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        setupConstraints(for: stackView)
    }
    
    func configure(with hourlyForecast: HourlyForecast) {
        timeLabel.text = hourlyForecast.timeString
        probabilityOfPrecipitationLabel.text = hourlyForecast.probabilityOfPrecipitationString
        temperatureLabel.text = hourlyForecast.hourlyTemperatureString
        weatherIconView.image = UIImage(systemName: hourlyForecast.systemNameString)
    }
    
    fileprivate func setupConstraints(for uiView: UIView) {
        contentView.addSubview(uiView)
        
        NSLayoutConstraint.activate([
            uiView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            uiView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
