//
//  MeteorologicInfoCell.swift
//  WeatherForecast
//
//  Created by Василий Пронин on 25.06.2022.
//

import UIKit

class MeteorologicInfoCell: UICollectionViewCell {
    enum InfoType: Int {
        case tempAndFeelsLike
        case uviAndHumidity
        case pressureAndWind
    }
    
    static let reuseIdentifier = "MeteorologicInfoCell"
//
//    lazy var isSunrise: Bool = true
    
    private lazy var leftHeaderLabel = UILabel(.heading16SemiboldBlack)
    private lazy var leftTitleLabel = UILabel(.sf26SemiboldWhite)
    private lazy var leftSecondaryLabel = UILabel(.sf20SemiboldWhite)
    private lazy var leftTempLabel = UILabel(.sf20SemiboldWhite)
    private lazy var leftSubtitleLabel = UILabel(.sf16RegularWhite)
    
    private lazy var leftHeaderIcon = UIImageView(.headingSymbol)
    private lazy var leftCellBackgroundView = UIView()
    
    private lazy var rightHeaderLabel = UILabel(.heading16SemiboldBlack)
    private lazy var rightTitleLabel = UILabel(.sf26SemiboldWhite)
    private lazy var rightSecondaryLabel = UILabel(.sf20SemiboldWhite)
    private lazy var rightTempLabel = UILabel(.sf20SemiboldBlack)
    private lazy var rightSubtitleLabel = UILabel(.sf16RegularWhite)
    
    private lazy var rightHeaderIcon = UIImageView(.headingSymbol)
    private lazy var rightCellBackgroundView = UIView()
    
    private lazy var infoIcon = UIImageView(.infoSymbol)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        leftCellBackgroundView.backgroundColor = .systemGray2
        leftCellBackgroundView.layer.cornerRadius = 12
        leftCellBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(leftCellBackgroundView)
        
        rightCellBackgroundView.backgroundColor = .systemGray2
        rightCellBackgroundView.layer.cornerRadius = 12
        rightCellBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(rightCellBackgroundView)
        
        leftHeaderIcon.translatesAutoresizingMaskIntoConstraints = false
        leftHeaderLabel.translatesAutoresizingMaskIntoConstraints = false
        rightHeaderIcon.translatesAutoresizingMaskIntoConstraints = false
        rightHeaderLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(leftHeaderIcon)
        contentView.addSubview(leftHeaderLabel)
        contentView.addSubview(rightHeaderIcon)
        contentView.addSubview(rightHeaderLabel)
        
