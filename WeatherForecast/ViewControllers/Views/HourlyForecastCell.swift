//
//  HourlyForecastCell.swift
//  WeatherForecast
//
//  Created by Василий Пронин on 09.02.2022.
//

import UIKit

class HourlyForecastCell: UICollectionViewCell, SelfConfiguringCell {
    
    static let reuseIdentifier = "HourlyForecastCell"
    
    lazy var isSunrise: Bool = true
    
//    lazy private var timeLabel = UILabel(fontSize: 16)
    lazy private var timeLabel = UILabel(.sf16SemiboldWhite)
//    lazy private var popLabel = UILabel(fontSize: 12, color: .systemCyan)
    lazy private var popLabel = UILabel(.sf12SemiboldTeal)
//    lazy private var temperatureLabel = UILabel(fontSize: 20)
    lazy private var temperatureLabel = UILabel(.sf20SemiboldWhite)
    lazy private var symbolView = UIImageView()
    
    private let symbolConfig = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 18))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        symbolView.preferredSymbolConfiguration = .preferringMulticolor()
        symbolView.contentMode = .scaleAspectFit

        let iconPopStackView = UIStackView(arrangedSubviews: [
            symbolView,
            popLabel
        ])
        iconPopStackView.axis = .vertical
        iconPopStackView.translatesAutoresizingMaskIntoConstraints = false
       
        let stackView = UIStackView(arrangedSubviews: [
            timeLabel,
            iconPopStackView,
            temperatureLabel
        ])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalCentering
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(stackView)

        setupConstraints(stackView)
    }
    
    func configure(with forecast: AnyHashable, andTimezoneOffset offset: Int) {
        if let forecast = forecast as? Hourly {
            timeLabel.text = DateFormatter.format(forecast.dt, to: .hour, withTimeZoneOffset: offset)
            popLabel.text = forecast.pop.displayPop(
                if: forecast.weather.first!.isPopNeeded
            )
            temperatureLabel.text = forecast.temp.displayTemp()
            symbolView.image = UIImage(
                systemName: forecast.weather.first!.systemNameString,
                withConfiguration: symbolConfig
            )
        }
        
        if let forecast = forecast as? Current {
            timeLabel.text = "Now"
            popLabel.text = nil
            temperatureLabel.text = forecast.temp.displayTemp()
            symbolView.image = UIImage(
                systemName: forecast.weather.first!.systemNameString,
                withConfiguration: symbolConfig
            )
        }
        
        if let forecast = forecast as? Daily {
            timeLabel.text = DateFormatter.format(
                isSunrise
                ? forecast.sunrise
                : forecast.sunset,
                to: .sunrise,
                withTimeZoneOffset: offset
            )
            popLabel.text = nil
            temperatureLabel.text = isSunrise ? "Sunrise" : "Sunset"
            symbolView.image = UIImage(
                systemName: isSunrise
                ? "sunrise.fill"
                : "sunset.fill"
            )
        }
    }
    
    fileprivate func setupConstraints(_ uiView: UIView) {
        NSLayoutConstraint.activate([
            uiView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            uiView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            uiView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            uiView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
