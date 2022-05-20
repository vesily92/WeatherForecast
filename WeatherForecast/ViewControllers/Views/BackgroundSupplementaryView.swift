//
//  BackgroundSupplementaryView.swift
//  WeatherForecast
//
//  Created by Василий Пронин on 15.02.2022.
//

import UIKit

class BackgroundSupplementaryView: UICollectionReusableView {
    static let reuseIdentifier = "BackgroundView"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = 12
        backgroundColor = UIColor(red: 0.5, green: 0.6, blue: 0.9, alpha: 0.5)
    }
    
    func configure(with color: UIColor) {
        backgroundColor = color
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
