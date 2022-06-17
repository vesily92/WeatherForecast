//
//  UILabel + Extension.swift
//  WeatherForecast
//
//  Created by Василий Пронин on 17.06.2022.
//

import UIKit

extension UILabel {
    
    convenience init(fontSize: CGFloat, weight: UIFont.Weight = .semibold, color: UIColor = .white, alpha: CGFloat = 1) {
        self.init()

        self.font = .systemFont(ofSize: fontSize, weight: weight)
        self.textColor = color
        self.alpha = alpha
    }
}
