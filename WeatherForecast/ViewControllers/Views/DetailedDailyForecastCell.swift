//
//  DetailedDailyForecastCell.swift
//  WeatherForecast
//
//  Created by Василий Пронин on 20.06.2022.
//

import UIKit

class DetailedDailyForecastCell: UICollectionViewCell {
    enum DetailedInfoType {
//        case sunrise
        case temp
        case feelsLike
        case pressure
        case humidity
        case wind
        case uvi
    }
    
    static let reuseIdentifier = "DetailedDailyForecastCell"
//    
//    lazy var isSunrise: Bool = true
    
    private lazy var headerLabel = UILabel(.heading16semiboldBlack)
    private lazy var titleLabel = UILabel(.main26semiboldWhite)
    private lazy var secondaryLabel = UILabel(.main20semiboldWhite)
    private lazy var subtitleLabel = UILabel(.secondary16regularWhite)
    
    private lazy var tempLabel = UILabel(.main20semiboldWhite)
    
    private lazy var headerIcon = UIImageView()
    private lazy var infoIcon = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        subtitleLabel.numberOfLines = 0
        secondaryLabel.numberOfLines = 0
        
        tempLabel.numberOfLines = 0
        tempLabel.translatesAutoresizingMaskIntoConstraints = false
        
        headerIcon.contentMode = .scaleAspectFit
        headerIcon.tintColor = .black
        headerIcon.alpha = 0.3
        headerIcon.translatesAutoresizingMaskIntoConstraints = false
        
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        
        infoIcon.contentMode = .scaleAspectFit
        infoIcon.tintColor = .white
        infoIcon.preferredSymbolConfiguration = .init(font: .systemFont(ofSize: 40))
        
//        contentView.backgroundColor = .systemGray2
        contentView.layer.cornerRadius = 12
        
        let containerView = UIStackView(arrangedSubviews: [
            titleLabel,
            secondaryLabel,
            infoIcon,
            subtitleLabel
        ])
        containerView.axis = .vertical
        containerView.alignment = .leading
        containerView.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(headerIcon)
        contentView.addSubview(headerLabel)
        
        NSLayoutConstraint.activate([
            headerIcon.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            headerIcon.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            
            headerLabel.leadingAnchor.constraint(equalTo: headerIcon.trailingAnchor, constant: 5),
            headerLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(for infoType: DetailedInfoType, with model: Daily) {
        switch infoType {
        case .temp:
//            secondaryLabel.text = "Temperature:"
            headerIcon.image = UIImage(systemName: "thermometer")
            headerLabel.text = "Temperature"
            secondaryLabel.text = "Morning: \nDay: \nEvening: \nNight:"
            tempLabel.text = "\(model.temperature.morn.displayTemp())\n\(model.temperature.day.displayTemp())\n\(model.temperature.eve.displayTemp())\n\(model.temperature.night.displayTemp())"
            contentView.backgroundColor = .systemTeal
            setupConstraintsFor(.temp)
        case .feelsLike:
            headerIcon.image = UIImage(systemName: "hand.raised")
            headerLabel.text = "Feels Like"
            secondaryLabel.text = "Morning:\nDay:\nEvening:\nNight:"
            tempLabel.text = "\(model.feelsLike.morn.displayTemp())\n\(model.feelsLike.day.displayTemp())\n\(model.feelsLike.eve.displayTemp())\n\(model.feelsLike.night.displayTemp())"
            contentView.backgroundColor = .systemOrange
            setupConstraintsFor(.feelsLike)
//        case .sunrise:
//            headerIcon.image = UIImage(systemName: isSunrise
//                                       ? "sunrise.fill"
//                                       : "sunset.fill")
//            headerLabel.text = isSunrise ? "Sunrise" : "Sunset"
//            titleLabel.text = isSunrise
//            ? DateFormatter.format(model.sunrise, to: .sunrise, withTimeZoneOffset: offset)
//            : DateFormatter.format(model.sunset, to: .sunrise, withTimeZoneOffset: offset)
//            subtitleLabel.text = isSunrise
//            ? "Sunset: " + DateFormatter.format(model.sunset, to: .sunrise, withTimeZoneOffset: offset)
//            : "Sunrise: " + DateFormatter.format(model.sunrise, to: .sunrise, withTimeZoneOffset: offset)
        case .pressure:
            headerIcon.image = UIImage(systemName: "barometer")
            headerLabel.text = "Pressure"
            titleLabel.text = model.pressure.displayPressure()
            secondaryLabel.text = "mm Hg"
            contentView.backgroundColor = .systemGray2
            setupConstraintsFor(.pressure)
        case .humidity:
            headerIcon.image = UIImage(systemName: "humidity.fill")
            headerLabel.text = "Humidity"
            titleLabel.text = "\(model.humidity) %"
            subtitleLabel.text = "The dew point is \(model.dewPoint.displayTemp())"
            contentView.backgroundColor = .systemPink
            setupConstraintsFor(.humidity)
        case .wind:
            headerIcon.image = UIImage(systemName: "wind")
            headerLabel.text = "Wind"
            titleLabel.text = "\(model.windSpeed) m/s"
            infoIcon.image = UIImage(systemName: getWindIcon(model: model))
            subtitleLabel.text = getWindDirection(model: model)
            contentView.backgroundColor = .systemGreen
            setupConstraintsFor(.wind)
        case .uvi:
            headerIcon.image = UIImage(systemName: "sun.max.fill")
            headerLabel.text = "UV Index"
            titleLabel.text = "\(model.uvi)"
            secondaryLabel.text = getUVIDescription(model: model)
            subtitleLabel.text = "The maximum value of UV index for the day"
            contentView.backgroundColor = .purple
            setupConstraintsFor(.uvi)
        }
    }
    
    fileprivate func setupConstraintsFor(_ infoType: DetailedInfoType) {
        switch infoType {
        case .temp:
            setupTempConstraints()
        case .feelsLike:
            setupTempConstraints()
        case .pressure:
            setupPressureConstraints()
        case .humidity:
            setupPressureConstraints()
        case .wind:
            setupWindConstraints()
        case .uvi:
            setupPressureConstraints()
        }
    }
    
    fileprivate func setupTempConstraints() {
        contentView.addSubview(tempLabel)
        contentView.addSubview(secondaryLabel)
        
        NSLayoutConstraint.activate([
  
            secondaryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            secondaryLabel.topAnchor.constraint(equalTo: headerIcon.topAnchor, constant: 10),
            secondaryLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),

            tempLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            tempLabel.topAnchor.constraint(equalTo: headerLabel.topAnchor, constant: 10),
            tempLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }
    
    fileprivate func setupPressureConstraints() {
        let stack = UIStackView(arrangedSubviews: [
            titleLabel,
            secondaryLabel,
            subtitleLabel
        ])
        stack.axis = .vertical
        stack.alignment = .leading
        stack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stack.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 10)
        ])
    }
    