        NSLayoutConstraint.activate([
            leftCellBackgroundView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            leftCellBackgroundView.trailingAnchor.constraint(equalTo: contentView.centerXAnchor, constant: -8),
            leftCellBackgroundView.topAnchor.constraint(equalTo: contentView.topAnchor),
            leftCellBackgroundView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            rightCellBackgroundView.leadingAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 8),
            rightCellBackgroundView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            rightCellBackgroundView.topAnchor.constraint(equalTo: contentView.topAnchor),
            rightCellBackgroundView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            leftHeaderIcon.leadingAnchor.constraint(equalTo: leftCellBackgroundView.leadingAnchor, constant: 16),
            leftHeaderIcon.topAnchor.constraint(equalTo: leftCellBackgroundView.topAnchor, constant: 12),
            
            leftHeaderLabel.leadingAnchor.constraint(equalTo: leftHeaderIcon.trailingAnchor, constant: 5),
            leftHeaderLabel.topAnchor.constraint(equalTo: leftCellBackgroundView.topAnchor, constant: 12),
            
            rightHeaderIcon.leadingAnchor.constraint(equalTo: rightCellBackgroundView.leadingAnchor, constant: 16),
            rightHeaderIcon.topAnchor.constraint(equalTo: rightCellBackgroundView.topAnchor, constant: 12),
            
            rightHeaderLabel.leadingAnchor.constraint(equalTo: rightHeaderIcon.trailingAnchor, constant: 5),
            rightHeaderLabel.topAnchor.constraint(equalTo: rightCellBackgroundView.topAnchor, constant: 12),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(for infoType: InfoType, with model: Daily, andTimeZoneOffset offset: Int) {
        switch infoType {
        case .tempAndFeelsLike:
            leftHeaderIcon.image = UIImage(systemName: "thermometer")
            leftHeaderLabel.text = DateFormatter.format(model.dt, to: .date, withTimeZoneOffset: offset)
            leftSecondaryLabel.text = "Morning: \nDay: \nEvening: \nNight:"
//            leftTempLabel.text = "\(model.temperature.morn.displayTemp())\n\(model.temperature.day.displayTemp())\n\(model.temperature.eve.displayTemp())\n\(model.temperature.night.displayTemp())"
            
//            rightHeaderIcon.image = UIImage(systemName: "hand.raised")
//            rightHeaderLabel.text = "Feels Like"
            
            rightSecondaryLabel.text = "\(model.temperature.morn.displayTemp())\n\(model.temperature.day.displayTemp())\n\(model.temperature.eve.displayTemp())\n\(model.temperature.night.displayTemp())"
            rightTempLabel.text = "\(model.feelsLike.morn.displayTemp())\n\(model.feelsLike.day.displayTemp())\n\(model.feelsLike.eve.displayTemp())\n\(model.feelsLike.night.displayTemp())"
            
            contentView.backgroundColor = .systemGray2
            contentView.layer.cornerRadius = 12
            
            setupTempAndFeelsLikeConstraints()
            
        case .uviAndHumidity:
            leftHeaderIcon.image = UIImage(systemName: "sun.max.fill")
            leftHeaderLabel.text = "UV Index"
            leftTitleLabel.text = "\(model.uvi)"
            leftSecondaryLabel.text = getUVIDescription(model: model)
            leftSubtitleLabel.text = "The maximum value of UV index for the day"
            
            rightHeaderIcon.image = UIImage(systemName: "humidity.fill")
            rightHeaderLabel.text = "Humidity"
            rightTitleLabel.text = "\(model.humidity) %"
            rightSubtitleLabel.text = "The dew point is \(model.dewPoint.displayTemp())"
            
            setupUVIAndHumidityConstraints()
            
        case .pressureAndWind:
            leftHeaderIcon.image = UIImage(systemName: "barometer")
            leftHeaderLabel.text = "Pressure"
            leftTitleLabel.text = model.pressure.displayPressure()
            leftSecondaryLabel.text = "mm Hg"
            
            rightHeaderIcon.image = UIImage(systemName: "wind")
            rightHeaderLabel.text = "Wind"
            rightTitleLabel.text = "\(model.windSpeed) m/s"
            infoIcon.image = UIImage(systemName: getWindIcon(model: model))
            rightSubtitleLabel.text = getWindDirection(model: model)
            
            setupPressureAndWindConstraints()
        }
    }
    
    fileprivate func setupTempAndFeelsLikeConstraints() {
        leftSecondaryLabel.numberOfLines = 0
        leftSecondaryLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(leftSecondaryLabel)
        
        leftTempLabel.numberOfLines = 0
        leftTempLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(leftTempLabel)
        
        rightSecondaryLabel.numberOfLines = 0
        rightSecondaryLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(rightSecondaryLabel)
        
        rightTempLabel.numberOfLines = 0
        rightTempLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(rightTempLabel)
        
        
        NSLayoutConstraint.activate([
            leftSecondaryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            leftSecondaryLabel.topAnchor.constraint(equalTo: leftHeaderLabel.topAnchor, constant: 10),
            leftSecondaryLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),

            leftTempLabel.trailingAnchor.constraint(equalTo: contentView.centerXAnchor, constant: -16),
            leftTempLabel.topAnchor.constraint(equalTo: leftHeaderLabel.topAnchor, constant: 10),
            leftTempLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            
            rightSecondaryLabel.leadingAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 16),
            rightSecondaryLabel.topAnchor.constraint(equalTo: rightHeaderLabel.topAnchor, constant: 10),
            rightSecondaryLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            
            rightTempLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            rightTempLabel.topAnchor.constraint(equalTo: rightHeaderLabel.topAnchor, constant: 10),
            rightTempLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }
    
    fileprivate func setupUVIAndHumidityConstraints() {
        leftSubtitleLabel.numberOfLines = 0
        leftSubtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(leftSubtitleLabel)
        
        rightSubtitleLabel.numberOfLines = 0
        rightSubtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(rightSubtitleLabel)
        
        let leftStack = UIStackView(arrangedSubviews: [
            leftTitleLabel,
            leftSecondaryLabel,
        ])
        leftStack.axis = .vertical
        leftStack.alignment = .leading
        leftStack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(leftStack)
        
        let rightStack = UIStackView(arrangedSubviews: [
            rightTitleLabel,
            rightSecondaryLabel,
        ])
        rightStack.axis = .vertical
        rightStack.alignment = .leading
        rightStack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(rightStack)
        
        NSLayoutConstraint.activate([
            leftStack.leadingAnchor.constraint(equalTo: leftCellBackgroundView.leadingAnchor, constant: 16),
            leftStack.trailingAnchor.constraint(equalTo: leftCellBackgroundView.trailingAnchor, constant: -16),
            leftStack.topAnchor.constraint(equalTo: leftHeaderLabel.bottomAnchor, constant: 10),
            
            leftSubtitleLabel.leadingAnchor.constraint(equalTo: leftCellBackgroundView.leadingAnchor, constant: 16),
            leftSubtitleLabel.trailingAnchor.constraint(equalTo: leftCellBackgroundView.trailingAnchor, constant: -16),
            leftSubtitleLabel.bottomAnchor.constraint(equalTo: leftCellBackgroundView.bottomAnchor, constant: -10),
            
            rightStack.leadingAnchor.constraint(equalTo: rightCellBackgroundView.leadingAnchor, constant: 16),
            rightStack.trailingAnchor.constraint(equalTo: rightCellBackgroundView.trailingAnchor, constant: -16),
            rightStack.topAnchor.constraint(equalTo: rightHeaderLabel.bottomAnchor, constant: 10),
            
            rightSubtitleLabel.leadingAnchor.constraint(equalTo: rightCellBackgroundView.leadingAnchor, constant: 16),
            rightSubtitleLabel.trailingAnchor.constraint(equalTo: rightCellBackgroundView.trailingAnchor, constant: -16),
            rightSubtitleLabel.bottomAnchor.constraint(equalTo: rightCellBackgroundView.bottomAnchor, constant: -10)
        ])
    }
    
    fileprivate func setupPressureAndWindConstraints() {
//        leftTitleLabel.translatesAutoresizingMaskIntoConstraints = false
//        leftSecondaryLabel.translatesAutoresizingMaskIntoConstraints = false
//
        let leftStack = UIStackView(arrangedSubviews: [
            leftTitleLabel,
            leftSecondaryLabel,
        ])
        leftStack.axis = .vertical
        leftStack.alignment = .leading
        leftStack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(leftStack)
        
        rightTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        rightSubtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        infoIcon.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(rightTitleLabel)
        contentView.addSubview(infoIcon)
        contentView.addSubview(rightSubtitleLabel)
        
        NSLayoutConstraint.activate([
            leftStack.leadingAnchor.constraint(equalTo: leftCellBackgroundView.leadingAnchor, constant: 16),
            leftStack.trailingAnchor.constraint(equalTo: leftCellBackgroundView.trailingAnchor, constant: -16),
            leftStack.topAnchor.constraint(equalTo: leftHeaderLabel.bottomAnchor, constant: 10),
            
            rightTitleLabel.leadingAnchor.constraint(equalTo: rightCellBackgroundView.leadingAnchor, constant: 16),
            rightTitleLabel.topAnchor.constraint(equalTo: rightHeaderLabel.bottomAnchor, constant: 10),

            infoIcon.centerXAnchor.constraint(equalTo: rightCellBackgroundView.centerXAnchor),
            infoIcon.topAnchor.constraint(equalTo: rightTitleLabel.bottomAnchor, constant: 12),
            
            rightSubtitleLabel.leadingAnchor.constraint(equalTo: rightCellBackgroundView.leadingAnchor, constant: 16),
            rightSubtitleLabel.centerYAnchor.constraint(equalTo: infoIcon.centerYAnchor)
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
    
    fileprivate func getMoreOrLessSymbol(comparing firstNum: Double, and secondNum: Double) -> String {
        if firstNum > secondNum {
            return "chevron.up"
        } else if firstNum < secondNum {
            return "chevron.down"
        } else {
            return ""
        }
    }
}
