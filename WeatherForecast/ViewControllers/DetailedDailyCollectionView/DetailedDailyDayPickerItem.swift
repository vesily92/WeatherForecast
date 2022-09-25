//
//  DetailedDailyDayPickerItem.swift
//  WeatherForecast
//
//  Created by Василий Пронин on 23.09.2022.
//

import UIKit

class DetailedDailyDayPickerItem: UIView {
    
    private var dailyData: Daily
    private let weekdayLabel = UILabel(.mainText20)
    private let dateLabel = UILabel(.mainText20)
    
    init(dailyData: Daily) {
        self.dailyData = dailyData
        super.init(frame: .zero)
        
        weekdayLabel.text = DateFormatter.format(dailyData.dt, to: .weekdayShort)
        dateLabel.text = DateFormatter.format(dailyData.dt, to: .dateShort)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        self.layer.cornerRadius = 40
        let stack = UIStackView(arrangedSubviews: [
            weekdayLabel,
            dateLabel
        ])
        stack.axis = .vertical
        stack.alignment = .center
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            stack.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8),
            stack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            stack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8)
        ])
    }
    
}

extension DetailedDailyDayPickerItem: DetailedDailyDayPickerItemProtocol {
    
    func onSelected() {
        self.backgroundColor = .white
        self.weekdayLabel.textColor = .black
        self.dateLabel.textColor = .black
    }
    
    func onNotSelected() {
        self.backgroundColor = .clear
        self.weekdayLabel.textColor = .white
        self.dateLabel.textColor = .white
    }
}
