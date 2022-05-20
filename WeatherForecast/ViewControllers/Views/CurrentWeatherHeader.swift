//
//  CurrentWeatherHeader.swift
//  WeatherForecast
//
//  Created by Василий Пронин on 01.03.2022.
//

import UIKit

class CurrentWeatherHeader: UICollectionReusableView {
    static let reuseIdentifier = "CurrentWeatherHeader"
    
    lazy private var cityNameLabel = UILabel()
    lazy private var temperatureLabel = UILabel()
    lazy private var descriptionLabel = UILabel()
    lazy private var feelsLikeLabel = UILabel()
    
    lazy private var timeLabel = UILabel()
    
    lazy private var iconView = UIImageView()
    lazy private var backgroundView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.zPosition = 2
        
        backgroundView.backgroundColor = .systemBlue
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        cityNameLabel.font = .preferredFont(forTextStyle: .largeTitle)
        cityNameLabel.textColor = .white
        
        temperatureLabel.font = .boldSystemFont(ofSize: 50)
        temperatureLabel.textColor = .white
        
        descriptionLabel.font = .systemFont(ofSize: 16)
        descriptionLabel.textColor = .white
        
        feelsLikeLabel.font = .systemFont(ofSize: 16)
        feelsLikeLabel.textColor = .white
        
        iconView.contentMode = .scaleAspectFit
        iconView.preferredSymbolConfiguration = .preferringMulticolor()
        
        
        timeLabel.font = .systemFont(ofSize: 16)
        timeLabel.textColor = .white
        
        let subStackView = UIStackView(arrangedSubviews: [
            temperatureLabel,
            iconView
        ])
        subStackView.axis = .horizontal
        subStackView.alignment = .fill
        subStackView.distribution = .fillEqually
        
        let mainStackView = UIStackView(arrangedSubviews: [
            cityNameLabel,
            subStackView,
            descriptionLabel,
            feelsLikeLabel,
            
            timeLabel
        ])
        mainStackView.axis = .vertical
        mainStackView.spacing = 10
        mainStackView.alignment = .center
        mainStackView.distribution = .fill
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(backgroundView)
        addSubview(mainStackView)
        
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundView.heightAnchor.constraint(lessThanOrEqualToConstant: 250),
            
            mainStackView.topAnchor.constraint(equalTo: topAnchor, constant: 40),
            mainStackView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
//    func configure(with forecast: Current) {
//        cityNameLabel.text = "Saint Petersburg"
//        temperatureLabel.text = forecast.temp.displayTemp()
//        descriptionLabel.text = forecast.weather.first?.description.capitalized ?? ""
//        feelsLikeLabel.text = "Feels like: " + forecast.feelsLike.displayTemp()
//        iconView.image = UIImage(systemName: forecast.weather.first!.systemNameString)
//    }
    
    func configure(with forecast: CurrentWeather) {
        DispatchQueue.main.async {
            self.cityNameLabel.text = forecast.cityName
            self.temperatureLabel.text = forecast.tempString
            self.descriptionLabel.text = forecast.descriptionString
            self.feelsLikeLabel.text = forecast.feelsLikeString
            self.iconView.image = UIImage(systemName: forecast.systemNameString)
            
            self.timeLabel.text = forecast.timeString
        }
    }
//    
//    func setAlphaValue(with offset: CGFloat) {
//        temperatureLabel.alpha = offset
//        descriptionLabel.alpha = offset
//        feelsLikeLabel.alpha = offset
//        iconView.alpha = offset
//    }
//    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


