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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        titleLabel.font = .systemFont(ofSize: 12)
        titleLabel.textColor = .systemGray4
        
        symbolView.contentMode = .scaleAspectFit
        symbolView.tintColor = .systemGray4
        
        backgroundView.backgroundColor = .systemGray2
        backgroundView.layer.cornerRadius = 12
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        let headerTitleStackView = UIStackView(arrangedSubviews: [
            symbolView,
            titleLabel
        ])
        headerTitleStackView.axis = .horizontal
        headerTitleStackView.alignment = .firstBaseline
        
        headerTitleStackView.spacing = 4
        headerTitleStackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(backgroundView)
        addSubview(headerTitleStackView)
        
        NSLayoutConstraint.activate([
            backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundView.topAnchor.constraint(equalTo: topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor),

            headerTitleStackView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 16),
            headerTitleStackView.widthAnchor.constraint(greaterThanOrEqualToConstant: 50),
            headerTitleStackView.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 12)
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
