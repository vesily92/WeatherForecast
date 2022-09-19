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
//    var forecastData: ForecastData! {
//        didSet {
//            configure(with: forecastData)
//        }
//    }
    
    private lazy var locationTitleLabel = UILabel(.mainText20)
    private lazy var subtitleLabel = UILabel(.smallText12)
    private lazy var weatherDescriptionLabel = UILabel(.smallText12)
    private lazy var tempLabel = UILabel(.largeText26)
    private lazy var symbolView = UIImageView(.multicolor())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.layer.cornerRadius = 12
        contentView.backgroundColor = .systemGray2
        
        let innerStack = UIStackView(arrangedSubviews: [
            locationTitleLabel,
            subtitleLabel
        ])
        innerStack.axis = .vertical
        innerStack.alignment = .leading
//        innerStack.spacing = 20
        
        let leftStack = UIStackView(arrangedSubviews: [
            innerStack,
            weatherDescriptionLabel
        ])
        leftStack.axis = .vertical
        leftStack.distribution = .equalCentering
        leftStack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(leftStack)
        
        let rightStack = UIStackView(arrangedSubviews: [
            tempLabel,
            symbolView
        ])
        rightStack.axis = .horizontal
        rightStack.distribution = .equalCentering
        rightStack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(rightStack)
        
//        let container = UIStackView(arrangedSubviews: [
//            leftStack,
//            rightStack
//        ])
//        container.axis = .horizontal
////        container.alignment = .leading
//        container.distribution = .fill
//        container.translatesAutoresizingMaskIntoConstraints = false
////
//        contentView.addSubview(container)
        
//        let heightConstraint = container.heightAnchor.constraint(equalToConstant: 80)
//        heightConstraint.priority = .defaultHigh
        
//        let view = UIView()
//        view.layer.cornerRadius = 12
//        view.layer.zPosition = -2
//        view.backgroundColor = .systemGray2
//        view.translatesAutoresizingMaskIntoConstraints = false
//        contentView.addSubview(view)
        
        let heightConstraint = rightStack.heightAnchor.constraint(equalToConstant: 60)
        heightConstraint.priority = .defaultHigh
        
        NSLayoutConstraint.activate([
            
            
//            view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
//            view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
////            heightConstraint,
//            view.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
//            view.heightAnchor.constraint(equalToConstant: 80),

//            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
//            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
//            container.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
//            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
//            heightConstraint
            
//            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
//            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
//            container.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
//            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)

            leftStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            leftStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            leftStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),

            rightStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            rightStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            rightStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            heightConstraint
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with forecast: AnyHashable) {
        guard let forecast = forecast as? ForecastData else { return }
        DispatchQueue.main.async {
            LocationManager.shared.getLocationName(with: CLLocation(latitude: forecast.lat, longitude: forecast.lon), completion: { location in
                self.locationTitleLabel.text = location?.cityName
            })
            self.weatherDescriptionLabel.text = forecast.current.weather.first!.description.capitalized
            self.tempLabel.text = forecast.current.temp.displayTemp()
            self.symbolView.image = UIImage(systemName: forecast.current.weather.first!.systemNameString)
        }
    }
}
