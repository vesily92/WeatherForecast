//
//  ConditionsCellOLD.swift
//  WeatherForecast
//
//  Created by Василий Пронин on 25.06.2022.
//

import UIKit

//class ConditionsCellOLD: UICollectionViewCell {
//
//    enum InfoType: Int {
//        case uviAndHumidity
//        case pressureAndWind
//    }
//
//    static let reuseIdentifier = "MeteorologicInfoCell"
//
//    private lazy var leftHeaderLabel = UILabel(.mainText20, color: .gray)
//    private lazy var leftTitleLabel = UILabel(.largeText26)
//    private lazy var leftSecondaryLabel = UILabel(.mainText20)
//    private lazy var leftTempLabel = UILabel(.mainText20)
//    private lazy var leftSubtitleLabel = UILabel(.specificationText16)
//
//    private lazy var leftHeaderIcon = UIImageView(.monochrome(.gray))
//    private lazy var leftCellBackgroundView = UIView()
//
//    private lazy var rightHeaderLabel = UILabel(.mainText20, color: .gray)
//    private lazy var rightTitleLabel = UILabel(.largeText26)
//    private lazy var rightSecondaryLabel = UILabel(.mainText20)
//    private lazy var rightTempLabel = UILabel(.mainText20)
//    private lazy var rightSubtitleLabel = UILabel(.specificationText16)
//
//    private lazy var rightHeaderIcon = UIImageView(.monochrome(.gray))
//    private lazy var rightCellBackgroundView = UIView()
//
//    private lazy var symbolView = UIImageView(.monochrome(.white, size: .large))
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//
//        leftCellBackgroundView.backgroundColor = .systemGray2
//        leftCellBackgroundView.layer.cornerRadius = 12
//        leftCellBackgroundView.translatesAutoresizingMaskIntoConstraints = false
//        contentView.addSubview(leftCellBackgroundView)
//
//        rightCellBackgroundView.backgroundColor = .systemGray2
//        rightCellBackgroundView.layer.cornerRadius = 12
//        rightCellBackgroundView.translatesAutoresizingMaskIntoConstraints = false
//        contentView.addSubview(rightCellBackgroundView)
//
//        leftHeaderIcon.translatesAutoresizingMaskIntoConstraints = false
//        leftHeaderLabel.translatesAutoresizingMaskIntoConstraints = false
//        rightHeaderIcon.translatesAutoresizingMaskIntoConstraints = false
//        rightHeaderLabel.translatesAutoresizingMaskIntoConstraints = false
//        contentView.addSubview(leftHeaderIcon)
//        contentView.addSubview(leftHeaderLabel)
//        contentView.addSubview(rightHeaderIcon)
//        contentView.addSubview(rightHeaderLabel)
//
//        NSLayoutConstraint.activate([
//            leftCellBackgroundView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
//            leftCellBackgroundView.trailingAnchor.constraint(equalTo: contentView.centerXAnchor, constant: -8),
//            leftCellBackgroundView.topAnchor.constraint(equalTo: contentView.topAnchor),
//            leftCellBackgroundView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
//
//            rightCellBackgroundView.leadingAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 8),
//            rightCellBackgroundView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
//            rightCellBackgroundView.topAnchor.constraint(equalTo: contentView.topAnchor),
//            rightCellBackgroundView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
//
//            leftHeaderIcon.leadingAnchor.constraint(equalTo: leftCellBackgroundView.leadingAnchor, constant: 16),
//            leftHeaderIcon.topAnchor.constraint(equalTo: leftCellBackgroundView.topAnchor, constant: 12),
//
//            leftHeaderLabel.leadingAnchor.constraint(equalTo: leftHeaderIcon.trailingAnchor, constant: 5),
//            leftHeaderLabel.topAnchor.constraint(equalTo: leftCellBackgroundView.topAnchor, constant: 12),
//
//            rightHeaderIcon.leadingAnchor.constraint(equalTo: rightCellBackgroundView.leadingAnchor, constant: 16),
//            rightHeaderIcon.topAnchor.constraint(equalTo: rightCellBackgroundView.topAnchor, constant: 12),
//
//            rightHeaderLabel.leadingAnchor.constraint(equalTo: rightHeaderIcon.trailingAnchor, constant: 5),
//            rightHeaderLabel.topAnchor.constraint(equalTo: rightCellBackgroundView.topAnchor, constant: 12),
//        ])
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    override func prepareForReuse() {
//        super.prepareForReuse()
//
//        leftHeaderLabel.text = nil
//        leftTitleLabel.text = nil
//        leftSecondaryLabel.text = nil
//        leftTempLabel.text = nil
//        leftSubtitleLabel.text = nil
//
//        rightHeaderLabel.text = nil
//        rightTitleLabel.text = nil
//        rightSecondaryLabel.text = nil
//        rightTempLabel.text = nil
//        rightSubtitleLabel.text = nil
//
//        symbolView.image = nil
//    }
//
//    func configure(for infoType: InfoType, with model: Daily) {
//
//        switch infoType {
//        case .uviAndHumidity:
//            leftHeaderIcon.image = UIImage(systemName: "sun.max.fill")
//            leftHeaderLabel.text = "UV Index"
//            leftTitleLabel.text = "\(model.uvi)"
//            leftSecondaryLabel.text = getUVIDescription(model: model)
//            leftSubtitleLabel.text = "The maximum value of UV index for the day"
//
//            rightHeaderIcon.image = UIImage(systemName: "humidity.fill")
//            rightHeaderLabel.text = "Humidity"
//            rightTitleLabel.text = "\(model.humidity) %"
//            rightSubtitleLabel.text = "The dew point is \(model.dewPoint.displayTemp())"
//
//            setupUVIAndHumidityConstraints()
//        case .pressureAndWind:
//            leftHeaderIcon.image = UIImage(systemName: "barometer")
//            leftHeaderLabel.text = "Pressure"
//            leftTitleLabel.text = model.pressure.displayPressure()
//            leftSecondaryLabel.text = "mm Hg"
//
//            rightHeaderIcon.image = UIImage(systemName: "wind")
//            rightHeaderLabel.text = "Wind"
//            rightTitleLabel.text = "\(model.windSpeed) m/s"
//            symbolView.image = UIImage(systemName: getWindIcon(model: model))
//            rightSecondaryLabel.text = getWindDirection(model: model)
//
//            setupPressureAndWindConstraints()
//        }
//    }
//}

// - MARK: Constraints

//extension ConditionsCellOLD {
//
//    fileprivate func setupUVIAndHumidityConstraints() {
//        leftSubtitleLabel.numberOfLines = 0
//        leftSubtitleLabel.translatesAutoresizingMaskIntoConstraints = false
//        contentView.addSubview(leftSubtitleLabel)
//
//        rightSubtitleLabel.numberOfLines = 0
//        rightSubtitleLabel.translatesAutoresizingMaskIntoConstraints = false
//        contentView.addSubview(rightSubtitleLabel)
//
//        let leftStack = UIStackView(arrangedSubviews: [
//            leftTitleLabel,
//            leftSecondaryLabel,
//        ])
//        leftStack.axis = .vertical
//        leftStack.alignment = .leading
//        leftStack.translatesAutoresizingMaskIntoConstraints = false
//        contentView.addSubview(leftStack)
//
//        let rightStack = UIStackView(arrangedSubviews: [
//            rightTitleLabel
//        ])
//        rightStack.axis = .vertical
//        rightStack.alignment = .leading
//        rightStack.translatesAutoresizingMaskIntoConstraints = false
//        contentView.addSubview(rightStack)
//
//        NSLayoutConstraint.activate([
//            leftStack.leadingAnchor.constraint(equalTo: leftCellBackgroundView.leadingAnchor, constant: 16),
//            leftStack.trailingAnchor.constraint(equalTo: leftCellBackgroundView.trailingAnchor, constant: -16),
//            leftStack.topAnchor.constraint(equalTo: leftHeaderLabel.bottomAnchor, constant: 10),
//
//            leftSubtitleLabel.leadingAnchor.constraint(equalTo: leftCellBackgroundView.leadingAnchor, constant: 16),
//            leftSubtitleLabel.trailingAnchor.constraint(equalTo: leftCellBackgroundView.trailingAnchor, constant: -16),
//            leftSubtitleLabel.bottomAnchor.constraint(equalTo: leftCellBackgroundView.bottomAnchor, constant: -10),
//
//            rightStack.leadingAnchor.constraint(equalTo: rightCellBackgroundView.leadingAnchor, constant: 16),
//            rightStack.trailingAnchor.constraint(equalTo: rightCellBackgroundView.trailingAnchor, constant: -16),
//            rightStack.topAnchor.constraint(equalTo: rightHeaderLabel.bottomAnchor, constant: 10),
//
//            rightSubtitleLabel.leadingAnchor.constraint(equalTo: rightCellBackgroundView.leadingAnchor, constant: 16),
//            rightSubtitleLabel.trailingAnchor.constraint(equalTo: rightCellBackgroundView.trailingAnchor, constant: -16),
//            rightSubtitleLabel.bottomAnchor.constraint(equalTo: rightCellBackgroundView.bottomAnchor, constant: -10)
//        ])
//    }
//
//    fileprivate func setupPressureAndWindConstraints() {
//        let leftStack = UIStackView(arrangedSubviews: [
//            leftTitleLabel,
//            leftSecondaryLabel,
//        ])
//        leftStack.axis = .vertical
//        leftStack.alignment = .leading
//        leftStack.translatesAutoresizingMaskIntoConstraints = false
//        contentView.addSubview(leftStack)
//
//        let rightStack = UIStackView(arrangedSubviews: [
//            symbolView,
//            rightSecondaryLabel
//        ])
//        rightStack.axis = .horizontal
//
//        rightStack.alignment = .leading
//        rightStack.spacing = 12
//        rightStack.translatesAutoresizingMaskIntoConstraints = false
//        contentView.addSubview(rightStack)
//
//        rightTitleLabel.translatesAutoresizingMaskIntoConstraints = false
//        contentView.addSubview(rightTitleLabel)
//
//        NSLayoutConstraint.activate([
//            leftStack.leadingAnchor.constraint(equalTo: leftCellBackgroundView.leadingAnchor, constant: 16),
//            leftStack.trailingAnchor.constraint(equalTo: leftCellBackgroundView.trailingAnchor, constant: -16),
//            leftStack.topAnchor.constraint(equalTo: leftHeaderLabel.bottomAnchor, constant: 10),
//
//            rightTitleLabel.leadingAnchor.constraint(equalTo: rightCellBackgroundView.leadingAnchor, constant: 16),
//            rightTitleLabel.topAnchor.constraint(equalTo: rightHeaderLabel.bottomAnchor, constant: 10),
//
//            rightStack.topAnchor.constraint(equalTo: rightTitleLabel.bottomAnchor, constant: 12),
//            rightStack.leadingAnchor.constraint(equalTo: rightCellBackgroundView.leadingAnchor, constant: 16)
//        ])
//    }
//}

// - MARK: Helpers

//extension ConditionsCellOLD {
//    
//    fileprivate func getUVIDescription(model: Daily) -> String {
//        switch model.uvi {
//        case 0...3: return "Low"
//        case 3...6: return "Moderate"
//        case 6...8: return "High"
//        case 8...10: return "Very High"
//        default: return ""
//        }
//    }
//    
//    fileprivate func getWindIcon(model: Daily) -> String {
//        switch model.windDeg {
//        case 338...360, 0...23: return "arrow.up.circle.fill" //"arrow.up"
//        case 23...68: return "arrow.up.right.circle.fill" //"arrow.up.right"
//        case 69...113: return "arrow.right.circle.fill" //"arrow.right"
//        case 114...158: return "arrow.down.right.circle.fill" //"arrow.down.right"
//        case 159...203: return "arrow.down.circle.fill" //"arrow.down"
//        case 204...248: return "arrow.down.left.circle.fill" //"arrow.down.left"
//        case 249...293: return "arrow.left.circle.fill" //"arrow.left"
//        case 293...337: return "arrow.up.left.circle.fill" //"arrow.up.left"
//        default: return "nosign"
//        }
//    }
//    
//    fileprivate func getWindDirection(model: Daily) -> String {
//        switch model.windDeg {
//        case 349...360, 0...11: return "N"
//        case 12...33: return "NNE"
//        case 34...56: return "NE"
//        case 57...78: return "ENE"
//        case 79...101: return "E"
//        case 102...123: return "ESE"
//        case 124...146: return "SE"
//        case 147...168: return "SSE"
//        case 169...191: return "S"
//        case 192...213: return "SSW"
//        case 214...236: return "SW"
//        case 237...258: return "WSW"
//        case 259...281: return "W"
//        case 282...303: return "WNW"
//        case 304...326: return "NW"
//        case 327...348: return "NNW"
//        default: return ""
//        }
//    }
//    
//    fileprivate func getMoreOrLessSymbol(comparing firstNum: Double, and secondNum: Double) -> String {
//        if firstNum > secondNum {
//            return "chevron.up"
//        } else if firstNum < secondNum {
//            return "chevron.down"
//        } else {
//            return ""
//        }
//    }
//}
