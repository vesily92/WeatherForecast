//
//  AlertCell.swift
//  WeatherForecast
//
//  Created by Василий Пронин on 18.02.2022.
//

import UIKit

class AlertCell: UICollectionViewCell, SelfConfiguringCell {
    static let reuseIdentifier = "AlertCell"
    
    private lazy var descriptionLabel = UILabel(.sf16RegularWhite)
    private lazy var iconView = UIImageView()
    private lazy var seeMoreButton = UIButton(.seeMoreButton)
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        descriptionLabel.numberOfLines = 0
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        seeMoreButton.translatesAutoresizingMaskIntoConstraints = false
        
        let imageView = UIImageView()
        imageView.image = UIImage(
            systemName: "chevron.right",
            withConfiguration: UIImage.SymbolConfiguration(font: .systemFont(ofSize: 16))
        )
        imageView.tintColor = .white
        
        let separator = UIView(frame: .zero)
        separator.backgroundColor = .white
        separator.alpha = 0.7
        separator.translatesAutoresizingMaskIntoConstraints = false
        
        let buttonStackView = UIStackView(arrangedSubviews: [
            seeMoreButton,
            imageView
        ])
        buttonStackView.axis = .horizontal
        buttonStackView.distribution = .equalCentering
        buttonStackView.alignment = .firstBaseline
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with forecast: AnyHashable, andTimezoneOffset offset: Int) {
        guard let forecast = forecast as? Alert else { return }
        
        if !forecast.senderName.isEmpty && !forecast.alertDescription.isEmpty {
            descriptionLabel.text = "\(forecast.senderName): \(forecast.event)\n\(forecast.alertDescription)"
        } else if !forecast.senderName.isEmpty {
            descriptionLabel.text = "\(forecast.senderName): \(forecast.event)"
        } else if !forecast.alertDescription.isEmpty {
            descriptionLabel.text = "\(forecast.event)\n\(forecast.alertDescription)"
        } else {
            descriptionLabel.text = forecast.event
        }

    }
}
