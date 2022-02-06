//
//  HomePageViewController.swift
//  WeatherForecast
//
//  Created by Василий Пронин on 03.02.2022.
//

import UIKit

class HomePageViewController: UIViewController {
    
    private lazy var cityNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Saint-Petersburg"
        return label
    }()
    private lazy var temperatureLabel: UILabel = {
        let label = UILabel()
        label.text = "-29 °C"
        label.font = .boldSystemFont(ofSize: 50)
        return label
    }()
    private lazy var weatherIconImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "cloud.fill")
        image.contentMode = .scaleAspectFit
        return image
    }()
    private lazy var weatherDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Cloudy"
        return label
    }()
    private lazy var feelsLikeTemperatureLabel: UILabel = {
        let label = UILabel()
        label.text = "-32 °C"
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
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupSubviews(backgroundImage, containerStackView)
        setConstraints()
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
}

