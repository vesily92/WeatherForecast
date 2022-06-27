//
//  DayPickerCell.swift
//  WeatherForecast
//
//  Created by Василий Пронин on 22.06.2022.
//

import UIKit

class DayPickerCell: UICollectionViewCell {
    static let reuseIdentifier = "DayPickerCell"
    
    lazy var isChosen: Bool = false
    
    private lazy var weekday = UILabel(.sf20MediumWhite)
    private lazy var date = UILabel(.sf20SemiboldWhite)
    private lazy var cellBackgroundView = UIView()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
//        backgroundColor = .systemPink
        layer.cornerRadius = 12
        
        cellBackgroundView.backgroundColor = .white
        cellBackgroundView.layer.cornerRadius = 12
        
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
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stack.widthAnchor.constraint(greaterThanOrEqualToConstant: 68)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with model: Daily) {
        if isChosen {
            makeBackgroundConstraints()
        }
        weekday.text = DateFormatter.format(model.dt, to: .weekdayShort)
        date.text = DateFormatter.format(model.dt, to: .dateShort)
    }
    
    fileprivate func makeBackgroundConstraints() {
        
    }
}
