//
//  SunriseCell.swift
//  WeatherForecast
//
//  Created by Василий Пронин on 01.04.2022.
//

import Foundation
import UIKit

class SunriseCell: UICollectionViewCell, SelfConfiguringCell {
    static let reuseIdentifier = "SunriseCell"
    
    private lazy var timeLabel = UILabel()
    private lazy var titleLabel = UILabel()
    private lazy var iconView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        timeLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        timeLabel.textColor = .white
        
        titleLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        titleLabel.textColor = .white
        
        iconView.preferredSymbolConfiguration = .preferringMulticolor()
        iconView.contentMode = .scaleAspectFit
       
        let stackView = UIStackView(arrangedSubviews: [
            timeLabel,
            iconView,
            titleLabel
        ])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalCentering
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(stackView)
        
        setupConstraints(for: stackView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with forecast: AnyHashable) {
        guard let forecast = forecast as? Daily else { return }
        
        timeLabel.text = DateFormatter.format(unixTime: forecast.sunrise, to: .sunrise)
        titleLabel.text = "Sunset"
        iconView.image = UIImage(systemName: "sunset.fill")
    }
    
    fileprivate func setupConstraints(for uiView: UIView) {
        NSLayoutConstraint.activate([
            uiView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            uiView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            uiView.heightAnchor.constraint(greaterThanOrEqualToConstant: 90)
        ])
    }
}
