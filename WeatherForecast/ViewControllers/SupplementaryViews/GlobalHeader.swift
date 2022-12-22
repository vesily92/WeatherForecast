//
//  GlobalHeader.swift
//  WeatherForecast
//
//  Created by Василий Пронин on 01.03.2022.
//

import UIKit

class GlobalHeader: UICollectionReusableView, SelfConfigurable {

    static let reuseIdentifier = "GlobalHeader"
    
    private lazy var cityNameLabel = UILabel(.largeTitle36)
    private lazy var tempLabel = UILabel(.globalTemperature)
    private lazy var descriptionLabel = UILabel(.mainText20)
    private lazy var feelsLikeLabel = UILabel(.mainText20)
    private lazy var subheadlineLabel: UILabel = {
        let label = UILabel(.mainText20)
        label.alpha = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var symbolView = UIImageView()
    
    private lazy var backgroundView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .clear
        view.alpha = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(blurView, at: 0)
        return view
    }()
    
    private lazy var blurView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterialLight)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        return blurView
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fillEqually
        [tempLabel,
         symbolView].forEach { stack.addArrangedSubview($0) }
        return stack
    }()
    
    private lazy var containerView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 10
        stack.alignment = .center
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        [cityNameLabel,
         stackView,
         descriptionLabel,
         feelsLikeLabel].forEach { stack.addArrangedSubview($0) }
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with forecast: AnyHashable, tzOffset: Int? = nil) {
        guard let forecast = forecast as? ForecastData else { return }
        DispatchQueue.main.async {
            LocationManager.shared.getLocationName(withLat: forecast.lat, andLon: forecast.lon) { [weak self] location in
                guard let location = location else { return }
                self?.cityNameLabel.text = location.cityName
            }
            self.tempLabel.text = forecast.current.temp.displayTemp()
            self.descriptionLabel.text = forecast.current.weather.first!.description.capitalized
            self.feelsLikeLabel.text = "Feels like: " + forecast.current.feelsLike.displayTemp()
            self.symbolView.image = UIImage(
                systemName: forecast.current.weather.first!.systemNameString
            )?.withRenderingMode(.alwaysOriginal)
            
            self.subheadlineLabel.text = forecast.current.temp.displayTemp() + " " + "|" + " " + forecast.current.weather.first!.description.capitalized
        }
    }
   
    func setAlphaForMainLabels(with offset: CGFloat) {
        tempLabel.alpha = offset
        descriptionLabel.alpha = offset
        feelsLikeLabel.alpha = offset
        symbolView.alpha = offset
    }
    
    
    func setAlphaForSubheadline(with offset: CGFloat) {
        subheadlineLabel.alpha = offset
        backgroundView.alpha = offset
    }
    
    func reduceZIndex() {
        layer.zPosition = -2
    }
    
    func restoreZIndex() {
        layer.zPosition = 2
    }
    
    func setupUI() {
        symbolView.contentMode = .scaleAspectFit
        layer.zPosition = 2

        addSubview(backgroundView)
        addSubview(containerView)
        addSubview(subheadlineLabel)
        
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundView.heightAnchor.constraint(lessThanOrEqualToConstant: 160),
            
            blurView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor),
            blurView.topAnchor.constraint(equalTo: backgroundView.topAnchor),
            blurView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor),
            
            containerView.topAnchor.constraint(equalTo: topAnchor, constant: 80),
            containerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            subheadlineLabel.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 120),
            subheadlineLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
}


