//
//  SectionHeader.swift
//  WeatherForecast
//
//  Created by Василий Пронин on 15.02.2022.
//

import UIKit

final class SectionHeader: UICollectionReusableView {
    static let reuseIdentifier = "SectionHeader"
    
    private lazy var titleLabel = UILabel(.mainText20)
    private lazy var symbolView = UIImageView(.monochrome(.gray))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
//        symbolView.contentMode = .scaleAspectFit
//        symbolView.preferredSymbolConfiguration = UIImage.SymbolConfiguration(
//            font: .systemFont(ofSize: 20)
//        )

        let stackView = UIStackView(arrangedSubviews: [
            symbolView,
            titleLabel
        ])
        stackView.axis = .horizontal
        stackView.alignment = .firstBaseline
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackView.widthAnchor.constraint(greaterThanOrEqualToConstant: 50),
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 12)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureForAlertSection(with forecast: ForecastData) {
        guard let alerts = forecast.alerts?.count,
              let event = forecast.alerts?.first?.event else {
                  return
              }
        var areFew: Bool {
            return alerts > 1 ? true : false
        }
        symbolView.tintColor = .white
        
        titleLabel.text = areFew ? "\(event.capitalized) & \(alerts - 1) More" : "\(event)"
        symbolView.image = UIImage(systemName: "exclamationmark.triangle.fill")
    }

    func configure(with section: Section) {
        titleLabel.textColor = .gray
        symbolView.tintColor = .gray
        
        titleLabel.text = section.headerTitle
        symbolView.image = UIImage(systemName: section.headerIcon)
    }
}
