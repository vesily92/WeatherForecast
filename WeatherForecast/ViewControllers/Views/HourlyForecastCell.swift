//
//  HourlyForecastCell.swift
//  WeatherForecast
//
//  Created by Василий Пронин on 09.02.2022.
//

import UIKit

class HourlyForecastCell: UICollectionViewCell, SelfConfiguringCell {
    
    static let reuseIdentifier = "HourlyForecastCell"
    
    lazy private var timeLabel = UILabel()
    lazy private var probabilityOfPrecipitationLabel = UILabel()
    lazy private var temperatureLabel = UILabel()
    lazy private var symbolView = UIImageView()
    
    private let symbolConfig = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 18))
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        timeLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        timeLabel.textColor = .white
        
        probabilityOfPrecipitationLabel.textColor = .systemCyan
        probabilityOfPrecipitationLabel.font = .systemFont(ofSize: 12, weight: .semibold)
        
        temperatureLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        temperatureLabel.textColor = .white
        
        symbolView.preferredSymbolConfiguration = .preferringMulticolor()
        symbolView.contentMode = .scaleAspectFit

        let iconPopStackView = UIStackView(arrangedSubviews: [
            symbolView,
            probabilityOfPrecipitationLabel
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

        setupConstraints(for: stackView)
    }
  
//    func configure(with forecast: AnyHashable) {
//        guard let forecast = forecast as? ForecastData else { return }
//
//        let hourly = forecast.hourly
//        let weather = hourly.first!.weather
//
//        var time: String {
//            var integer = 0
//            hourly.forEach { hourly in
//                integer = hourly.dt
//            }
//            return DateFormatter.format(unixTime: integer, to: .time)
//        }
//        var pop: String {
//            var double = 0.0
//            hourly.forEach { hourly in
//                double = hourly.pop
//            }
//            return format(input: double) ?? ""
//        }
//
//        var temp: String {
//            var double = 0.0
//            hourly.forEach { hourly in
//                double = hourly.temp
//            }
//            return format(input: double, modifier: true) ?? ""
//        }
//
//        var id: Int {
//            var integer = 0
//            weather.forEach { weather in
//                integer = weather.id
//            }
//            return integer
//        }
//
//        let sunrise = forecast.current.sunrise
//        let sunset = forecast.current.sunset
//
//
//
//        var sunIsUp: Bool {
//            let hour = DateFormatter.getHour(from: hourly.first!.dt)
//            switch hour {
//            case 7...21: return true
//            default: return false
//            }
//        }
//        var isNow: Bool {
//            return DateFormatter.compare(.hour, with: hourly.first!.dt)
//        }
//        var systemNameString: String {
//            switch id {
//            case 200...232: return "cloud.bolt.rain.fill"
//            case 300...321: return "cloud.drizzle.fill"
//            case 500...531: return "cloud.heavyrain.fill"
//            case 600...622: return "snowflake"
//            case 700...781: return "cloud.fog.fill"
//            case 800: return sunIsUp ? "sun.max.fill" : "moon.stars.fill"
//            case 801...804: return sunIsUp ? "cloud.sun.fill" : "cloud.moon.fill"
//            default: return "nosign"
//            }
//        }
//
//        timeLabel.text = isNow ? "Now" : time
//        probabilityOfPrecipitationLabel.text = pop
//        temperatureLabel.text = temp
//        iconView.image = UIImage(systemName: systemNameString, withConfiguration: symbolConfig)
//
//        // Configure cell with hourly forecast and sunrise/sunset data
//    }
    
    
    
    
    
    func configure(with forecast: AnyHashable) {
        guard let forecast = forecast as? Hourly else { return }

        var sunIsUp: Bool {
            let hour = DateFormatter.getHour(from: forecast.dt)
            switch hour {
            case 7...21: return true
            default: return false
            }
        }
        var isNow: Bool {
            return DateFormatter.compare(.hour, with: forecast.dt)
        }
        var systemNameString: String {
            switch forecast.weather.first!.id {
            case 200...232: return "cloud.bolt.rain.fill"
            case 300...321: return "cloud.drizzle.fill"
            case 500...531: return "cloud.heavyrain.fill"
            case 600...622: return "snowflake"
            case 700...781: return "cloud.fog.fill"
            case 800: return sunIsUp ? "sun.max.fill" : "moon.stars.fill"
            case 801...804: return sunIsUp ? "cloud.sun.fill" : "cloud.moon.fill"
            default: return "nosign"
            }
        }

        timeLabel.text = isNow ? "Now" : DateFormatter.format(unixTime: forecast.dt, to: .time)
        probabilityOfPrecipitationLabel.text = forecast.pop.displayPop()
        temperatureLabel.text = forecast.temp.displayTemp()
        print(forecast.temp)
        symbolView.image = UIImage(systemName: systemNameString, withConfiguration: symbolConfig)
    }
    
//    func configure(with forecast: AnyHashable) {
//
//        guard let hourlyForecast = forecast as? Hourly else { return }
//        guard let dailyForecast = forecast as? Daily else { return }
//
//
//
//        switch forecast {
//        case let daily:
//            guard let daily = daily as? Daily else { return }
//            timeLabel.text = DateFormatter.format(unixTime: daily.sunrise, to: .sunrise)
//            probabilityOfPrecipitationLabel.text = nil
//            temperatureLabel.text = "Sunrise"
//            symbolView.image = UIImage(systemName: "sunrise.fill", withConfiguration: symbolConfig)
//        default:
//            guard let forecast = forecast as? Hourly else { return }
//
//            var sunIsUp: Bool {
//                let hour = DateFormatter.getHour(from: forecast.dt)
//                switch hour {
//                case 7...21: return true
//                default: return false
//                }
//            }
//            var isNow: Bool {
//                return DateFormatter.compare(.hour, with: forecast.dt)
//            }
//            var systemNameString: String {
//                switch forecast.weather.first!.id {
//                case 200...232: return "cloud.bolt.rain.fill"
//                case 300...321: return "cloud.drizzle.fill"
//                case 500...531: return "cloud.heavyrain.fill"
//                case 600...622: return "snowflake"
//                case 700...781: return "cloud.fog.fill"
//                case 800: return sunIsUp ? "sun.max.fill" : "moon.stars.fill"
//                case 801...804: return sunIsUp ? "cloud.sun.fill" : "cloud.moon.fill"
//                default: return "nosign"
//                }
//            }
//
//            timeLabel.text = isNow ? "Now" : DateFormatter.format(unixTime: forecast.dt, to: .time)
//            probabilityOfPrecipitationLabel.text = forecast.pop.displayPop()
//            temperatureLabel.text = forecast.temp.displayTemp()
//            print(forecast.temp)
//            symbolView.image = UIImage(systemName: systemNameString, withConfiguration: symbolConfig)
//        }
//    }
    
    fileprivate func setupConstraints(for uiView: UIView) {
        NSLayoutConstraint.activate([
            uiView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            uiView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            uiView.heightAnchor.constraint(greaterThanOrEqualToConstant: 90)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
