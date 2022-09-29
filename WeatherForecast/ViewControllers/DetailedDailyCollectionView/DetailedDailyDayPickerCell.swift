//
//  DailyDetailedDayPickerCell.swift
//  WeatherForecast
//
//  Created by Василий Пронин on 23.09.2022.
//


import UIKit

protocol DetailedDailyDayPickerItemProtocol: UIView {
    func onSelected()
    func onNotSelected()
}

class DetailedDailyDayPickerCell: UICollectionViewCell {
    
    static let reuseIdentifier = "DetailedDailyDayPickerCell"
    
    var view: DetailedDailyDayPickerItemProtocol? {
        didSet { configureCell() }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        view = nil
    }
    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    private func configureCell() {
        guard let view = view else { return }
        
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            view.topAnchor.constraint(equalTo: contentView.topAnchor),
            view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
}
