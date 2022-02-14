//
//  HourlyForecastCell.swift
//  WeatherForecast
//
//  Created by Василий Пронин on 09.02.2022.
//

import UIKit

class HourlyForecastCell: UICollectionViewCell, SelfConfiguringCell {
    
    
    static let reuseIdentifier = "HourlyForecastCell"
    
    var hourlyForecast: Current!
    
    let timeLabel = UILabel()
    let probabilityOfPrecipitationLabel = UILabel()
    let temperatureLabel = UILabel()
    let weatherIconView = UIImageView()
    
//    var timeString: String {
//        return DateManager.shared.defineDate(withUnixTime: hourlyForecast.dt, andDateFormat: .time)
//    }
//    
//    var hourlyTemperatureString: String {
//        return String(format: "%.0f", hourlyForecast.temp.rounded(.toNearestOrAwayFromZero))
//    }
//    
//    var probabilityOfPrecipitationString: String {
//        return "\(hourlyForecast.pop)%"
//    }
//    
//    var systemNameString: String {
//        switch hourlyForecast.weather.first!.id {
//        case 200...232: return "cloud.bolt.rain.fill" //"11d"
//        case 300...321: return "cloud.drizzle.fill" //"09d"
//        case 500...531: return "cloud.heavyrain.fill" //"10d"
//        case 600...622: return "cloud.snow.fill" //"13d"
//        case 700...781: return "cloud.fog.fill" //"50d"
//        case 800: return "sun.max.fill" //"01d"
//        case 801...804: return "cloud.sun.fill" //"04d"
//        default: return "nosign"
//        }
//    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .systemGray
        
        let stackView = UIStackView(arrangedSubviews: [
            timeLabel,
            weatherIconView,
            probabilityOfPrecipitationLabel,
            temperatureLabel
        ])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        setupConstraints(for: stackView)
    }
    
    
    func configure(with forecast: AnyHashable) {
        guard let model = forecast as? Current.DiffableHourly else { return }
        
        timeLabel.text = model.time
        probabilityOfPrecipitationLabel.text = model.probabilityOfPrecipitation
        temperatureLabel.text = model.hourlyTemperature
        weatherIconView.image = UIImage(systemName: model.systemNameString)
    }
    
//    func configure(with hourly: HourlyForecast) {
//        timeLabel.text = hourlyForecast.timeString
//        probabilityOfPrecipitationLabel.text = hourlyForecast.probabilityOfPrecipitationString
//        temperatureLabel.text = hourlyForecast.hourlyTemperatureString
//        weatherIconView.image = UIImage(systemName: hourlyForecast.systemNameString)
//    }
    
    fileprivate func setupConstraints(for uiView: UIView) {
        contentView.addSubview(uiView)
        
        NSLayoutConstraint.activate([
            uiView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            uiView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
