//
//  EmptyCell.swift
//  WeatherForecast
//
//  Created by Василий Пронин on 31.03.2022.
//

import UIKit

class EmptyCell: UICollectionViewCell, SelfConfigurable {
    static let reuseIdentifier = "EmptyCell"
    
    func configure(with model: AnyHashable, tzOffset offset: Int?) {
        //
    }
}
