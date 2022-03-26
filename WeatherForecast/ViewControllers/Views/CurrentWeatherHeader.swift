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
    lazy private var weatherDescriptionLabel = UILabel()
    lazy private var temperatureFeelsLikeLabel = UILabel()
    lazy private var weatherIconView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.zPosition = -1
        
        temperatureLabel.font = .boldSystemFont(ofSize: 50)
        temperatureLabel.textColor = .white
        
        weatherDescriptionLabel.font = .systemFont(ofSize: 16)
        weatherDescriptionLabel.textColor = .white
        
        temperatureFeelsLikeLabel.font = .systemFont(ofSize: 16)
        temperatureFeelsLikeLabel.textColor = .white
        
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
            weatherDescriptionLabel,
            temperatureFeelsLikeLabel
        ])
        mainStackView.axis = .vertical
        mainStackView.spacing = 10
        mainStackView.alignment = .center
        mainStackView.distribution = .fill
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        
        setupConstraints(for: mainStackView)
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        
    }
    
    func configure(with model: Current) {
        
        DispatchQueue.main.async {
            self.temperatureLabel.text = String(format: "%.0f", model.temp.rounded(.toNearestOrAwayFromZero)) + "°"
            self.weatherDescriptionLabel.text = model.weather.first?.description.capitalized ?? ""
            self.temperatureFeelsLikeLabel.text = "Feels like: " + String(format: "%.0f", model.feelsLike.rounded(.toNearestOrAwayFromZero)) + "°"
            self.weatherIconView.image = UIImage(systemName: model.weather.first?.systemNameString ?? "")
        }
    }
//----------------------------------------------------------------------------------------
//    func configure(with forecast: ForecastData.CurrentData) {
////        guard let forecast = forecast as? ForecastData.CurrentData else { return }
//        DispatchQueue.main.async {
//            self.temperatureLabel.text = forecast.temperature
//            self.weatherDescriptionLabel.text = forecast.description
//            self.temperatureFeelsLikeLabel.text = forecast.feelsLike
//            self.weatherIconView.image = UIImage(systemName: forecast.systemNameString)
//        }
//    }
//----------------------------------------------------------------------------------------
//    func configure(with model: AnyHashable) {
//        guard let forecast = model as? CurrentWeather else { return }
//        DispatchQueue.main.async {
//            self.temperatureLabel.text = forecast.temperatureString
//            self.weatherDescriptionLabel.text = forecast.description
//            self.temperatureFeelsLikeLabel.text = forecast.feelsLikeString
//            self.weatherIconView.image = UIImage(systemName: forecast.systemNameString)
//        }
//    }
    
    fileprivate func setupConstraints(for uiView: UIView) {
        addSubview(uiView)
        
        NSLayoutConstraint.activate([
            uiView.topAnchor.constraint(equalTo: topAnchor, constant: 40),
            uiView.centerXAnchor.constraint(equalTo: centerXAnchor)
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


