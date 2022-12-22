//
//  DailyCell.swift
//  WeatherForecast
//
//  Created by Василий Пронин on 09.02.2022.
//

import UIKit

class DailyCell: UICollectionViewCell, SelfConfigurable {
    
    static let reuseIdentifier = "DailyForecastCell"
    
    private lazy var weekdayLabel = UILabel(.mainText20)
    private lazy var highestTempLabel = UILabel(.mainText20)
    private lazy var lowestTempLabel = UILabel(.mainText20, color: .gray)
    private lazy var popLabel = UILabel(.smallText12, color: .teal)
    private lazy var symbolView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        highestTempLabel.textAlignment = .right
        lowestTempLabel.textAlignment = .right
        weekdayLabel.translatesAutoresizingMaskIntoConstraints = false

        let symbolStackView = UIStackView(arrangedSubviews: [
            symbolView,
            popLabel
        ])
        symbolStackView.axis = .vertical
        symbolStackView.distribution = .equalCentering
        symbolStackView.alignment = .center
        symbolStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let tempStackView = UIStackView(arrangedSubviews: [
            highestTempLabel,
            lowestTempLabel
        ])
        tempStackView.axis = .horizontal
        tempStackView.distribution = .fill
        tempStackView.spacing = 10
        tempStackView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(weekdayLabel)
        contentView.addSubview(symbolStackView)
        contentView.addSubview(tempStackView)
        
        NSLayoutConstraint.activate([
            
            weekdayLabel.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: 16
            ),
            weekdayLabel.centerYAnchor.constraint(
                equalTo: contentView.centerYAnchor
            ),
            weekdayLabel.widthAnchor.constraint(
                greaterThanOrEqualToConstant: contentView.bounds.width / 3
            ),
            
            symbolStackView.trailingAnchor.constraint(
                equalTo: tempStackView.leadingAnchor
            ),
            symbolStackView.centerYAnchor.constraint(
                equalTo: contentView.centerYAnchor
            ),
            symbolStackView.widthAnchor.constraint(
                greaterThanOrEqualToConstant: contentView.bounds.width / 5
            ),
            
            tempStackView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -16
            ),
            tempStackView.centerYAnchor.constraint(
                equalTo: contentView.centerYAnchor
            ),
            tempStackView.widthAnchor.constraint(
                greaterThanOrEqualToConstant: contentView.bounds.width / 5
            )
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with forecast: AnyHashable, tzOffset offset: Int?) {
        guard let forecast = forecast as? Daily,
              let offset = offset else { return }
        
        let symbolFont = UIFont.systemFont(ofSize: 16, weight: .bold)
        let symbolConfig = UIImage.SymbolConfiguration(font: symbolFont)

        var isToday: Bool {
            return DateFormatter.compare(.day, with: forecast.dt)
        }
        
        weekdayLabel.text = isToday ? "Today" : DateFormatter.format(
            forecast.dt,
            to: .weekday,
            withTimeZoneOffset: offset
        )
        highestTempLabel.text = forecast.temperature.max.displayTemp()
        lowestTempLabel.text = forecast.temperature.min.displayTemp()
        popLabel.text = forecast.pop.displayPop(
            if: forecast.weather.first!.isPopNeeded
        )
        symbolView.image = UIImage(
            systemName: forecast.weather.first!.systemNameString,
            withConfiguration: symbolConfig
        )?.withRenderingMode(.alwaysOriginal)
    }
}
