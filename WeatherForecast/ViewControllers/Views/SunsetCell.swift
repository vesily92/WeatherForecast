//
//  SunsetCell.swift
//  WeatherForecast
//
//  Created by Василий Пронин on 24.02.2022.
//

import UIKit

class SunsetCell: UICollectionViewCell, SelfConfiguringCell {
    
    static let reuseIdentifier = "SunsetCell"
    
    let timeLabel = UILabel()
    let titleLabel = UILabel()
    let weatherIconView = UIImageView()
    
    private let symbolConfig = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 22))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        timeLabel.font = .systemFont(ofSize: 16, weight: .medium)
        timeLabel.textColor = .white
        
        titleLabel.font = .systemFont(ofSize: 18, weight: .bold)
        titleLabel.textColor = .white
        
        weatherIconView.preferredSymbolConfiguration = .preferringMulticolor()
        weatherIconView.contentMode = .scaleAspectFit
        
        let stackView = UIStackView(arrangedSubviews: [
            timeLabel,
            weatherIconView,
            titleLabel
        ])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        setupConstraints(for: stackView)
    }
    
    func configure(with forecast: AnyHashable) {
        guard let model = forecast as? Current else { return }
        guard let time = model.sunset else { return }
        
        timeLabel.text = DateManager.shared.defineDate(withUnixTime: time, andDateFormat: .sunTime)
        titleLabel.text = "Sunrise"
        weatherIconView.image = UIImage(systemName: "sunrise.fill", withConfiguration: symbolConfig)
    }
    
    fileprivate func setupConstraints(for uiView: UIView) {
        contentView.addSubview(uiView)
        
        NSLayoutConstraint.activate([
            uiView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            uiView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            uiView.heightAnchor.constraint(equalToConstant: 120)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
