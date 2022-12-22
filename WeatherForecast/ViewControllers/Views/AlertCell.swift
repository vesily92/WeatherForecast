//
//  AlertCell.swift
//  WeatherForecast
//
//  Created by Василий Пронин on 18.02.2022.
//

import UIKit

class AlertCell: UICollectionViewCell, SelfConfigurable {
    
    static let reuseIdentifier = "AlertCell"
    
    private lazy var descriptionLabel = UILabel(.specificationText16)
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        descriptionLabel.numberOfLines = 0
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            descriptionLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with forecast: AnyHashable, tzOffset offset: Int? = nil) {
        guard let forecast = forecast as? Alert else { return }
        
        if !forecast.senderName.isEmpty {
            descriptionLabel.text = "\(forecast.senderName): \(forecast.event)"
        } else {
            descriptionLabel.text = forecast.event
        }
    }
}
