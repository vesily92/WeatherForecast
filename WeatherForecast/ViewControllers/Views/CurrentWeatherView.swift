//
//  CurrentWeatherView.swift
//  WeatherForecast
//
//  Created by Василий Пронин on 11.04.2022.
//

import UIKit

class CurrentWeatherView: UIView {
//    static let reuseIdentifier = "CurrentWeatherView"
    
    lazy private var temperatureLabel = UILabel()
    lazy private var descriptionLabel = UILabel()
    lazy private var feelsLikeLabel = UILabel()
    lazy private var weatherIconView = UIImageView()
    
    weak var scrollView: UIScrollView?
    private var cachedMinimumSize: CGSize?
    
    private var minimumHeight: CGFloat {
        get {
            guard let scrollView = scrollView else { return 0 }
            if let cachedSize = cachedMinimumSize {
                if cachedSize.width == scrollView.frame.width {
                    return cachedSize.height
                }
            }
            let minimumSize = systemLayoutSizeFitting(
                CGSize(width: scrollView.frame.width, height: 0),
                withHorizontalFittingPriority: .required,
                verticalFittingPriority: .defaultLow
            )
            cachedMinimumSize = minimumSize
            return minimumSize.height
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //layer.zPosition = -1
        
        temperatureLabel.font = .boldSystemFont(ofSize: 50)
        temperatureLabel.textColor = .white
        
        descriptionLabel.font = .systemFont(ofSize: 16)
        descriptionLabel.textColor = .white
        
        feelsLikeLabel.font = .systemFont(ofSize: 16)
        feelsLikeLabel.textColor = .white
        
        weatherIconView.contentMode = .scaleAspectFit
        weatherIconView.preferredSymbolConfiguration = .preferringMulticolor()
        
        let subStackView = UIStackView(arrangedSubviews: [
            temperatureLabel,
            weatherIconView
        ])
        subStackView.axis = .horizontal
        subStackView.alignment = .fill
        subStackView.distribution = .fillEqually
        
        let mainStackView = UIStackView(arrangedSubviews: [
            subStackView,
            descriptionLabel,
            feelsLikeLabel
        ])
        mainStackView.axis = .vertical
        mainStackView.spacing = 10
        mainStackView.alignment = .center
        mainStackView.distribution = .fill
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(mainStackView)
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: topAnchor, constant: 40),
            mainStackView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    func configure(with forecast: Current) {
        var sunIsUp: Bool {
            let hour = DateFormatter.getHour(from: forecast.dt)
            switch hour {
            case 7...21: return true
            default: return false
            }
        }
        var systemNameString: String {
            switch forecast.weather.first!.id {
            case 200...232: return "cloud.bolt.rain.fill"
            case 300...321: return "cloud.drizzle.fill"
            case 500...531: return "cloud.heavyrain.fill"
            case 600...622: return "snowflake"
            case 700...781: return "cloud.fog.fill"
            case 800: return sunIsUp ? "sun.max.fill" : "moon.stars.fill"
            case 801...804: return sunIsUp ? "cloud.sun.fill" : "cloud.moon.fill"
            default: return "nosign"
            }
        }
        temperatureLabel.text = forecast.temp.displayTemp()
        descriptionLabel.text = forecast.weather.first?.description.capitalized ?? ""
        feelsLikeLabel.text = "Feels like: " + forecast.feelsLike.displayTemp()
        weatherIconView.image = UIImage(systemName: systemNameString)
    }
    
    func updatePosition() {
        guard let scrollView = scrollView else { return }
        
        let minimumSize = minimumHeight
        let referenceOffset = scrollView.safeAreaInsets.top
        let referenceHeight = scrollView.contentInset.top - referenceOffset
        
        let offset = referenceHeight + scrollView.contentOffset.y
        let targetHeight = referenceHeight - offset - referenceOffset
        var targetOffset = referenceOffset
        if targetHeight < minimumSize {
            targetOffset += targetHeight - minimumSize
        }
        
        var viewFrame = frame;
        viewFrame.size.height = max(minimumSize, targetHeight)
        viewFrame.origin.y = targetOffset
        
        frame = viewFrame;
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func scrollViewDidScroll(scrollView: UIScrollView) {
        
    }
}

