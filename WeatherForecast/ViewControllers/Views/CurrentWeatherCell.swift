//
//  CurrentWeatherCell.swift
//  WeatherForecast
//
//  Created by Василий Пронин on 09.02.2022.
//

import UIKit

class CurrentWeatherCell: UICollectionViewCell, SelfConfiguringCell {
    
    static let reuseIdentifier = "CurrentWeatherCell"
    
    lazy private var temperatureLabel = UILabel()
    lazy private var descriptionLabel = UILabel()
    lazy private var feelsLikeLabel = UILabel()
    lazy private var symbolView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        temperatureLabel.font = .boldSystemFont(ofSize: 50)
        temperatureLabel.textColor = .white
        
        descriptionLabel.font = .systemFont(ofSize: 16)
        descriptionLabel.textColor = .white
        
        feelsLikeLabel.font = .systemFont(ofSize: 16)
        feelsLikeLabel.textColor = .white
        
        symbolView.contentMode = .scaleAspectFit
        symbolView.preferredSymbolConfiguration = .preferringMulticolor()
        
        let innerStackView = UIStackView(arrangedSubviews: [
            temperatureLabel,
            symbolView
        ])
        innerStackView.axis = .horizontal
        innerStackView.alignment = .fill
        innerStackView.distribution = .fillEqually
        
        let outerStackView = UIStackView(arrangedSubviews: [
            innerStackView,
            descriptionLabel,
            feelsLikeLabel
        ])
        outerStackView.axis = .vertical
        outerStackView.spacing = 10
        outerStackView.alignment = .center
        outerStackView.distribution = .fill
        outerStackView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(outerStackView)
        
        setupConstraints(for: outerStackView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with forecast: AnyHashable) {
        guard let forecast = forecast as? Current else { return }
        
        var sunIsUp: Bool {
            let hour = DateFormatter.getHour(from: forecast.dt)
            switch hour {
            case 7...21: return true
            default: return false
            }
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
        temperatureLabel.text = forecast.temp.displayTemp()
        descriptionLabel.text = forecast.weather.first?.description.capitalized ?? ""
        feelsLikeLabel.text = "Feels like: " + forecast.feelsLike.displayTemp()
        symbolView.image = UIImage(systemName: systemNameString)
    }
    
    fileprivate func setupConstraints(for uiView: UIView) {
        NSLayoutConstraint.activate([
            uiView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 40),
            uiView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
    }
}
