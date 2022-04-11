//
//  DailyForecastCell.swift
//  WeatherForecast
//
//  Created by Василий Пронин on 09.02.2022.
//

import UIKit

class DailyForecastCell: UICollectionViewCell, SelfConfiguringCell {
    
    static let reuseIdentifier = "DailyForecastCell"
    
    lazy private var weekdayLabel = UILabel()
    lazy private var highestTemperatureLabel = UILabel()
    lazy private var lowestTemperatureLabel = UILabel()
    lazy private var probabilityOfPrecipitationLabel = UILabel()
    lazy private var symbolView = UIImageView()
    
    var collectionView: UICollectionView!
    
    private let symbolConfig = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 18))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        weekdayLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        weekdayLabel.textColor = .white
        
        highestTemperatureLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        highestTemperatureLabel.textColor = .white
        
        lowestTemperatureLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        lowestTemperatureLabel.alpha = 0.3
        
        probabilityOfPrecipitationLabel.font = .systemFont(ofSize: 12, weight: .semibold)
        probabilityOfPrecipitationLabel.textColor = .systemCyan
        
        symbolView.preferredSymbolConfiguration = .preferringMulticolor()
        symbolView.contentMode = .scaleAspectFit

        let weatherIconStackView = UIStackView(arrangedSubviews: [
            symbolView,
            probabilityOfPrecipitationLabel
        ])
        weatherIconStackView.axis = .vertical
        
        let temperatureStackView = UIStackView(arrangedSubviews: [
            highestTemperatureLabel,
            lowestTemperatureLabel
        ])
        temperatureStackView.axis = .horizontal
        temperatureStackView.distribution = .equalCentering
        temperatureStackView.spacing = 10
        
        let mainStackView = UIStackView(arrangedSubviews: [
            weekdayLabel,
            weatherIconStackView,
            temperatureStackView
        ])
        mainStackView.distribution = .equalCentering
        mainStackView.axis = .horizontal
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(mainStackView)
        
        setupConstraints(for: mainStackView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with forecast: AnyHashable) {
        guard let forecast = forecast as? Daily else { return }

        var isToday: Bool {
            return DateFormatter.compare(.day, with: forecast.dt)
        }
        var systemNameString: String {
            switch forecast.weather.first!.id {
            case 200...232: return "cloud.bolt.rain.fill" //"11d"
            case 300...321: return "cloud.drizzle.fill" //"09d"
            case 500...531: return "cloud.heavyrain.fill" //"10d"
            case 600...622: return "snowflake" //"13d"
            case 700...781: return "cloud.fog.fill" //"50d"
            case 800: return "sun.max.fill" //"01d"
            case 801...804: return "cloud.sun.fill" //"04d"
            default: return "nosign"
            }
        }
        weekdayLabel.text = isToday ? "Today" : DateFormatter.format(unixTime: forecast.dt, to: .weekday)
        highestTemperatureLabel.text = forecast.temperature.max.displayTemp()
        lowestTemperatureLabel.text = forecast.temperature.min.displayTemp()
        probabilityOfPrecipitationLabel.text = forecast.pop.displayPop()
        symbolView.image = UIImage(systemName: systemNameString, withConfiguration: symbolConfig)
    }
 
    fileprivate func setupConstraints(for uiView: UIView) {
        NSLayoutConstraint.activate([
            uiView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            uiView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            uiView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
