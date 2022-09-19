//
//  MainPageViewController.swift
//  WeatherForecast
//
//  Created by Василий Пронин on 29.06.2022.
//

import UIKit
import CoreLocation

class MainPageViewController: UIViewController, UpdatableWithForecastData {
    
    private enum MainPageVCSection: Int, CaseIterable {
        case main
    }
    
    private typealias DataSource = UICollectionViewDiffableDataSource<MainPageVCSection, AnyHashable>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<MainPageVCSection, AnyHashable>
    
    var onSearchTapped: (([ForecastData]) -> Void)?
    
    var coordinator: Coordinator?
    var forecastData: [ForecastData] = [] {
        didSet {
            dataSource?.apply(makeSnapshot(), animatingDifferences: true)
            pageControl.numberOfPages = forecastData.count
            setupNavBar()
            print(forecastData.count)
//            setupPageControl()
        }
    }
    
    var locations: [Location]?
    
    private var observer: NSObjectProtocol?
    private var dataSource: DataSource?
    private var collectionView: UICollectionView!
    private var pageControl: UIPageControl!
      
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupPageControl()
        createDataSource()
        
        fetchDataForUserLocation()
        
        NotificationCenter.default.addObserver(
            forName: .scrollToItem,
            object: nil,
            queue: .main
        ) { notification in
            guard let object = notification.object as? [NotificationKeys: IndexPath] else {
                return
            }
            guard let indexPath = object[NotificationKeys.indexPath] else { return }
            self.pageControl.currentPage = indexPath.item
            self.collectionView.scrollToItem(
                at: indexPath,
                at: .centeredHorizontally,
                animated: false
            )
        }
    }
    
    @objc private func search() {
        onSearchTapped?(forecastData)
    }
    
    private func setupNavBar() {
        let config = UIImage.SymbolConfiguration(weight: .semibold)
        let image = UIImage(systemName: "magnifyingglass", withConfiguration: config)

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: image,
            style: .plain,
            target: self,
            action: #selector(search)
        )
        navigationItem.rightBarButtonItem?.tintColor = .white
    }
    
    private func setupPageControl() {
        pageControl = UIPageControl()
        pageControl.numberOfPages = 1
        pageControl.currentPage = 0
        pageControl.isUserInteractionEnabled = false
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.setIndicatorImage(
            UIImage(systemName: "location.fill"),
            forPage: 0
        )
        navigationController?.navigationBar.addSubview(pageControl)
        
        NSLayoutConstraint.activate([
            pageControl.centerXAnchor.constraint(
                equalTo: navigationController!.navigationBar.centerXAnchor
            ),
            pageControl.centerYAnchor.constraint(
                equalTo: navigationController!.navigationBar.centerYAnchor
            )
        ])
    }
    
    
    private func setupCollectionView() {
        collectionView = UICollectionView(
            frame: view.bounds,
            collectionViewLayout: createCompositionalLayout()
        )
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .darkGray
        collectionView.contentInsetAdjustmentBehavior = .never

        view.addSubview(collectionView)
        
        collectionView.register(
            MainPageCollectionViewCell.self,
            forCellWithReuseIdentifier: MainPageCollectionViewCell.reuseIdentifier
        )
    }
    
    private func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnv in
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
            )
            let group = NSCollectionLayoutGroup.vertical(
                layoutSize: groupSize, subitems: [item]
            )
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .groupPagingCentered
            
            section.visibleItemsInvalidationHandler = { items, offset, _ in
                self.pageControl.currentPage = Int(
                    offset.x / self.collectionView.frame.size.width
                )
            }
            return section
        }
        return layout
    }
    
    private func createDataSource() {
        dataSource = DataSource(
            collectionView: collectionView
        ) { [weak self] collectionView, indexPath, forecast in
            guard let section = MainPageVCSection(rawValue: indexPath.section) else {
                fatalError("Unknown section kind")
            }
            switch section {
            case .main:
                guard let cell = self?.collectionView.dequeueReusableCell(
                    withReuseIdentifier: MainPageCollectionViewCell.reuseIdentifier,
                    for: indexPath
                ) as? MainPageCollectionViewCell else {
                    fatalError("Unable to dequeue DailyDetailedCollectionViewCell")
                }
                cell.coordinator = self?.coordinator
                
                if let forecastData = self?.forecastData {
                    cell.configure(with: forecastData[indexPath.item])
                }
                return cell
            }
        }
    }
    
    private func reloadData() {
        var snapshot = Snapshot()

        snapshot.appendSections(MainPageVCSection.allCases)
        snapshot.appendItems(forecastData, toSection: .main)
        
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    private func makeSnapshot() -> Snapshot {
        var snapshot = Snapshot()

        snapshot.appendSections(MainPageVCSection.allCases)
        snapshot.appendItems(forecastData, toSection: .main)
        
        return snapshot
    }
    
    private func fetchData(with location: CLLocation) {
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        
        NetworkManager.shared.fetchOneCallData(
            withLatitude: latitude,
            longitude: longitude
        ) { [weak self] forecastData in
            guard let self = self else { return }
            self.forecastData.append(forecastData)
        }
    }
    
    private func fetchDataForUserLocation() {
        LocationManager.shared.getUserLocation { [weak self] location in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.fetchData(with: location)
            }
        }
    }
}
