//
//  DailyForecastCell.swift
//  WeatherForecast
//
//  Created by Василий Пронин on 09.02.2022.
//

import UIKit

class DailyForecastCell: UICollectionViewCell, SelfConfiguringCell {
    
    static let reuseIdentifier = "DailyForecastCell"
    
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
    
    func configure(with forecast: AnyHashable) {
        guard let model = forecast as? Daily.Diffable else { return }
        dateLabel.text = model.date
        weekdayLabel.text = model.weekday
        highestTemperatureLabel.text = model.highestTemperature
        lowestTemperatureLabel.text = model.lowestTemperature
        weatherIconView.image = UIImage(systemName: model.systemNameString)
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
