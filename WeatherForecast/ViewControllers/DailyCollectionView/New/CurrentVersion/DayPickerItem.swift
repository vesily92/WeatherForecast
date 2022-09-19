//
//  DayPickerItem.swift
//  WeatherForecast
//
//  Created by Василий Пронин on 13.07.2022.
//

import UIKit

class DayPickerItem: UIView, DayPickerItemProtocol {
    
    private var dailyData: Daily

    private lazy var weekdayLabel: UILabel = {
        let label = UILabel(.mainText20)
        label.text = DateFormatter.format(dailyData.dt, to: .weekdayShort)
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel(.mainText20)
        label.text = DateFormatter.format(dailyData.dt, to: .dateShort)
        return label
    }()
    
    init(dailyData: Daily) {
        self.dailyData = dailyData
        super.init(frame: .zero)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("")
    }

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
    
    // MARK: - UI Setup
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
