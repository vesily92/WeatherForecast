//
//  AlertCell.swift
//  WeatherForecast
//
//  Created by Василий Пронин on 18.02.2022.
//

import UIKit

class AlertCell: UICollectionViewCell, SelfConfiguringCell {
    static let reuseIdentifier = "AlertCell"
    
    private lazy var descriptionLabel = UILabel()
    private lazy var iconView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        iconView.tintColor = .white
        iconView.contentMode = .scaleAspectFit

        descriptionLabel.font = .systemFont(ofSize: 16)
        descriptionLabel.textColor = .white
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.numberOfLines = 0
        
        contentView.addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with forecast: AnyHashable) {
        guard let forecast = forecast as? Alert else { return }

        descriptionLabel.text = forecast.senderName + ": " + forecast.event
    }
}
