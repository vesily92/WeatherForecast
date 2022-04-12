//
//  CurrentWeatherHeader.swift
//  WeatherForecast
//
//  Created by Василий Пронин on 01.03.2022.
//

import UIKit

class CurrentWeatherHeader: UICollectionReusableView {
    
    static let reuseIdentifier = "CurrentWeatherHeader"
    
    lazy private var temperatureLabel = UILabel()
    lazy private var descriptionLabel = UILabel()
    lazy private var feelsLikeLabel = UILabel()
    lazy private var weatherIconView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.zPosition = -1
        
        temperatureLabel.font = .boldSystemFont(ofSize: 50)
        temperatureLabel.textColor = .white
        
        descriptionLabel.font = .systemFont(ofSize: 16)
        descriptionLabel.textColor = .white
        
        feelsLikeLabel.font = .systemFont(ofSize: 16)
        feelsLikeLabel.textColor = .white
        
        weatherIconView.contentMode = .scaleAspectFit
        weatherIconView.preferredSymbolConfiguration = .preferringMulticolor()
        
        let subStackView = UIStackView(arrangedSubviews: [
            temperatureLabel,
            weatherIconView
        ])
        subStackView.axis = .horizontal
        subStackView.alignment = .fill
        subStackView.distribution = .fillEqually
        
        let mainStackView = UIStackView(arrangedSubviews: [
            subStackView,
            descriptionLabel,
            feelsLikeLabel
        ])
        mainStackView.axis = .vertical
        mainStackView.spacing = 10
        mainStackView.alignment = .center
        mainStackView.distribution = .fill
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(mainStackView)
        
        setupConstraints(for: mainStackView)
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        
    }
    
    func configure(with forecast: Current) {
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
        weatherIconView.image = UIImage(systemName: systemNameString)
    }
    
    fileprivate func setupConstraints(for uiView: UIView) {
        NSLayoutConstraint.activate([
            uiView.topAnchor.constraint(equalTo: topAnchor, constant: 40),
            uiView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


