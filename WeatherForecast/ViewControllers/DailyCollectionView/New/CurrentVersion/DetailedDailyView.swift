//
//  DetailedDailyView.swift
//  WeatherForecast
//
//  Created by Василий Пронин on 14.07.2022.
//

import UIKit

class DetailedDailyView: UIView {
    
    let sizeConfiguration: DayPickerView.SizeConfiguration
    
    let conditionsView = ConditionsView()
    
    lazy var dayPickerView: DayPickerView = {
        let dayPickerView = DayPickerView(
            sizeConfiguration: sizeConfiguration
        )
        return dayPickerView
    }()
    
    
    // MARK: - Initialization
    init(tabSizeConfiguration: DayPickerView.SizeConfiguration) {
        self.sizeConfiguration = tabSizeConfiguration
        super.init(frame: .zero)
        
        self.setupUI()
        
        dayPickerView.delegate =  self
        conditionsView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(dayPickerView)
        self.addSubview(conditionsView)
        
        NSLayoutConstraint.activate([
            dayPickerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            dayPickerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            dayPickerView.topAnchor.constraint(equalTo: topAnchor),
            dayPickerView.heightAnchor.constraint(equalToConstant: sizeConfiguration.height)
        ])
        
        NSLayoutConstraint.activate([
            conditionsView.leadingAnchor.constraint(equalTo: leadingAnchor),
            conditionsView.trailingAnchor.constraint(equalTo: trailingAnchor),
            conditionsView.topAnchor.constraint(equalTo: dayPickerView.bottomAnchor),
            conditionsView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

extension DetailedDailyView: DayPickerViewDelegate {
    func didMoveToTab(at index: Int) {
        self.conditionsView.moveToPage(at: index)
    }
}

extension  DetailedDailyView: ConditionsViewDelegate {
    func didMoveToPage(index: Int) {
        self.dayPickerView.moveToTab(at: index)
    }
}
