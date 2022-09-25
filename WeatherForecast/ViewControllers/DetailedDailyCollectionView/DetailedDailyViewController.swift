//
//  DetailedDailyViewController.swift
//  WeatherForecast
//
//  Created by Василий Пронин on 22.09.2022.
//

import UIKit

class DetailedDailyViewController: UIViewController {

    weak var coordinator: Coordinator?
    var forecastData: ForecastData?
    private let dayPickerView = DetailedDailyDayPickerView()
    private let dailyConditionsView = DetailedDailyConditionsView()
    
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
        
        dayPickerView.frame = CGRect(
            x: 0,
            y: navigationController!.navigationBar.bounds.height,
            width: view.bounds.width,
            height: 100
        )
        dailyConditionsView.frame = CGRect(
            x: 0,
            y: navigationController!.navigationBar.bounds.height + dayPickerView.bounds.height,
            width: view.bounds.width,
            height: view.bounds.height
        )

        view.addSubview(dayPickerView)
        view.addSubview(dailyConditionsView)
    }
    
    private func configureViews() {
        guard let forecastData = forecastData else { return }
        
        forecastData.daily.forEach { daily in
            dayPickerView.days.append(DetailedDailyDayPickerItem(dailyData: daily))
        }
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
