//
//  UIButton + Extension.swift
//  WeatherForecast
//
//  Created by Василий Пронин on 17.06.2022.
//

import UIKit

extension UIButton {
    enum TypeOfButton {
        case seeMoreButton
    }
    
//    convenience init(_ buttonType: UIButton.TypeOfButton) {
//        self.init(type: .system)
//
//        switch buttonType {
//        case .seeMoreButton:
//            var seeMoreConfig = UIButton.Configuration.plain()
//            seeMoreConfig.title = "See More"
//            seeMoreConfig.titleAlignment = .leading
//            seeMoreConfig.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
//                var outgoing = incoming
//                outgoing.font = .systemFont(ofSize: 16, weight: .semibold)
//                return outgoing
//            }
//            seeMoreConfig.image = UIImage(systemName: "chevron.right")
//            seeMoreConfig.imagePadding = 5
//            seeMoreConfig.imagePlacement = .trailing
//            seeMoreConfig.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(scale: .medium)
//            seeMoreConfig.baseForegroundColor = .white
//            self.configuration = seeMoreConfig
//        }
//    }
}
