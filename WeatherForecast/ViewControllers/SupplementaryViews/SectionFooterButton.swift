//
//  SectionFooterButton.swift
//  WeatherForecast
//
//  Created by Василий Пронин on 16.06.2022.
//

import UIKit

class SectionFooterButton: UICollectionReusableView {
    static let reuseIdentifier = "SectionFooterButton"
    
    private lazy var seeMoreButton = UIButton(.seeMoreButton)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        seeMoreButton.translatesAutoresizingMaskIntoConstraints = false
        
        let separator = UIView(frame: .zero)
        separator.backgroundColor = .white
        separator.alpha = 0.7
        separator.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(separator)
        addSubview(seeMoreButton)
        
        NSLayoutConstraint.activate([
            separator.heightAnchor.constraint(equalToConstant: 0.5),
            separator.topAnchor.constraint(equalTo: topAnchor),
            separator.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            separator.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            seeMoreButton.topAnchor.constraint(equalTo: separator.bottomAnchor),
            seeMoreButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            seeMoreButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            seeMoreButton.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
