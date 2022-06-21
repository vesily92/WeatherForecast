//
//  UIImageView + Extension.swift
//  WeatherForecast
//
//  Created by Василий Пронин on 21.06.2022.
//

import UIKit

extension UIImageView {
    enum SymbolType {
        case headingSymbol
        case weatherSymbol
    }
    
    convenience init(_ symbolType: SymbolType) {
        self.init()
        
        switch symbolType {
        case .headingSymbol:
            self.contentMode = .scaleAspectFit
            self.tintColor = .black
            self.alpha = 0.3
        case .weatherSymbol:
            self.preferredSymbolConfiguration = .preferringMulticolor()
            self.contentMode = .scaleAspectFit
            self.preferredSymbolConfiguration = .init(font: .systemFont(ofSize: 18))
        }
    }
}
