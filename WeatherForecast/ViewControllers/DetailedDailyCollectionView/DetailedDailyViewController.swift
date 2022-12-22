//
//  DetailedDailyViewController.swift
//  WeatherForecast
//
//  Created by Василий Пронин on 22.09.2022.
//

import UIKit

class DetailedDailyViewController: UIViewController {
    
    var index: Int!
    var forecastData: ForecastData?
    
    private lazy var dateLabel: UILabel = {
        let dateLabel = UILabel(fontSize: 20)
        dateLabel.textAlignment = .center
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        return dateLabel
    }()
    
    private lazy var dayPickerView: DetailedDailyDayPickerView = {
        let dayPickerView = DetailedDailyDayPickerView(index: index)
        dayPickerView.translatesAutoresizingMaskIntoConstraints = false
        return dayPickerView
    }()
    
    private lazy var dailyConditionsView: DetailedDailyConditionsView = {
        let dailyConditionsView = DetailedDailyConditionsView(index: index)
        dailyConditionsView.translatesAutoresizingMaskIntoConstraints = false
        return dailyConditionsView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dayPickerView.delegate = self
        dailyConditionsView.delegate = self
        
        setupNavBar()
        setupUI()
        configureViews()
    }
    
    @objc private func cancel() {
        dismiss(animated: true)
    }
    
    private func setupNavBar() {
        let config = UIImage.SymbolConfiguration(weight: .semibold)
        let image = UIImage(systemName: "xmark.circle.fill", withConfiguration: config)

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: image,
            style: .plain,
            target: self,
            action: #selector(cancel)
        )
        title = Section.daily.headerTitle
        
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.titleTextAttributes = [
            .font: UIFont.systemFont(ofSize: 20, weight: .semibold),
            .foregroundColor: UIColor.white
        ]
        navigationItem.rightBarButtonItem?.tintColor = .white
        navigationController?.navigationBar.standardAppearance = navBarAppearance
    }
    
    private func setupUI() {
        view.backgroundColor = .darkGray

        view.addSubview(dayPickerView)
        view.addSubview(dailyConditionsView)
        
        NSLayoutConstraint.activate([
            dayPickerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dayPickerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            dayPickerView.topAnchor.constraint(equalTo: view.topAnchor),
            dayPickerView.heightAnchor.constraint(equalToConstant: 144),

            dailyConditionsView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dailyConditionsView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            dailyConditionsView.topAnchor.constraint(equalTo: dayPickerView.bottomAnchor),
            dailyConditionsView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func configureViews() {
        guard let forecastData = forecastData else { return }
        
        var daysArray: [DetailedDailyDayPickerItem] = []
        
        forecastData.daily.forEach { daily in
            daysArray.append(DetailedDailyDayPickerItem(dailyData: daily))
        }
        dayPickerView.days = daysArray
        dailyConditionsView.dailyData = forecastData.daily
    }
}

extension DetailedDailyViewController: DetailedDailyDayPickerViewDelegate {
    func didSwitchTheDay(atIndex indexPath: IndexPath) {
        dailyConditionsView.scrollToPage(at: indexPath)
    }
}

extension DetailedDailyViewController: DetailedDailyConditionsViewDelegate {
    func didScrollToPage(atIndex indexPath: IndexPath) {
        dayPickerView.switchTheDay(at: indexPath)
    }
}
