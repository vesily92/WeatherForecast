//
//  UILabel + Extension.swift
//  WeatherForecast
//
//  Created by Василий Пронин on 17.06.2022.
//

import UIKit

extension UILabel {
    
    enum LabelType {
        case heading16SemiboldBlack
        case sf26SemiboldWhite
        case sf20SemiboldWhite
        case sf20SemiboldBlack
        case sf20MediumWhite
        case sf20ThinWhite
        case sf16SemiboldWhite
        case sf16RegularWhite
        case sf12SemiboldTeal
        case sf12RegularBlack
    }
    
    convenience init(_ labelType: LabelType, alpha: CGFloat = 1) {
        self.init()
        
        switch labelType {
        case .heading16SemiboldBlack:
            self.font = .systemFont(ofSize: 16, weight: .semibold)
            self.textColor = .black
            self.alpha = 0.3
        case .sf26SemiboldWhite:
            self.font = .systemFont(ofSize: 26, weight: .semibold)
            self.textColor = .white
            self.alpha = alpha
        case .sf20SemiboldWhite:
            self.font = .systemFont(ofSize: 20, weight: .semibold)
            self.textColor = .white
            self.alpha = alpha
        case .sf20SemiboldBlack:
            self.font = .systemFont(ofSize: 20, weight: .semibold)
            self.textColor = .black
            self.alpha = 0.3
        case .sf20MediumWhite:
            self.font = .systemFont(ofSize: 20, weight: .medium)
            self.textColor = .white
            self.alpha = alpha
        case .sf20ThinWhite:
            self.font = .systemFont(ofSize: 20, weight: .thin)
            self.textColor = .white
            self.alpha = alpha
        case .sf16SemiboldWhite:
            self.font = .systemFont(ofSize: 16, weight: .semibold)
            self.textColor = .white
            self.alpha = alpha
        case .sf16RegularWhite:
            self.font = .systemFont(ofSize: 16, weight: .regular)
            self.textColor = .white
            self.alpha = alpha
        case .sf12SemiboldTeal:
            self.font = .systemFont(ofSize: 12, weight: .semibold)
            self.textColor = .systemTeal
            self.alpha = alpha
        case .sf12RegularBlack:
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
