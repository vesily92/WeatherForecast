//
//  DailyTempCell.swift
//  WeatherForecast
//
//  Created by Василий Пронин on 20.06.2022.
//

import UIKit

class DailyTempCell: UICollectionViewCell {
    static let reuseIdentifier = "DailyTempCell"
    
    private lazy var timeHeadingLabel = UILabel(.specificationText16, color: .gray)
    private lazy var morningLabel = UILabel(.mainText20)
    private lazy var dayLabel = UILabel(.mainText20)
    private lazy var eveningLabel = UILabel(.mainText20)
    private lazy var nightLabel = UILabel(.mainText20)

    private lazy var tempHeadingLabel = UILabel(.specificationText16, color: .gray)
    private lazy var morningTempLabel = UILabel(.mainText20)
    private lazy var dayTempLabel = UILabel(.mainText20)
    private lazy var eveningTempLabel = UILabel(.mainText20)
    private lazy var nightTempLabel = UILabel(.mainText20)

    private lazy var feelsLikeHeadingLabel = UILabel(.specificationText16, color: .gray)
    private lazy var morningFeelsLikeLabel = UILabel(.mainText20, color: .gray)
    private lazy var dayFeelsLikeLabel = UILabel(.mainText20, color: .gray)
    private lazy var eveningFeelsLikeLabel = UILabel(.mainText20, color: .gray)
    private lazy var nightFeelsLikeLabel = UILabel(.mainText20, color: .gray)
    
    private lazy var morningSymbol = UIImageView(.monochrome(.gray))
    private lazy var daySymbol = UIImageView(.monochrome(.gray))
    private lazy var eveningSymbol = UIImageView(.monochrome(.gray))
    private lazy var nightSymbol = UIImageView(.monochrome(.gray))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .systemGray2
        contentView.layer.cornerRadius = 12

        let nameStack = UIStackView(arrangedSubviews: [
            timeHeadingLabel,
            morningLabel,
            dayLabel,
            eveningLabel,
            nightLabel
        ])
        nameStack.axis = .vertical
        nameStack.alignment = .leading
        nameStack.distribution = .fillEqually
        
        let tempStack = UIStackView(arrangedSubviews: [
            tempHeadingLabel,
            morningTempLabel,
            dayTempLabel,
            eveningTempLabel,
            nightTempLabel
        ])
        tempStack.axis = .vertical
        tempStack.alignment = .trailing
        tempStack.distribution = .fillEqually
        
        let morningFLStack = UIStackView(arrangedSubviews: [
            morningFeelsLikeLabel,
            morningSymbol
        ])
        morningFLStack.axis = .horizontal
        morningFLStack.spacing = 20
        
        let dayFLStack = UIStackView(arrangedSubviews: [
            dayFeelsLikeLabel,
            daySymbol
        ])
        dayFLStack.axis = .horizontal
        dayFLStack.spacing = 20
        
        let eveningFLStack = UIStackView(arrangedSubviews: [
            eveningFeelsLikeLabel,
            eveningSymbol
        ])
        eveningFLStack.axis = .horizontal
        eveningFLStack.spacing = 20
        
        let nightFLStack = UIStackView(arrangedSubviews: [
            nightFeelsLikeLabel,
            nightSymbol
        ])
        nightFLStack.axis = .horizontal
        nightFLStack.spacing = 20

        let feelsLikeStack = UIStackView(arrangedSubviews: [
            feelsLikeHeadingLabel,
            morningFLStack,
            dayFLStack,
            eveningFLStack,
            nightFLStack
        ])
        feelsLikeStack.axis = .vertical
        feelsLikeStack.alignment = .trailing
        feelsLikeStack.distribution = .fillEqually
        
        let containerStack = UIStackView(arrangedSubviews: [
            nameStack,
            tempStack,
            feelsLikeStack
        ])
        containerStack.axis = .horizontal
        containerStack.distribution = .fillEqually
        containerStack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(containerStack)
 
        NSLayoutConstraint.activate([
            containerStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            containerStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with model: Daily) {
//        headerIcon.image = UIImage(systemName: "thermometer")
//        headerLabel.text = DateFormatter.format(model.dt, to: .date, withTimeZoneOffset: offset)
        
        timeHeadingLabel.text = "Time"
        morningLabel.text = "Morning:"
        dayLabel.text = "Day:"
        eveningLabel.text = "Evening:"
        nightLabel.text = "Night:"
        
        tempHeadingLabel.text = "Temperature"
        morningTempLabel.text = model.temperature.morn.displayTemp()
        dayTempLabel.text = model.temperature.day.displayTemp()
        eveningTempLabel.text = model.temperature.eve.displayTemp()
        nightTempLabel.text = model.temperature.night.displayTemp()
        
        feelsLikeHeadingLabel.text = "Feels Like"
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
            return "minus"
        }
    }
}
