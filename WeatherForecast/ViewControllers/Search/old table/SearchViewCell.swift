//
//  SearchViewCell.swift
//  WeatherForecast
//
//  Created by Василий Пронин on 30.08.2022.
//

import UIKit
import CoreLocation

class SearchViewCell: UITableViewCell {
    
    static let reuseIdentifier = "SearchViewCell"
    
    private lazy var locationTitleLabel = UILabel(.mainText20)
    private lazy var subtitleLabel = UILabel(.smallText12)
    private lazy var weatherDescriptionLabel = UILabel(.smallText12)
    private lazy var tempLabel = UILabel(.largeText26)
    private lazy var symbolView = UIImageView(.multicolor())
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
//        contentView.layer.cornerRadius = 12
        contentView.backgroundColor = .darkGray
        
        let view = UIView()
        view.backgroundColor = .systemGray2
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        
        let innerStack = UIStackView(arrangedSubviews: [
            locationTitleLabel,
            subtitleLabel
        ])
        innerStack.axis = .vertical
        innerStack.alignment = .leading
        
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
        rightStack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(rightStack)
        
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            view.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            leftStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32),
            leftStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 32),
            leftStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -32),
            
            rightStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32),
            rightStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 32),
            rightStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -32)
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
