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
    lazy private var weatherIconView = UIImageView()
    
    private let symbolConfig = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 18))
    
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
        guard let model = forecast as? Hourly else { return }
        
        
        let time = model.dt
        let pop = model.pop
        let temp = model.temp
        let icon = model.systemNameString
        
        var isNow: Bool {
            return DateFormatter.verify(.hour, from: time)
        }
        
        DispatchQueue.main.async {
            self.timeLabel.text = isNow ? "Now" : DateFormatter.format(unixTime: time, to: .time)
            self.probabilityOfPrecipitationLabel.text = self.format(input: pop)
            self.temperatureLabel.text = self.format(input: temp, modifier: true)
            self.weatherIconView.image = UIImage(systemName: icon, withConfiguration: self.symbolConfig)
        }
    }
    
    fileprivate func setupConstraints(for uiView: UIView) {
        NSLayoutConstraint.activate([
            uiView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            uiView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            uiView.heightAnchor.constraint(greaterThanOrEqualToConstant: 80)
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
