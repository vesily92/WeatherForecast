//
//  HourlyForecastCell.swift
//  WeatherForecast
//
//  Created by Василий Пронин on 09.02.2022.
//

import UIKit

class HourlyForecastCell: UICollectionViewCell, SelfConfiguringCell {
    
    static let reuseIdentifier = "HourlyForecastCell"
    
    lazy var sunIsUp: Bool = true
    
    lazy private var timeLabel = UILabel()
    lazy private var probabilityOfPrecipitationLabel = UILabel()
    lazy private var temperatureLabel = UILabel()
    lazy private var symbolView = UIImageView()
    
    private let symbolConfig = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 18))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
//        print("HOURLY CELL")

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
    
    func configure(with forecast: AnyHashable) {
        guard let forecast = forecast as? Hourly else { return }

//        var sunIsUp: Bool {
//            let hour = DateFormatter.getHour(from: forecast.dt)
//            switch hour {
//            case 7...21: return true
//            default: return false
//            }
//        }
        
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

        timeLabel.text = DateFormatter.format(forecast.dt, to: .time)
        probabilityOfPrecipitationLabel.text = forecast.pop.displayPop()
        temperatureLabel.text = forecast.temp.displayTemp()
        symbolView.image = UIImage(systemName: systemNameString, withConfiguration: symbolConfig)
    }
    
    fileprivate func setupConstraints(for uiView: UIView) {
        NSLayoutConstraint.activate([
            uiView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            uiView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            uiView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            uiView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
