//
//  DailyTempCell.swift
//  WeatherForecast
//
//  Created by Василий Пронин on 20.06.2022.
//

import UIKit

class DailyTempCell: UICollectionViewCell {
    static let reuseIdentifier = "DailyTempCell"
    
    private lazy var timeHeaderLabel = UILabel(.mainText20, color: .gray)
    private lazy var tempSymbol = UIImageView()
    private lazy var feelsLikeHeaderLabel = UILabel(.mainText20, color: .gray)
    
    private lazy var timeLabel = UILabel(.mainText20)
    private lazy var tempLabel = UILabel(.mainText20)
    private lazy var feelsLikeLabel = UILabel(.mainText20)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .systemGray2
        contentView.layer.cornerRadius = 12
        
        timeLabel.numberOfLines = 0
        tempLabel.numberOfLines = 0
        feelsLikeLabel.numberOfLines = 0
        
        let headerStack = UIStackView(arrangedSubviews: [
            tempSymbol,
            timeHeaderLabel
        ])
        headerStack.axis = .horizontal
        headerStack.spacing = 5
        
        let separator = UIView(frame: .zero)
        separator.backgroundColor = .gray
        separator.alpha = 0.7
        separator.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(separator)

        let feelsLikeStack = UIStackView(arrangedSubviews: [
            feelsLikeHeaderLabel,
            feelsLikeLabel
        ])
        feelsLikeStack.axis = .vertical
        feelsLikeStack.alignment = .trailing
        feelsLikeStack.distribution = .fillProportionally
        feelsLikeStack.spacing = 6
        feelsLikeStack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(feelsLikeStack)
        
        let timeAndTempStack = UIStackView(arrangedSubviews: [
            timeLabel,
            tempLabel
        ])
        timeAndTempStack.axis = .horizontal
        timeAndTempStack.distribution = .fillEqually
        timeAndTempStack.translatesAutoresizingMaskIntoConstraints = false
 
        let containerStack = UIStackView(arrangedSubviews: [
            headerStack,
            timeAndTempStack
        ])
        containerStack.axis = .vertical
        containerStack.alignment = .leading
        containerStack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(containerStack)
        
        NSLayoutConstraint.activate([
            containerStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerStack.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            
            separator.leadingAnchor.constraint(equalTo: containerStack.trailingAnchor, constant: 16),
            separator.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            separator.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            separator.widthAnchor.constraint(equalToConstant: 1),
            
            feelsLikeStack.leadingAnchor.constraint(equalTo: separator.trailingAnchor, constant: 16),
            feelsLikeStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            feelsLikeStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            feelsLikeStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with model: Daily) {
        let config = UIImage.SymbolConfiguration(
            font: UIFont.systemFont(ofSize: 16, weight: .bold)
        )
        
        timeLabel.text = "Morning:\nDay:\nEvening:\nNight:"
        timeLabel.setLineSpacing(to: 6)
        
        tempLabel.text = "\(model.temperature.morn.displayTemp())\n\(model.temperature.day.displayTemp())\n\(model.temperature.eve.displayTemp())\n\(model.temperature.night.displayTemp())"
        tempLabel.setLineSpacing(to: 6)
        tempLabel.textAlignment = .right
        
        feelsLikeLabel.text = "\(model.feelsLike.morn.displayTemp())\n\(model.feelsLike.day.displayTemp())\n\(model.feelsLike.eve.displayTemp())\n\(model.feelsLike.night.displayTemp())"
        feelsLikeLabel.setLineSpacing(to: 6)
        feelsLikeLabel.textAlignment = .right
        
        timeHeaderLabel.text = "Temperature"
        
        tempSymbol.preferredSymbolConfiguration = config
        tempSymbol.tintColor = .gray
        tempSymbol.contentMode = .scaleAspectFit
        tempSymbol.image = UIImage(systemName: "thermometer")

        feelsLikeHeaderLabel.text = "Feels Like"
    }
}
