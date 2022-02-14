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
        
        backgroundColor = .systemBlue
        
        temperatureLabel.font = .boldSystemFont(ofSize: 50)
        weatherDescriptionLabel.font = .systemFont(ofSize: 16)
        temperatureFeelsLikeLabel.font = .systemFont(ofSize: 16)
        
        weatherIconView.contentMode = .scaleAspectFit
        
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
    
    func configure(with forecast: AnyHashable) {
        guard let model = forecast as? Current.DiffableNow else { return }
        DispatchQueue.main.async {
            self.temperatureLabel.text = model.temperature
            self.weatherDescriptionLabel.text = model.description
            self.temperatureFeelsLikeLabel.text = model.feelsLike
            self.weatherIconView.image = UIImage(systemName: model.systemNameString)
        }
    }
    
    fileprivate func setupConstraints(for uiView: UIView) {
        contentView.addSubview(uiView)
        
        NSLayoutConstraint.activate([
            uiView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 40),
            uiView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
    }
}
