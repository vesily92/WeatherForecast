//
//  DayPickerCell.swift
//  WeatherForecast
//
//  Created by Василий Пронин on 22.06.2022.
//

import UIKit

class DayPickerCell: UICollectionViewCell {
    static let reuseIdentifier = "DayPickerCell"
    
    private lazy var weekday = UILabel(.sf20mediumWhite)
    private lazy var date = UILabel(.sf20semiboldWhite)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let stack = UIStackView(arrangedSubviews: [
            weekday,
            date
        ])
        stack.axis = .vertical
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with model: Daily) {
        
        weekday.text = DateFormatter.format(model.dt, to: .weekdayShort)
        date.text = DateFormatter.format(model.dt, to: .dateShort)
    }
}
