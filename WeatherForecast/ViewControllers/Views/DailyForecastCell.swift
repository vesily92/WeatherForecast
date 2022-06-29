//
//  DailyForecastCell.swift
//  WeatherForecast
//
//  Created by Василий Пронин on 09.02.2022.
//

import UIKit

class DailyForecastCell: UICollectionViewCell, SelfConfiguringCell {
    static let reuseIdentifier = "DailyForecastCell"
    
    lazy private var weekdayLabel = UILabel(fontSize: 20)
//    lazy private var dateLabel = UILabel(fontSize: 12, weight: .regular, color: .black, alpha: 0.3)
    lazy private var highestTempLabel = UILabel(fontSize: 20)
    lazy private var lowestTempLabel = UILabel(fontSize: 20, color: .black, alpha: 0.3)
    lazy private var popLabel = UILabel(fontSize: 12, color: .systemCyan)
    lazy private var iconView = UIImageView()
    
    private let symbolConfig = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 18))
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        iconView.preferredSymbolConfiguration = .preferringMulticolor()
        iconView.contentMode = .scaleAspectFit
        
        let dateStackView = UIStackView(arrangedSubviews: [
            weekdayLabel,
//            dateLabel
        ])
        dateStackView.axis = .vertical
        dateStackView.translatesAutoresizingMaskIntoConstraints = false

        let iconStackView = UIStackView(arrangedSubviews: [
            iconView,
            popLabel
        ])
        iconStackView.axis = .vertical
        iconStackView.distribution = .equalCentering
        iconStackView.alignment = .center
        iconStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let tempStackView = UIStackView(arrangedSubviews: [
            highestTempLabel,
            lowestTempLabel
        ])
        tempStackView.axis = .horizontal
        tempStackView.distribution = .equalCentering
        tempStackView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(dateStackView)
        contentView.addSubview(iconStackView)
        contentView.addSubview(tempStackView)
        
        NSLayoutConstraint.activate([
            
            dateStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            dateStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            dateStackView.widthAnchor.constraint(greaterThanOrEqualToConstant: contentView.bounds.width / 3),
            
            iconStackView.trailingAnchor.constraint(equalTo: tempStackView.leadingAnchor),
            iconStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconStackView.widthAnchor.constraint(greaterThanOrEqualToConstant: contentView.bounds.width / 5),
            
            tempStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            tempStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            tempStackView.widthAnchor.constraint(greaterThanOrEqualToConstant: contentView.bounds.width / 5)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with forecast: AnyHashable, andTimezoneOffset offset: Int) {
        guard let forecast = forecast as? Daily else { return }

        var isToday: Bool {
            return DateFormatter.compare(.day, with: forecast.dt)
        }
        
//        dateLabel.text = DateFormatter.format(
//            forecast.dt,
//            to: .date,
//            withTimeZoneOffset: offset
//        )
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
        iconView.image = UIImage(
            systemName: forecast.weather.first!.systemNameString,
            withConfiguration: symbolConfig
        )
    }
}
