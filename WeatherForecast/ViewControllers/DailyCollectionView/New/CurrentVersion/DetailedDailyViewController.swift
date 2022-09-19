//
//  DetailedDailyViewController.swift
//  WeatherForecast
//
//  Created by Василий Пронин on 13.07.2022.
//

import UIKit

class DetailedDailyViewController: UIViewController {
    
    var coordinator: Coordinator?
    var forecastData: ForecastData?
    
    private lazy var headerTitleLabel: UILabel = {
        let label = UILabel(.mainText20)
        label.text = Section.daily.headerTitle
        return label
    }()
    
    private lazy var headerIconView: UIImageView = {
        let icon = UIImageView()
        icon.contentMode = .scaleAspectFit
        icon.preferredSymbolConfiguration = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 20))
        icon.tintColor = .white
        icon.image = UIImage(systemName: Section.daily.headerIcon)
        return icon
    }()
    
    private lazy var detailedDailyView: DetailedDailyView = {
        let dailyView = DetailedDailyView(
            tabSizeConfiguration: .fixed(width: 80, height: 80, spacing: 0)
        )
        guard let forecastData = forecastData else {
            fatalError()
        }
        forecastData.daily.forEach { daily in
            dailyView.dayPickerView.tabs.append(DayPickerItem(dailyData: daily))
        }
        dailyView.conditionsView.dailyData = forecastData.daily
        dailyView.translatesAutoresizingMaskIntoConstraints = false
        return dailyView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .darkGray
        view.addSubview(detailedDailyView)
        
        let stackView = UIStackView(arrangedSubviews: [
            headerIconView,
            headerTitleLabel
        ])
        stackView.axis = .horizontal
        stackView.alignment = .firstBaseline
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.widthAnchor.constraint(greaterThanOrEqualToConstant: 50),
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 16)
        ])
        
        NSLayoutConstraint.activate([
            detailedDailyView.widthAnchor.constraint(equalTo: view.widthAnchor),
            detailedDailyView.heightAnchor.constraint(equalTo: view.heightAnchor),
            detailedDailyView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            detailedDailyView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 20)
        ])
    }
    
}

