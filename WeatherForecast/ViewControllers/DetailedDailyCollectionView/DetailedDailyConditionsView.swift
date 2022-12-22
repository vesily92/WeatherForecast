//
//  DetailedDailyConditionsView.swift
//  WeatherForecast
//
//  Created by Василий Пронин on 22.09.2022.
//

import UIKit

protocol DetailedDailyConditionsViewDelegate: AnyObject {
    func didScrollToPage(atIndex indexPath: IndexPath)
}

class DetailedDailyConditionsView: UIView {
    
    weak var delegate: DetailedDailyConditionsViewDelegate?
    
    var dailyData: [Daily] {
        didSet {
            collectionView.reloadData()
            DispatchQueue.main.async {
                self.scrollToPage(
                    at: IndexPath(item: self.index, section: 0),
                    animated: false
                )
            }
        }
    }
    var index: Int
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal

        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .darkGray
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(
            DetailedDailyConditionsCell.self,
            forCellWithReuseIdentifier: DetailedDailyConditionsCell.reuseIdentifier
        )
        self.addSubview(collectionView)
        
        return collectionView
    }()
    
    init(dailyData: [Daily] = [], index: Int) {
        self.dailyData = dailyData
        self.index = index
        super.init(frame: .zero)
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func scrollToPage(at indexPath: IndexPath, animated: Bool = true) {
        self.collectionView.scrollToItem(
            at: indexPath,
            at: .centeredHorizontally,
            animated: animated
        )
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            collectionView.widthAnchor.constraint(equalTo: self.widthAnchor),
            collectionView.heightAnchor.constraint(equalTo: self.heightAnchor),
            collectionView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            collectionView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
}

extension DetailedDailyConditionsView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dailyData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: DetailedDailyConditionsCell.reuseIdentifier,
            for: indexPath
        ) as? DetailedDailyConditionsCell else {
            fatalError("Unable to dequeue DailyDetailedCollectionViewCell")
        }
        
        let data = dailyData[indexPath.item]
        cell.configure(with: data)
        
        return cell
    }
}

extension DetailedDailyConditionsView: UICollectionViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index = Int(collectionView.contentOffset.x / collectionView.frame.size.width)
        delegate?.didScrollToPage(atIndex: IndexPath(item: index, section: 0))
    }
}

extension DetailedDailyConditionsView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(
            width: self.collectionView.frame.width,
            height: self.collectionView.frame.height
        )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
}
