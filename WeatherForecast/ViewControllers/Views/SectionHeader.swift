//
//  SectionHeader.swift
//  WeatherForecast
//
//  Created by Василий Пронин on 15.02.2022.
//

import UIKit

final class SectionHeader: UICollectionReusableView {
    static let reuseIdentifier = "SectionHeader"
    
    let titleLabel = UILabel()
    let symbolView = UIImageView()
    let backgroundView = UIImageView()
    let supportingBackgroundView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        titleLabel.font = .systemFont(ofSize: 12)
        titleLabel.textColor = .systemGray4
        
        symbolView.contentMode = .scaleAspectFit
        symbolView.tintColor = .systemGray4
        
        backgroundView.backgroundColor = .systemGray2
        backgroundView.layer.cornerRadius = 12
//        backgroundView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        supportingBackgroundView.backgroundColor = .systemGray4
        supportingBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        let headerTitleStackView = UIStackView(arrangedSubviews: [
            symbolView,
            titleLabel
        ])
        headerTitleStackView.axis = .horizontal
        headerTitleStackView.alignment = .firstBaseline
        
        headerTitleStackView.spacing = 4
        headerTitleStackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(supportingBackgroundView)
        addSubview(backgroundView)
        addSubview(headerTitleStackView)
        
        NSLayoutConstraint.activate([
            supportingBackgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            supportingBackgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
            supportingBackgroundView.topAnchor.constraint(equalTo: topAnchor),
            supportingBackgroundView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),

            backgroundView.leadingAnchor.constraint(equalTo: supportingBackgroundView.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: supportingBackgroundView.trailingAnchor),
            backgroundView.topAnchor.constraint(equalTo: supportingBackgroundView.topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
//            backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
//            backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
//            backgroundView.topAnchor.constraint(equalTo: topAnchor),
//            backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor),

            headerTitleStackView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 16),
            headerTitleStackView.widthAnchor.constraint(greaterThanOrEqualToConstant: 50),
            headerTitleStackView.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 12),
            headerTitleStackView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -12)
        ])
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
