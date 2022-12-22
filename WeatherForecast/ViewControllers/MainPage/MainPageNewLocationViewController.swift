//
//  MainPageNewLocationViewController.swift
//  WeatherForecast
//
//  Created by Василий Пронин on 13.12.2022.
//

import UIKit

class MainPageNewLocationViewController: UIViewController {
    
    var isNew: Bool!
    var forecastData: ForecastData! {
        didSet {
            mainPageView.configure(with: forecastData)
        }
    }
    var geocodingData: GeocodingData!
    
    private let mainPageView = MainPageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavBar()
        setupUI()
    }
    
    @objc private func addNewLocation() {
        if let forecastData = forecastData {
            NotificationCenter.default.post(
                name: .appendData,
                object: [NotificationKeys.data: forecastData]
            )
            dismiss(animated: true)
        }
    }
    
    @objc private func cancel() {
        dismiss(animated: true)
    }
    
    private func setupNavBar() {
        let config = UIImage.SymbolConfiguration(weight: .semibold)
        let image = UIImage(systemName: "plus", withConfiguration: config)
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .cancel,
            target: self,
            action: #selector(cancel)
        )
        if isNew {
            navigationItem.rightBarButtonItem = UIBarButtonItem(
                image: image,
                style: .plain,
                target: self,
                action: #selector(addNewLocation)
            )
            navigationItem.rightBarButtonItem?.tintColor = .white
        }
        navigationItem.leftBarButtonItem?.tintColor = .white
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.layoutIfNeeded()
    }
    
    private func setupUI() {
        mainPageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mainPageView)
        
        NSLayoutConstraint.activate([
            mainPageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainPageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainPageView.topAnchor.constraint(equalTo: view.topAnchor),
            mainPageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
