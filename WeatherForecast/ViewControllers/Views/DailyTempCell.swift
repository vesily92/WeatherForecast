//
//  DailyTempCell.swift
//  WeatherForecast
//
//  Created by Василий Пронин on 20.06.2022.
//

import UIKit

class DailyTempCell: UICollectionViewCell {
    static let reuseIdentifier = "DailyTempCell"
    
    private lazy var morningLabel = UILabel(.sf20SemiboldWhite)
    private lazy var dayLabel = UILabel(.sf20SemiboldWhite)
    private lazy var eveningLabel = UILabel(.sf20SemiboldWhite)
    private lazy var nightLabel = UILabel(.sf20SemiboldWhite)

    private lazy var tempHeadingLabel = UILabel(.sf16RegularWhite)
    private lazy var morningTempLabel = UILabel(.sf20SemiboldWhite)
    private lazy var dayTempLabel = UILabel(.sf20SemiboldWhite)
    private lazy var eveningTempLabel = UILabel(.sf20SemiboldWhite)
    private lazy var nightTempLabel = UILabel(.sf20SemiboldWhite)

    private lazy var feelsLikeHeadingLabel = UILabel(.sf16RegularWhite)
    private lazy var morningFeelsLikeLabel = UILabel(.sf20SemiboldBlack)
    private lazy var dayFeelsLikeLabel = UILabel(.sf20SemiboldBlack)
    private lazy var eveningFeelsLikeLabel = UILabel(.sf20SemiboldBlack)
    private lazy var nightFeelsLikeLabel = UILabel(.sf20SemiboldBlack)
    
    private lazy var morningSymbol = UIImageView(.monochromeSymbol)
    private lazy var daySymbol = UIImageView(.monochromeSymbol)
    private lazy var eveningSymbol = UIImageView(.monochromeSymbol)
    private lazy var nightSymbol = UIImageView(.monochromeSymbol)
    
    private lazy var headerLabel = UILabel(.heading16SemiboldBlack)
    private lazy var secondHeaderLabel = UILabel(.heading16SemiboldBlack)
    
    private lazy var headerIcon = UIImageView(.headingSymbol)
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .systemGray2
        contentView.layer.cornerRadius = 12
        
        headerIcon.translatesAutoresizingMaskIntoConstraints = false
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(headerIcon)
        contentView.addSubview(headerLabel)
        
        
        let nameStack = UIStackView(arrangedSubviews: [
            morningLabel,
            dayLabel,
            eveningLabel,
            nightLabel
        ])
        nameStack.axis = .vertical
        nameStack.alignment = .leading
        nameStack.distribution = .equalCentering
        nameStack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(nameStack)
        
        let tempStack = UIStackView(arrangedSubviews: [
            tempHeadingLabel,
            morningTempLabel,
            dayTempLabel,
            eveningTempLabel,
            nightTempLabel
        ])
        tempStack.axis = .vertical
        tempStack.alignment = .trailing
        tempStack.distribution = .equalCentering
        tempStack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(tempStack)
        
        let symbolStack = UIStackView(arrangedSubviews: [
            morningSymbol,
            daySymbol,
            eveningSymbol,
            nightSymbol
        ])
        symbolStack.axis = .vertical
        symbolStack.alignment = .center
        symbolStack.distribution = .fillEqually
        
        let feelsLikeTempStack = UIStackView(arrangedSubviews: [
            morningFeelsLikeLabel,
            dayFeelsLikeLabel,
            eveningFeelsLikeLabel,
            nightFeelsLikeLabel
        ])
        feelsLikeTempStack.axis = .vertical
        feelsLikeTempStack.alignment = .trailing
        feelsLikeTempStack.distribution = .equalCentering
        
        let horizontalFLStack = UIStackView(arrangedSubviews: [
            symbolStack,
            feelsLikeTempStack
        ])
        horizontalFLStack.axis = .horizontal
        horizontalFLStack.spacing = 5
        
        
        let feelsLikeStack = UIStackView(arrangedSubviews: [
            feelsLikeHeadingLabel,
            horizontalFLStack
        ])
        feelsLikeStack.axis = .vertical
        feelsLikeStack.alignment = .trailing
        feelsLikeStack.distribution = .equalCentering
        feelsLikeStack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(feelsLikeStack)
 
        NSLayoutConstraint.activate([
            headerIcon.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            headerIcon.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            
            headerLabel.leadingAnchor.constraint(equalTo: headerIcon.trailingAnchor, constant: 5),
            headerLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            
            nameStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nameStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            
            feelsLikeStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            feelsLikeStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            
            tempStack.trailingAnchor.constraint(equalTo: feelsLikeStack.leadingAnchor, constant: -32),
            tempStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            tempStack.heightAnchor.constraint(equalTo: feelsLikeStack.heightAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with model: Daily, andTimeZoneOffset offset: Int) {
        headerIcon.image = UIImage(systemName: "thermometer")
        headerLabel.text = DateFormatter.format(model.dt, to: .date, withTimeZoneOffset: offset)
        
        morningLabel.text = "Morning:"
        dayLabel.text = "Day:"
        eveningLabel.text = "Evening:"
        nightLabel.text = "Night:"
        
        tempHeadingLabel.text = "Temperature:"
        morningTempLabel.text = model.temperature.morn.displayTemp()
        dayTempLabel.text = model.temperature.day.displayTemp()
        eveningTempLabel.text = model.temperature.eve.displayTemp()
        nightTempLabel.text = model.temperature.night.displayTemp()
        
        feelsLikeHeadingLabel.text = "Feels Like:"
        morningFeelsLikeLabel.text = model.feelsLike.morn.displayTemp()
        dayFeelsLikeLabel.text = model.feelsLike.day.displayTemp()
        eveningFeelsLikeLabel.text = model.feelsLike.eve.displayTemp()
        nightFeelsLikeLabel.text = model.feelsLike.night.displayTemp()
        
        morningSymbol.image = UIImage(systemName: getMoreOrLessSymbol(
            comparing: model.temperature.morn,
            and: model.feelsLike.morn)
        )
        daySymbol.image = UIImage(systemName: getMoreOrLessSymbol(
            comparing: model.temperature.day,
            and: model.feelsLike.day)
        )
        eveningSymbol.image = UIImage(systemName: getMoreOrLessSymbol(
            comparing: model.temperature.eve,
            and: model.feelsLike.eve)
        )
        nightSymbol.image = UIImage(systemName: getMoreOrLessSymbol(
            comparing: model.temperature.night,
            and: model.feelsLike.night)
        )
    }
    
    fileprivate func getMoreOrLessSymbol(comparing realTemp: Double, and feelsLikeTemp: Double) -> String {
        if realTemp.roundDecimal() > feelsLikeTemp.roundDecimal() {
            return "chevron.down"
        } else if realTemp.roundDecimal() < feelsLikeTemp.roundDecimal() {
            return "chevron.up"
        } else {
            return ""
        }
    }
}
