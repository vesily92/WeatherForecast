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
    let subtitleLabel = UILabel()
    let backgroundView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        titleLabel.font = .systemFont(ofSize: 12)
        titleLabel.textColor = .systemBackground
        
        backgroundView.backgroundColor = .systemGray2
        
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(backgroundView)
        addSubview(titleLabel)
        
//        NSLayoutConstraint.activate([
//            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
//            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
//            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20),
//            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
//        ])
        
        NSLayoutConstraint.activate([
            backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor),

            titleLabel.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 4),
            titleLabel.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -4)
        ])
        //title.setCustomSpacing(10, after: title)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
