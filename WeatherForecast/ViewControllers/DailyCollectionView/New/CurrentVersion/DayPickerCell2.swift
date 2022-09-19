//
//  DayPickerCell2.swift
//  WeatherForecast
//
//  Created by Василий Пронин on 14.07.2022.
//

import UIKit

protocol DayPickerItemProtocol: UIView {
    func onSelected()
    func onNotSelected()
}

class TabCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    public var view: DayPickerItemProtocol? {
        didSet {
            self.setupUI()
        }
    }
    
    var leftConstraint = NSLayoutConstraint()
    var topConstraint = NSLayoutConstraint()
    var rightConstraint = NSLayoutConstraint()
    var bottomConstraint = NSLayoutConstraint()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        view = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var contentInsets: UIEdgeInsets = UIEdgeInsets(
        top: 0,
        left: 0,
        bottom: 0,
        right: 0
    ) {
        didSet {
            leftConstraint.constant = contentInsets.left
            topConstraint.constant = contentInsets.top
            rightConstraint.constant = -contentInsets.right
            bottomConstraint.constant = -contentInsets.bottom
//            self.contentView.layoutIfNeeded()
        }
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        guard let view = view else { return }
        
        contentView.layer.cornerRadius = contentView.frame.width / 2
        
        self.contentView.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        leftConstraint = view.leadingAnchor.constraint(
            equalTo: contentView.leadingAnchor,
            constant: contentInsets.left
        )
        rightConstraint = view.trailingAnchor.constraint(
            equalTo: contentView.trailingAnchor,
            constant: -contentInsets.right
        )
        topConstraint = view.topAnchor.constraint(
            equalTo: contentView.topAnchor,
            constant: contentInsets.top
        )
        bottomConstraint = view.bottomAnchor.constraint(
            equalTo: contentView.bottomAnchor,
            constant: -contentInsets.bottom
        )
        
        NSLayoutConstraint.activate([
            leftConstraint,
            topConstraint,
            rightConstraint,
            bottomConstraint
        ])
    }
}
