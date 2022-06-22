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
        case infoSymbol
    }
    
    convenience init(_ symbolType: SymbolType) {
        self.init()
        
        switch symbolType {
        case .headingSymbol:
            self.contentMode = .scaleAspectFit
            self.tintColor = .black
            self.alpha = 0.3
        case .weatherSymbol:
            self.contentMode = .scaleAspectFit
            self.preferredSymbolConfiguration = .preferringMulticolor()
            self.preferredSymbolConfiguration = .init(font: .systemFont(ofSize: 18))
        case .infoSymbol:
            self.contentMode = .scaleAspectFit
            self.tintColor = .white
            self.preferredSymbolConfiguration = .init(font: .systemFont(ofSize: 40))
        }
    }
}
