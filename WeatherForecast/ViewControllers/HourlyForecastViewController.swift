//
//  HourlyForecastViewController.swift
//  WeatherForecast
//
//  Created by Василий Пронин on 23.02.2022.
//

import UIKit

class HourlyForecastViewController: UIViewController {
    
    let hourlyForecasts = Bundle.main.decode([Hourly].self, from: "HourlyJSON.json")
    let sunriseAndSunsetMoments = Bundle.main.decode([Current].self, from: "CurrentJSON.json")
    
    var hourlyForecastCollectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    private func setupCollectionView() {
        hourlyForecastCollectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UICollectionViewFlowLayout())
        hourlyForecastCollectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    
}
