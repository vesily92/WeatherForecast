//
//  SectionHeader.swift
//  WeatherForecast
//
//  Created by Василий Пронин on 15.02.2022.
//

import UIKit

final class SectionHeader: UICollectionReusableView {
    static let reuseIdentifier = "SectionHeader"
    
    lazy private var titleLabel = UILabel()
    lazy private var iconView = UIImageView()
    lazy private var backgroundView = UIImageView()
    lazy private var supportingBackgroundView = UIImageView()
    
    private let symbolConfig = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 14))
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        iconView.contentMode = .scaleAspectFit

//        backgroundView.backgroundColor = .systemGray2
//        backgroundView.layer.cornerRadius = 12
////        backgroundView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
//        backgroundView.translatesAutoresizingMaskIntoConstraints = false
//
//        supportingBackgroundView.backgroundColor = .systemGray4
//        supportingBackgroundView.translatesAutoresizingMaskIntoConstraints = false
//
        let headerTitleStackView = UIStackView(arrangedSubviews: [
            iconView,
            titleLabel
        ])
        headerTitleStackView.axis = .horizontal
        headerTitleStackView.alignment = .firstBaseline
        
        headerTitleStackView.spacing = 4
        headerTitleStackView.translatesAutoresizingMaskIntoConstraints = false
        
//        addSubview(supportingBackgroundView)
//        addSubview(backgroundView)
        addSubview(headerTitleStackView)
        
        NSLayoutConstraint.activate([
//            supportingBackgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
//            supportingBackgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
//            supportingBackgroundView.topAnchor.constraint(equalTo: topAnchor),
//            supportingBackgroundView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
//
//            backgroundView.leadingAnchor.constraint(equalTo: supportingBackgroundView.leadingAnchor),
//            backgroundView.trailingAnchor.constraint(equalTo: supportingBackgroundView.trailingAnchor),
//            backgroundView.topAnchor.constraint(equalTo: supportingBackgroundView.topAnchor),
//            backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor),
//            
//            headerTitleStackView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 16),
//            headerTitleStackView.widthAnchor.constraint(greaterThanOrEqualToConstant: 50),
//            headerTitleStackView.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 12),
//            headerTitleStackView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -12)
//            
            headerTitleStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            headerTitleStackView.widthAnchor.constraint(greaterThanOrEqualToConstant: 50),
            headerTitleStackView.topAnchor.constraint(equalTo: topAnchor, constant: 12)
            
        ])
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        
    }
    
    func isHeaderReachedTopEdge(for staticYPosition: CGFloat) -> Bool {
        return self.frame.origin.y > staticYPosition
    }
    
    
    
    func configureForAlertSection(with forecast: ForecastData) {
        guard let alerts = forecast.alerts?.count,
              let event = forecast.alerts?.first?.event else {
                  return
              }

        var areFew: Bool {
            return alerts > 1 ? true : false
        }
        
        titleLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        titleLabel.textColor = .white
        
        iconView.tintColor = .white
        
        titleLabel.text = areFew ? "\(event) & \(alerts - 1) More" : event
        iconView.image = UIImage(systemName: "exclamationmark.triangle.fill")
    }
    
    func configure(with section: Section) {
        titleLabel.font = .systemFont(ofSize: 12)
        titleLabel.textColor = .systemGray4
        
        iconView.tintColor = .systemGray4
        
        titleLabel.text = section.headerTitle.uppercased()
        iconView.image = UIImage(systemName: section.headerIcon, withConfiguration: symbolConfig)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
