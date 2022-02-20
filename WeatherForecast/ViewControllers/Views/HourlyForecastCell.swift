//
//  HourlyForecastCell.swift
//  WeatherForecast
//
//  Created by Василий Пронин on 09.02.2022.
//

import UIKit

class HourlyForecastCell: UICollectionViewCell, SelfConfiguringCell {
    
    static let reuseIdentifier = "HourlyForecastCell"
    
    let timeLabel = UILabel()
    let probabilityOfPrecipitationLabel = UILabel()
    let temperatureLabel = UILabel()
    let weatherIconView = UIImageView()
    
    private let symbolConfig = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 22))
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        timeLabel.font = .systemFont(ofSize: 16, weight: .medium)
        timeLabel.textColor = .white
        
        probabilityOfPrecipitationLabel.textColor = .systemCyan
        probabilityOfPrecipitationLabel.font = .systemFont(ofSize: 12, weight: .bold)
        
        temperatureLabel.font = .systemFont(ofSize: 18, weight: .bold)
        temperatureLabel.textColor = .white
        
        weatherIconView.preferredSymbolConfiguration = .preferringMulticolor()
        weatherIconView.contentMode = .scaleAspectFit
        
        let iconPopStackView = UIStackView(arrangedSubviews: [
            weatherIconView,
            probabilityOfPrecipitationLabel
        ])
        iconPopStackView.axis = .vertical
        iconPopStackView.distribution = .fill
        iconPopStackView.clipsToBounds = true
        
        let stackView = UIStackView(arrangedSubviews: [
            timeLabel,
//            weatherIconView,
//            probabilityOfPrecipitationLabel,
            iconPopStackView,
            temperatureLabel
        ])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false

        setupConstraints(for: stackView)
    }
    
//    func configure(with forecast: AnyHashable) {
//        guard let model = forecast as? Hourly.Diffable else { return }
//
//        timeLabel.text = model.time
//        probabilityOfPrecipitationLabel.text = model.probabilityOfPrecipitation
//        temperatureLabel.text = model.hourlyTemperature
//        weatherIconView.image = UIImage(systemName: model.systemNameString)
//    }
    
    func configure(with forecast: AnyHashable) {
        guard let model = forecast as? Hourly else { return }
        
        guard let time = model.dt,
              let pop = model.pop,
              let temp = model.temp,
              let icon = model.weather?.first?.systemNameString else {
                  return
              }
        
        timeLabel.text = DateManager.shared.defineDate(withUnixTime: time, andDateFormat: .time)
        probabilityOfPrecipitationLabel.text = format(input: pop)
        temperatureLabel.text = format(input: temp, modifier: true)
        weatherIconView.image = UIImage(systemName: icon, withConfiguration: symbolConfig)
    }
    
    fileprivate func setupConstraints(for uiView: UIView) {
        contentView.addSubview(uiView)
        
        NSLayoutConstraint.activate([
            uiView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            uiView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            uiView.heightAnchor.constraint(equalToConstant: 120)
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
