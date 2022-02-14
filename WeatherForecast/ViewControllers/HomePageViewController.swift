//
//  HomePageViewController.swift
//  WeatherForecast
//
//  Created by Василий Пронин on 03.02.2022.
//

import UIKit
import CoreLocation

class HomePageViewController: UIViewController {
    
    private lazy var cityNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 30)
        return label
    }()
    
    private lazy var temperatureLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 40)
        return label
    }()
    
    private lazy var weatherIconImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    private lazy var weatherDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    private lazy var feelsLikeTemperatureLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    private lazy var backgroundImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "eye.slash")
        image.contentMode = .scaleAspectFit
        image.tintColor = .orange
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private lazy var temperatureStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fillEqually
        [self.temperatureLabel,
         self.weatherIconImage].forEach { stack.addArrangedSubview($0) }
        return stack
    }()
    
    private lazy var containerStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 10
        stack.alignment = .center
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        [self.cityNameLabel,
         self.temperatureStackView,
         self.weatherDescriptionLabel,
         self.feelsLikeTemperatureLabel].forEach { stack.addArrangedSubview($0) }
        return stack
    }()
    
    private lazy var locationManager: CLLocationManager = {
        let lm = CLLocationManager()
        lm.delegate = self
        lm.desiredAccuracy = kCLLocationAccuracyHundredMeters
        lm.requestWhenInUseAuthorization()
        return lm
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupSubviews(backgroundImage, containerStackView)
        setConstraints()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestLocation()
        }
        
        NetworkManager.shared.onCompletion = { [weak self] currentWeather in
            guard let self = self else { return }
            self.updateUI(with: currentWeather)
        }
    }
    
    private func setupSubviews(_ subviews: UIView...) {
        subviews.forEach { subview in
            view.addSubview(subview)
        }
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            backgroundImage.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            containerStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            containerStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func updateUI(with weather: CurrentWeather) {
        DispatchQueue.main.async {
            self.cityNameLabel.text = weather.cityName
            self.temperatureLabel.text = weather.temperatureString
            self.weatherDescriptionLabel.text = weather.description.capitalized
            self.feelsLikeTemperatureLabel.text = weather.feelsLikeString
            self.weatherIconImage.image = UIImage(systemName: weather.systemNameString)
        }
    }
}

// MARK: - CLLocationManagerDelegate

extension HomePageViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        
        //NetworkManager.shared.fetchWeather(forRequest: .coordinates(latitude: latitude, longitude: longitude))
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}
