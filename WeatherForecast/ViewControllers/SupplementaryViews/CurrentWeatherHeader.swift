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
    lazy private var tempLabel = UILabel()
    lazy private var descriptionLabel = UILabel()
    lazy private var feelsLikeLabel = UILabel()
    lazy private var subheadlineLabel = UILabel()
    lazy private var iconView = UIImageView()
    lazy private var backgroundView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.zPosition = 2
        
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterialLight)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        
        backgroundView.backgroundColor = .clear
        backgroundView.alpha = 0
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.insertSubview(blurView, at: 0)
        
        cityNameLabel.font = .preferredFont(forTextStyle: .largeTitle)
        cityNameLabel.textColor = .white
        
        subheadlineLabel.font = .preferredFont(forTextStyle: .headline)
        subheadlineLabel.textColor = .white
        subheadlineLabel.alpha = 0
        subheadlineLabel.translatesAutoresizingMaskIntoConstraints = false
        
        tempLabel.font = .boldSystemFont(ofSize: 50)
        tempLabel.textColor = .white
        
        descriptionLabel.font = .systemFont(ofSize: 16)
        descriptionLabel.textColor = .white
        
        feelsLikeLabel.font = .systemFont(ofSize: 16)
        feelsLikeLabel.textColor = .white
        
        iconView.contentMode = .scaleAspectFit
        iconView.preferredSymbolConfiguration = .preferringMulticolor()
        
        let subStackView = UIStackView(arrangedSubviews: [
            tempLabel,
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
        ])
        mainStackView.axis = .vertical
        mainStackView.spacing = 10
        mainStackView.alignment = .center
        mainStackView.distribution = .fill
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(backgroundView)
        addSubview(mainStackView)
        addSubview(subheadlineLabel)
        
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundView.heightAnchor.constraint(lessThanOrEqualToConstant: 140),
            
            blurView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor),
            blurView.topAnchor.constraint(equalTo: backgroundView.topAnchor),
            blurView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor),
            
            mainStackView.topAnchor.constraint(equalTo: topAnchor, constant: 60),
            mainStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            subheadlineLabel.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 100),
            subheadlineLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }

    func configure(with forecast: CurrentWeather) {
        DispatchQueue.main.async {
            self.cityNameLabel.text = forecast.cityName
            self.tempLabel.text = forecast.tempString
            self.descriptionLabel.text = forecast.descriptionString
            self.feelsLikeLabel.text = forecast.feelsLikeString
            self.iconView.image = UIImage(systemName: forecast.systemNameString)
            
            self.subheadlineLabel.text = forecast.tempString + " " + "|" + " " + forecast.descriptionString
        }
    }
   
    func setAlphaForMainLabels(with offset: CGFloat) {
        tempLabel.alpha = offset
        descriptionLabel.alpha = offset
        feelsLikeLabel.alpha = offset
        iconView.alpha = offset
    }
    
    
    func setAlphaForSubheadline(with offset: CGFloat) {
        subheadlineLabel.alpha = offset
        backgroundView.alpha = offset
    }
    
    func reduceZIndex() {
        layer.zPosition = -2
    }
    
    func restoreZIndex() {
        layer.zPosition = 2
    }
   
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


