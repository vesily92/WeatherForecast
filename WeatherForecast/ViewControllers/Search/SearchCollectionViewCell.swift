//
//  SearchCollectionViewCell.swift
//  WeatherForecast
//
//  Created by Василий Пронин on 28.07.2022.
//

import UIKit

class SearchCollectionViewCell: UICollectionViewListCell {
    
    static let reuseIdentifier = "SearchCollectionViewCell"
    
    private lazy var locationTitleLabel = UILabel(.mainText20Bold)
    private lazy var subtitleLabel = UILabel(.specificationText16)
    private lazy var weatherDescriptionLabel = UILabel(.smallText12)
    private lazy var tempLabel = UILabel(.largeTitle36Regular)
    private lazy var symbolView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.layer.cornerRadius = 12
        contentView.backgroundColor = .systemGray2
        
        symbolView.contentMode = .scaleAspectFit
        
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
        let temperature = forecast.current.temp.displayTemp()
        let description = forecast.current.weather.first!.description.capitalized
        let time = DateFormatter.format(
            forecast.current.dt,
            to: .hoursMinutes,
            withTimeZoneOffset: forecast.timezoneOffset
        )
        let systemName = forecast.current.weather.first!.systemNameString
        let config = UIImage.SymbolConfiguration(
            font: UIFont.systemFont(ofSize: 28, weight: .bold)
        )
        
        if indexPath.item == 0 {
            DispatchQueue.main.async {
                self.locationTitleLabel.text = "My Location"
                LocationManager.shared.getLocationName(withLat: forecast.lat, andLon: forecast.lon) { [weak self] location in
                    self?.subtitleLabel.text = location?.cityName
                }
                self.weatherDescriptionLabel.text = description
                self.tempLabel.text = temperature
                self.symbolView.image = UIImage(systemName: systemName, withConfiguration: config)?
                    .withRenderingMode(.alwaysOriginal)
            }
            
        } else {
            DispatchQueue.main.async {
                LocationManager.shared.getLocationName(withLat: forecast.lat, andLon: forecast.lon) { [weak self] location in
                    self?.locationTitleLabel.text = location?.cityName
                }
                self.subtitleLabel.text = time
                self.weatherDescriptionLabel.text = description
                self.tempLabel.text = temperature
                self.symbolView.image = UIImage(systemName: systemName, withConfiguration: config)?
                    .withRenderingMode(.alwaysOriginal)
            }
        }
    }
}
