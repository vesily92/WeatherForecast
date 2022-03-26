//
//  DailyForecastCell.swift
//  WeatherForecast
//
//  Created by Василий Пронин on 09.02.2022.
//

import UIKit

class DailyForecastCell: UICollectionViewCell, SelfConfiguringCell {
    
    static let reuseIdentifier = "DailyForecastCell"
    
    lazy private var dateLabel = UILabel()
    lazy private var weekdayLabel = UILabel()
    lazy private var highestTemperatureLabel = UILabel()
    lazy private var lowestTemperatureLabel = UILabel()
    lazy private var probabilityOfPrecipitationLabel = UILabel()
    lazy private var weatherIconView = UIImageView()
    
    var collectionView: UICollectionView!
    
    private let symbolConfig = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 16))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        weekdayLabel.font = .systemFont(ofSize: 18, weight: .bold)
        weekdayLabel.textColor = .white
        
        dateLabel.font = .systemFont(ofSize: 12, weight: .light)
        dateLabel.textColor = .white
        
        highestTemperatureLabel.font = .systemFont(ofSize: 18, weight: .bold)
        highestTemperatureLabel.textColor = .white
        
        lowestTemperatureLabel.font = .systemFont(ofSize: 18, weight: .bold)
        lowestTemperatureLabel.alpha = 0.3
        
        probabilityOfPrecipitationLabel.font = .systemFont(ofSize: 12, weight: .bold)
        probabilityOfPrecipitationLabel.textColor = .systemCyan
        
        weatherIconView.preferredSymbolConfiguration = .preferringMulticolor()
        weatherIconView.contentMode = .scaleAspectFit
        
        let dateStackView = UIStackView(arrangedSubviews: [
            weekdayLabel,
            dateLabel
        ])
        dateStackView.axis = .vertical
        dateStackView.alignment = .leading
        
        let weatherIconStackView = UIStackView(arrangedSubviews: [
            weatherIconView,
            probabilityOfPrecipitationLabel
        ])
        weatherIconStackView.axis = .vertical
        
        let emptyStackView = UIStackView()
        
        let temperatureStackView = UIStackView(arrangedSubviews: [
            weatherIconStackView,
            emptyStackView,
            highestTemperatureLabel,
            lowestTemperatureLabel
        ])
        temperatureStackView.axis = .horizontal
        temperatureStackView.distribution = .equalCentering
        temperatureStackView.spacing = 10
        
        let mainStackView = UIStackView(arrangedSubviews: [
            weekdayLabel,
//            dateStackView,
            temperatureStackView
        ])
        mainStackView.distribution = .equalCentering
        mainStackView.axis = .horizontal
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        
        setupConstraints(for: mainStackView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    func configure(with forecast: AnyHashable) {
//        guard let model = forecast as? Daily.Diffable else { return }
//        dateLabel.text = model.date
//        weekdayLabel.text = model.weekday
//        highestTemperatureLabel.text = model.highestTemperature
//        lowestTemperatureLabel.text = model.lowestTemperature
//        weatherIconView.image = UIImage(systemName: model.systemNameString)
//    }
    
    func configure(with forecast: AnyHashable) {
        guard let model = forecast as? Daily else { return }

        let time = model.dt
        let maxTemp = model.temperature.max
        let minTemp = model.temperature.min
        let pop = model.pop
        let icon = model.weather.first!.systemNameString

        dateLabel.text = DateManager.shared.defineDate(withUnixTime: time, andDateFormat: .date)
        weekdayLabel.text = DateManager.shared.defineDate(withUnixTime: time, andDateFormat: .weekday).capitalized
        highestTemperatureLabel.text = format(input: maxTemp, modifier: true)
        lowestTemperatureLabel.text = format(input: minTemp, modifier: true)
        probabilityOfPrecipitationLabel.text = format(input: pop)
        weatherIconView.image = UIImage(systemName: icon, withConfiguration: symbolConfig)
    }
    
//    func configure(with forecast: AnyHashable) {
//        guard let forecast = forecast as? ForecastData.DailyData else { return }
//
//        DispatchQueue.main.async {
//            self.dateLabel.text = forecast.date
//            self.weekdayLabel.text = forecast.weekday
//            self.highestTemperatureLabel.text = forecast.highestTemperature
//            self.lowestTemperatureLabel.text = forecast.lowestTemperature
//            self.probabilityOfPrecipitationLabel.text = forecast.probabilityOfPrecipitation
//            self.weatherIconView.image = UIImage(systemName: forecast.systemNameString, withConfiguration: self.symbolConfig)
//        }
//    }
    
    fileprivate func setupConstraints(for uiView: UIView) {
        contentView.addSubview(uiView)
        
        NSLayoutConstraint.activate([
            uiView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            uiView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            uiView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    fileprivate func format(input: Double, modifier: Bool = false) -> String? {
        
        if modifier {
            return String(format: "%.0f", input.rounded(.toNearestOrAwayFromZero)) + "°"
        } else if input > 0.2 && !modifier {
            return String(format: "%.0f", input * 100) + " %"
        } else {
            return nil
        }
    }
}
