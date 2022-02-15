//
//  CurrentWeatherCell.swift
//  WeatherForecast
//
//  Created by Василий Пронин on 09.02.2022.
//

import UIKit

class CurrentWeatherCell: UICollectionViewCell, SelfConfiguringCell {
    
    static let reuseIdentifier = "CurrentWeatherCell"
    
    let temperatureLabel = UILabel()
    let weatherDescriptionLabel = UILabel()
    let temperatureFeelsLikeLabel = UILabel()
    let weatherIconView = UIImageView()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    func configure(with forecast: AnyHashable) {
//        guard let model = forecast as? Current.Diffable else { return }
//        DispatchQueue.main.async {
//            self.temperatureLabel.text = model.temperature
//            self.weatherDescriptionLabel.text = model.description
//            self.temperatureFeelsLikeLabel.text = model.feelsLike
//            self.weatherIconView.image = UIImage(systemName: model.systemNameString)
//        }
//    }
    
    func configure(with forecast: AnyHashable) {
        guard let model = forecast as? Current else { return }
        
        guard let temp = model.temp,
              let description = model.weather?.first?.description,
              let feelsLike = model.feelsLike,
              let icon = model.weather?.first?.systemNameString else {
                  return
              }
        
        self.temperatureLabel.text = format(input: temp, modifier: true)
        self.weatherDescriptionLabel.text = description.capitalized
        self.temperatureFeelsLikeLabel.text = format(input: feelsLike, modifier: true)
        self.weatherIconView.image = UIImage(systemName: icon)
        
    }
    
    fileprivate func setupConstraints(for uiView: UIView) {
        contentView.addSubview(uiView)
        
        NSLayoutConstraint.activate([
            uiView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 40),
            uiView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
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
