//
//  BackgroundSupplementaryView.swift
//  WeatherForecast
//
//  Created by Василий Пронин on 15.02.2022.
//

import UIKit

final class BackgroundSupplementaryView: UICollectionReusableView {
    static let reuseIdentifier = "BackgroundView"
    
    static let shared = BackgroundSupplementaryView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = 16
        backgroundColor = .systemGray2
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
