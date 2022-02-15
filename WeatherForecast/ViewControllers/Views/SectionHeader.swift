//
//  SectionHeader.swift
//  WeatherForecast
//
//  Created by Василий Пронин on 15.02.2022.
//

import UIKit

final class SectionHeader: UICollectionReusableView {
    static let reuseIdentifier = "SectionHeader"
    
    let title = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        title.font = .systemFont(ofSize: 12)
        title.textColor = .systemBackground
        
        let separator = UIView(frame: .zero)
        separator.backgroundColor = .systemBackground
        separator.translatesAutoresizingMaskIntoConstraints = false
        
        let stackView = UIStackView(arrangedSubviews: [
            title,
            separator
        ])
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            separator.heightAnchor.constraint(equalToConstant: 0.5),
            
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        stackView.setCustomSpacing(10, after: title)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
