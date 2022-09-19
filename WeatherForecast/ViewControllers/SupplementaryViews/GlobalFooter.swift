//
//  GlobalFooter.swift
//  WeatherForecast
//
//  Created by Василий Пронин on 16.06.2022.
//

import UIKit
import CoreLocation

class GlobalFooter: UICollectionReusableView {
    static let reuseIdentifier = "GlobalFooter"
    
    private lazy var titleLabel = UILabel(.specificationText16)
    private lazy var subtitleLabel = UILabel(.smallText12, color: .gray)
    private lazy var openWeatherLogoView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let separator = UIView(frame: .zero)
        separator.backgroundColor = .white
        separator.alpha = 0.7
        separator.translatesAutoresizingMaskIntoConstraints = false
        
        openWeatherLogoView.contentMode = .scaleAspectFit
        
        let innerStackView = UIStackView(arrangedSubviews: [
            titleLabel,
            subtitleLabel
        ])
        innerStackView.axis = .vertical
        innerStackView.distribution = .equalCentering
        innerStackView.alignment = .center

        let outerStackView = UIStackView(arrangedSubviews: [
            innerStackView,
            openWeatherLogoView
        ])
        outerStackView.axis = .vertical
        outerStackView.spacing = 20
        outerStackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(separator)
        addSubview(outerStackView)
        
        NSLayoutConstraint.activate([
            separator.heightAnchor.constraint(equalToConstant: 0.5),
            separator.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            separator.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            separator.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
            
            outerStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            outerStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            outerStackView.topAnchor.constraint(equalTo: separator.topAnchor, constant: 30)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with forecast: ForecastData) {
        DispatchQueue.main.async {
            let coordinates = CLLocation(latitude: forecast.lat, longitude: forecast.lon)
            
            LocationManager.shared.getLocationName(with: coordinates, completion: { [weak self] location in
                guard let location = location else { return }
                self?.titleLabel.text = "Weather for " + location.cityName
            })
            
            self.subtitleLabel.text = "Provided by OpenWeather"
            self.openWeatherLogoView.image = UIImage(named: "OpenWeatherLogo")
        }
    }
}
