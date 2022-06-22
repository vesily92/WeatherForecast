//
//  UILabel + Extension.swift
//  WeatherForecast
//
//  Created by Василий Пронин on 17.06.2022.
//

import UIKit

extension UILabel {
    
    enum LabelType {
        case heading16semiboldBlack
        case sf26semiboldWhite
        case sf20semiboldWhite
        case sf20semiboldBlack
        case sf20mediumWhite
        case sf16semiboldWhite
        case sf16regularWhite
        case sf12semiboldTeal
        case sf12regularBlack
    }
    
    convenience init(_ labelType: LabelType, alpha: CGFloat = 1) {
        self.init()
        
        switch labelType {
        case .heading16semiboldBlack:
            self.font = .systemFont(ofSize: 16, weight: .semibold)
            self.textColor = .black
            self.alpha = 0.3
        case .sf26semiboldWhite:
            self.font = .systemFont(ofSize: 26, weight: .semibold)
            self.textColor = .white
            self.alpha = alpha
        case .sf20semiboldWhite:
            self.font = .systemFont(ofSize: 20, weight: .semibold)
            self.textColor = .white
            self.alpha = alpha
        case .sf20semiboldBlack:
            self.font = .systemFont(ofSize: 20, weight: .semibold)
            self.textColor = .black
            self.alpha = 0.3
        case .sf20mediumWhite:
            self.font = .systemFont(ofSize: 20, weight: .medium)
            self.textColor = .white
            self.alpha = alpha
        case .sf16semiboldWhite:
            self.font = .systemFont(ofSize: 16, weight: .semibold)
            self.textColor = .white
            self.alpha = alpha
        case .sf16regularWhite:
            self.font = .systemFont(ofSize: 16, weight: .regular)
            self.textColor = .white
            self.alpha = alpha
        case .sf12semiboldTeal:
            self.font = .systemFont(ofSize: 12, weight: .semibold)
            self.textColor = .systemTeal
            self.alpha = alpha
        case .sf12regularBlack:
            self.font = .systemFont(ofSize: 12)
            self.textColor = .black
            self.alpha = 0.3
        }
    }
    
    convenience init(fontSize: CGFloat, weight: UIFont.Weight = .semibold, color: UIColor = .white, alpha: CGFloat = 1) {
        self.init()

        self.font = .systemFont(ofSize: fontSize, weight: weight)
        self.textColor = color
        self.alpha = alpha
    }
}
