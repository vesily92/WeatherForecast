//
//  SectionHeader.swift
//  WeatherForecast
//
//  Created by Василий Пронин on 15.02.2022.
//

import UIKit

final class SectionHeader: UICollectionReusableView {
    static let reuseIdentifier = "SectionHeader"
    
    private lazy var titleLabel = UILabel(fontSize: 16, color: .black, alpha: 0.3)
    private lazy var iconView = UIImageView()
    
    private let symbolConfig = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 14))
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        iconView.contentMode = .scaleAspectFit
        iconView.tintColor = .black
        iconView.alpha = 0.3
        
        let headerTitleStackView = UIStackView(arrangedSubviews: [
            iconView,
            titleLabel
        ])
        headerTitleStackView.axis = .horizontal
        headerTitleStackView.alignment = .firstBaseline
        
        headerTitleStackView.spacing = 4
        headerTitleStackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(headerTitleStackView)
        
        NSLayoutConstraint.activate([
            headerTitleStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            headerTitleStackView.widthAnchor.constraint(greaterThanOrEqualToConstant: 50),
            headerTitleStackView.topAnchor.constraint(equalTo: topAnchor, constant: 12)
        ])
    }

    func configureForAlertSection(with forecast: ForecastData) {
        guard let alerts = forecast.alerts?.count,
              let event = forecast.alerts?.first?.event else {
                  return
              }
        var areFew: Bool {
            return alerts > 1 ? true : false
        }
        titleLabel.text = areFew ? "Weather Alert: \(event) & \(alerts - 1) More" : "Weather Alert: \(event)"
        iconView.image = UIImage(systemName: "exclamationmark.triangle.fill")
    }

    func configure(with section: Section) {
        titleLabel.text = section.headerTitle
        iconView.image = UIImage(systemName: section.headerIcon)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
