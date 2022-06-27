//
//  DetailedDailyForecastHeader.swift
//  WeatherForecast
//
//  Created by Василий Пронин on 20.06.2022.
//

import UIKit

class DetailedDailyForecastHeader: UICollectionReusableView {
    static let reuseIdentifier = "DetailedDailyForecastHeader"
    
    private lazy var heading = UILabel(.sf20SemiboldWhite)
    private lazy var weekday = UILabel(.sf20MediumWhite)
    private lazy var date = UILabel(.sf20SemiboldWhite)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        heading.translatesAutoresizingMaskIntoConstraints = false
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with model: Daily) {
        weekday.text = DateFormatter.format(model.dt, to: .weekdayShort)
        date.text = DateFormatter.format(model.dt, to: .dateShort)
    }
}
