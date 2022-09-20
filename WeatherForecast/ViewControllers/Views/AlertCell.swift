//
//  AlertCell.swift
//  WeatherForecast
//
//  Created by Василий Пронин on 18.02.2022.
//

import UIKit

class AlertCell: UICollectionViewCell, SelfConfiguringCell {
    
    static let reuseIdentifier = "AlertCell"
    
    weak var coordinator: Coordinator?

    private lazy var descriptionLabel = UILabel(.specificationText16)
    private lazy var seeMoreButton: UIButton = {
        let button = UIButton()
        
        var config = UIButton.Configuration.plain()
        config.title = "See More"
        config.titleAlignment = .leading
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = .systemFont(ofSize: 16, weight: .semibold)
            return outgoing
        }
        config.image = UIImage(systemName: "chevron.right")
        config.imagePlacement = .trailing
        config.imagePadding = 20
        config.baseForegroundColor = .white
        
        button.configuration = config
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        descriptionLabel.numberOfLines = 0
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false

        let separator = UIView(frame: .zero)
        separator.backgroundColor = .white
        separator.alpha = 0.7
        separator.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(seeMoreButton)
        contentView.addSubview(separator)
        contentView.addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            separator.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            separator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            separator.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 10),
            separator.heightAnchor.constraint(equalToConstant: 1),
            
            seeMoreButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            seeMoreButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            seeMoreButton.topAnchor.constraint(equalTo: separator.bottomAnchor),
            seeMoreButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with forecast: AnyHashable, andTimezoneOffset offset: Int) {
        guard let forecast = forecast as? Alert else { return }
        
        if !forecast.senderName.isEmpty {
            descriptionLabel.text = "\(forecast.senderName): \(forecast.event)"
        } else {
            descriptionLabel.text = forecast.event
        }
    }
    
    @objc func didTapButton() {
//        coordinator?.eventOccurred(with: .buttonTapped)
    }
}
