//
//  EmptyCell.swift
//  WeatherForecast
//
//  Created by Василий Пронин on 31.03.2022.
//

import Foundation
import UIKit

class EmptyCell: UICollectionViewCell, SelfConfiguringCell {
    static let reuseIdentifier = "EmptyCell"
    
    func configure(with forecast: AnyHashable) {
        
    }
    
    
}
