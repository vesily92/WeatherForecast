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

        backgroundColor = .systemPink
        layer.cornerRadius = 12
        
        descriptionLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        descriptionLabel.textColor = .white
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.numberOfLines = 0
        
        let seeMoreButton = UIButton()
        seeMoreButton.setTitle("See More", for: .normal)
        seeMoreButton.setTitleColor(.white, for: .normal)
        seeMoreButton.titleLabel?.font = .systemFont(ofSize: 16)
        seeMoreButton.translatesAutoresizingMaskIntoConstraints = false

        let imageView = UIImageView()
        imageView.image = UIImage(
            systemName: "chevron.right",
            withConfiguration: UIImage.SymbolConfiguration(font: .systemFont(ofSize: 16))
        )
        imageView.tintColor = .white
        
        let separator = UIView(frame: .zero)
        separator.backgroundColor = .white
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
        contentView.addSubview(separator)
        contentView.addSubview(buttonStackView)
        
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            separator.heightAnchor.constraint(equalToConstant: 1),
            separator.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8),
            separator.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            separator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            buttonStackView.topAnchor.constraint(equalTo: separator.bottomAnchor, constant: 10),
            buttonStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            buttonStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            buttonStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with forecast: AnyHashable, andTimezoneOffset offset: Int) {
        guard let forecast = forecast as? Alert else { return }
        
        if !forecast.senderName.isEmpty {
            descriptionLabel.text = forecast.senderName + ": " + forecast.event
        } else {
            descriptionLabel.text = forecast.event
        }

    }
}
