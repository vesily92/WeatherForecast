//
//  AlertCell.swift
//  WeatherForecast
//
//  Created by Василий Пронин on 18.02.2022.
//

import UIKit

class AlertCell: UICollectionViewCell, SelfConfiguringCell {
    static let reuseIdentifier = "AlertCell"
    
    private lazy var eventLabel = UILabel()
    private lazy var iconView = UIImageView()
//    private var senderLabel: UILabel?
    private lazy var descriptionLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        eventLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        eventLabel.textColor = .white
        eventLabel.numberOfLines = 0
        
        iconView.tintColor = .white
        iconView.contentMode = .scaleAspectFit
        
//        senderLabel?.font = .systemFont(ofSize: 16)
//        senderLabel?.textColor = .white
        
        descriptionLabel.font = .systemFont(ofSize: 16)
        descriptionLabel.textColor = .white
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.numberOfLines = 0
        
        let titleStackView = UIStackView(arrangedSubviews: [
            iconView,
            eventLabel
        ])
        titleStackView.axis = .horizontal
        titleStackView.spacing = 10
        titleStackView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(titleStackView)
        contentView.addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
            titleStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            titleStackView.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            descriptionLabel.topAnchor.constraint(equalTo: titleStackView.bottomAnchor)
//            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
//        if let descriptionLabel = descriptionLabel {
//            contentView.addSubview(descriptionLabel)
//            NSLayoutConstraint.activate([
//                descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
//                descriptionLabel.topAnchor.constraint(equalTo: titleStackView.bottomAnchor),
//                descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
//            ])
//        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with forecast: AnyHashable) {
        guard let model = forecast as? Alert else { return }
        
        var alertsCount: Int {
            
            return 1
        }
        
        var descriptionString: String {
            let tags = model.tags
            let string = tags.joined(separator: ", ")
            return string
        }
        
        eventLabel.text = model.event
        iconView.image = UIImage(systemName: "exclamationmark.triangle.fill")
        
        descriptionLabel.text = model.senderName + ": " + descriptionString
        
    }
    
    
}
