//
//  UIImageView + Extension.swift
//  WeatherForecast
//
//  Created by Василий Пронин on 21.06.2022.
//

import UIKit

extension UIImageView {
    
    enum SymbolType {
        case multicolor(_ size: SymbolType.Size? = nil)
        case monochrome(_ color: SymbolType.Color, size: SymbolType.Size? = nil)
        
        enum Size: CGFloat {
            case main = 20
            case large = 42
        }
        
        enum Color {
            case white
            case gray
        }
    }
    
    convenience init(_ type: SymbolType) {
        self.init()
        
        switch type {
        case .multicolor(let size):
            self.contentMode = .scaleAspectFit
            let config = UIImage.SymbolConfiguration.preferringMulticolor()
            
            switch size {
            case .main:
                let sizeConfig = UIImage.SymbolConfiguration(
                    font: .systemFont(ofSize: size!.rawValue)
                )
                config.applying(sizeConfig)
            case .large:
                let sizeConfig = UIImage.SymbolConfiguration(
                    font: .systemFont(ofSize: size!.rawValue)
                )
                config.applying(sizeConfig)
            default: break
            }
            self.preferredSymbolConfiguration = config
            
        case .monochrome(let color, let size):
            self.contentMode = .scaleAspectFit
            
            switch color {
            case .white: self.tintColor = .white
            case .gray: self.tintColor = .gray
            }
            
            switch size {
            case .main:
                self.preferredSymbolConfiguration = .init(
                    font: .systemFont(ofSize: 20)
                )
            case .large:
                self.preferredSymbolConfiguration = .init(
                    font: .systemFont(ofSize: 42)
                )
            default: break
            }
        }
    }
}

