//
//  SectionBackgroundView.swift
//  WeatherForecast
//
//  Created by Василий Пронин on 15.02.2022.
//

import UIKit

class SectionBackgroundView: UICollectionReusableView {
    static let reuseIdentifier = "BackgroundView"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = 12
        backgroundColor = .systemGray2
    }
    
    func configure(with color: UIColor) {
        backgroundColor = color
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
