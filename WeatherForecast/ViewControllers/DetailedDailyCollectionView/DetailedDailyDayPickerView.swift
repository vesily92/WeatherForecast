//
//  DetailedDailyDayPickerView.swift
//  WeatherForecast
//
//  Created by Василий Пронин on 22.09.2022.
//

import UIKit

protocol DetailedDailyDayPickerViewDelegate: AnyObject {
    func didSwitchTheDay(atIndex indexPath: IndexPath)
}

class DetailedDailyDayPickerView: UIView {
    
    weak var delegate: DetailedDailyDayPickerViewDelegate?
    
    var days: [DetailedDailyDayPickerItemProtocol] {
        didSet {
            collectionView.reloadData()
            days[index].onSelected()
        }
    }
    private var index = 0
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)

        let collectionView = UICollectionView(
            frame: self.bounds,
            collectionViewLayout: layout
        )
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.backgroundColor = .darkGray
        collectionView.showsHorizontalScrollIndicator = false

        collectionView.register(
            DetailedDailyDayPickerCell.self,
            forCellWithReuseIdentifier: DetailedDailyDayPickerCell.reuseIdentifier
        )
        self.addSubview(collectionView)

        return collectionView
    }()
    
    
    init(days: [DetailedDailyDayPickerItemProtocol] = []) {
        self.days = days
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func switchTheDay(at indexPath: IndexPath) {
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        days[index].onNotSelected()
        days[indexPath.item].onSelected()
        index = indexPath.item
    }
}

extension DetailedDailyDayPickerView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        days.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: DetailedDailyDayPickerCell.reuseIdentifier,
            for: indexPath
        ) as? DetailedDailyDayPickerCell else {
            fatalError("Unable to dequeue DetailedDailyDayPickerCell")
        }
        cell.view = days[indexPath.item]
        return cell
    }
}

extension DetailedDailyDayPickerView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switchTheDay(at: indexPath)
        delegate?.didSwitchTheDay(atIndex: indexPath)
    }
}

extension DetailedDailyDayPickerView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 80, height: 80)
    }
}
