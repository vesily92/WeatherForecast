//
//  UILabel + Extension.swift
//  WeatherForecast
//
//  Created by Василий Пронин on 17.06.2022.
//

import UIKit

extension UILabel {
    
    enum LabelType {
        case largeTitle36
        case globalTemperature
        case mainText20
        case specificationText16
        case largeText26
        case smallText12
        
        enum Color {
            case gray
            case teal
        }
    }

    convenience init(_ labelType: LabelType, color: LabelType.Color? = nil) {
        self.init()
        
        switch labelType {
        case .largeTitle36:
            self.font = .systemFont(ofSize: 36, weight: .semibold)
        case .globalTemperature:
            self.font = .systemFont(ofSize: 54, weight: .regular)
        case .mainText20:
            self.font = .systemFont(ofSize: 20, weight: .semibold)
        case .specificationText16:
            self.font = .systemFont(ofSize: 16, weight: .semibold)
        case .largeText26:
            self.font = .systemFont(ofSize: 26, weight: .semibold)
        case .smallText12:
            self.font = .systemFont(ofSize: 12, weight: .semibold)
        }
        
        switch color {
        case .gray:
            self.textColor = .gray
        case .teal:
            self.textColor = .systemTeal
        case .none:
            self.textColor = .white
        }
    }
}