    fileprivate func setupUVConstraints() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 10),
            
            
        ])
    }
    
    fileprivate func setupWindConstraints() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(infoIcon)
        contentView.addSubview(subtitleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 10),

            infoIcon.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            infoIcon.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),

            subtitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            subtitleLabel.centerYAnchor.constraint(equalTo: infoIcon.centerYAnchor)
            
        ])
    }
    
    fileprivate func getUVIDescription(model: Daily) -> String {
        switch model.uvi {
        case 0...3: return "Low"
        case 3...6: return "Moderate"
        case 6...8: return "High"
        case 8...10: return "Very High"
        default: return ""
        }
    }
    
    fileprivate func getWindIcon(model: Daily) -> String {
        switch model.windDeg {
        case 338...360, 0...23: return "arrow.up.circle.fill" //"arrow.up"
        case 23...68: return "arrow.up.right.circle.fill" //"arrow.up.right"
        case 69...113: return "arrow.right.circle.fill" //"arrow.right"
        case 114...158: return "arrow.down.right.circle.fill" //"arrow.down.right"
        case 159...203: return "arrow.down.circle.fill" //"arrow.down"
        case 204...248: return "arrow.down.left.circle.fill" //"arrow.down.left"
        case 249...293: return "arrow.left.circle.fill" //"arrow.left"
        case 293...337: return "arrow.up.left.circle.fill" //"arrow.up.left"
        default: return "nosign"
        }
    }
    
    fileprivate func getWindDirection(model: Daily) -> String {
        switch model.windDeg {
        case 349...360, 0...11: return "N"
        case 12...33: return "NNE"
        case 34...56: return "NE"
        case 57...78: return "ENE"
        case 79...101: return "E"
        case 102...123: return "ESE"
        case 124...146: return "SE"
        case 147...168: return "SSE"
        case 169...191: return "S"
        case 192...213: return "SSW"
        case 214...236: return "SW"
        case 237...258: return "WSW"
        case 259...281: return "W"
        case 282...303: return "WNW"
        case 304...326: return "NW"
        case 327...348: return "NNW"
        default: return ""
        }
    }
}
