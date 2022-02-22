//
//  GlobalFooter.swift
//  WeatherForecast
//
//  Created by Василий Пронин on 22.02.2022.
//

import UIKit

class GlobalFooter: UICollectionReusableView {
    static let reuseIdentifier = "GlobalFooter"
    
    let titleLabel = UILabel()
    let backgroundView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        titleLabel.font = .systemFont(ofSize: 20, weight: .black)
        titleLabel.textColor = .white
        
        backgroundView.backgroundColor = .black
        backgroundView.clipsToBounds = true
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        
//        let containerStachView = UIStackView(arrangedSubviews: [
//
//        ])
//        containerStachView.axis = .horizontal
//        containerStachView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(titleLabel)
        addSubview(backgroundView)
        
        NSLayoutConstraint.activate([
            
            backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor),
            backgroundView.heightAnchor.constraint(equalToConstant: 60),
            
            titleLabel.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -16),
            titleLabel.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 16)
            
            
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
