//
//  SearchCollectionViewCell.swift
//  WeatherForecast
//
//  Created by Василий Пронин on 28.07.2022.
//

import UIKit
import CoreLocation

class SearchCollectionViewCell: UICollectionViewListCell {
    
    static let reuseIdentifier = "SearchCollectionViewCell"
    
    private lazy var locationTitleLabel = UILabel(.mainText20Bold)
    private lazy var subtitleLabel = UILabel(.specificationText16)
    private lazy var weatherDescriptionLabel = UILabel(.smallText12)
    private lazy var tempLabel = UILabel(.largeTitle36Regular)
    private lazy var symbolView = UIImageView(.multicolor())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.layer.cornerRadius = 12
        contentView.backgroundColor = .systemGray2
        
        let locationStack = UIStackView(arrangedSubviews: [
            locationTitleLabel,
            subtitleLabel
        ])
        locationStack.axis = .vertical
        locationStack.alignment = .leading
        
        let leftStack = UIStackView(arrangedSubviews: [
            locationStack,
            weatherDescriptionLabel
        ])
        leftStack.axis = .vertical
        leftStack.distribution = .equalSpacing
        leftStack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(leftStack)
        
        let rightStack = UIStackView(arrangedSubviews: [
            tempLabel,
            symbolView
        ])
        rightStack.axis = .horizontal
        rightStack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(rightStack)
        
        let heightConstraint = rightStack.heightAnchor.constraint(equalToConstant: 70)
        heightConstraint.priority = .defaultHigh
        
        NSLayoutConstraint.activate([
            leftStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            leftStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            leftStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),

            rightStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            rightStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            rightStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            heightConstraint
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with forecast: ForecastData, indexPath: IndexPath) {
        if indexPath.item == 0 {
            DispatchQueue.main.async {
                self.locationTitleLabel.text = "My Location"
                LocationManager.shared.getLocationName(with: CLLocation(latitude: forecast.lat, longitude: forecast.lon), completion: { [weak self] location in
                    self?.subtitleLabel.text = location?.cityName
                })
                self.weatherDescriptionLabel.text = forecast.current.weather.first!.description.capitalized
                self.tempLabel.text = forecast.current.temp.displayTemp()
                self.symbolView.image = UIImage(systemName: forecast.current.weather.first!.systemNameString)
            }
            
        } else {
            DispatchQueue.main.async {
                LocationManager.shared.getLocationName(with: CLLocation(latitude: forecast.lat, longitude: forecast.lon), completion: { [weak self] location in
                    self?.locationTitleLabel.text = location?.cityName
                })
                self.subtitleLabel.text = DateFormatter.format(
                    forecast.current.dt,
                    to: .hoursMinutes,
                    withTimeZoneOffset: forecast.timezoneOffset
                )
                self.weatherDescriptionLabel.text = forecast.current.weather.first!.description.capitalized
                self.tempLabel.text = forecast.current.temp.displayTemp()
                self.symbolView.image = UIImage(systemName: forecast.current.weather.first!.systemNameString)
            }
        }
    }
}
