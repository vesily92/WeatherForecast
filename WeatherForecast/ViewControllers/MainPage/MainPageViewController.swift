//
//  MainPageViewController.swift
//  WeatherForecast
//
//  Created by Василий Пронин on 13.12.2022.
//

import UIKit

class MainPageViewController: UIViewController, UpdatableWithForecastData {
    
    private typealias DataSource = UICollectionViewDiffableDataSource<Int, ForecastData>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Int, ForecastData>
    
    // MARK: Callbacks
    
    var coordinator: Coordinator?
    var onCellDidTap: ((ForecastData, Int) -> Void)?
    var onSearchTapped: (([ForecastData]) -> Void)?
    
    // MARK: Properties
    
    var forecastData: [ForecastData] = [] {
        didSet {
            pageControl.numberOfPages = forecastData.count
            makeSnapshot()
            setupNavBar()
        }
    }

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
    
    // MARK: Setup UI
    
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
    
    // MARK: Setup layout
    
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
    
    // MARK: DataSource
    
    private func createDataSource() {
        print("MPVC data source")
        dataSource = DataSource(
            collectionView: collectionView
        ) { [weak self] collectionView, indexPath, forecast in
            guard let cell = self?.collectionView.dequeueReusableCell(
                withReuseIdentifier: MainPageCollectionViewCell.reuseIdentifier,
                for: indexPath
            ) as? MainPageCollectionViewCell else {
                fatalError("Unable to dequeue DailyDetailedCollectionViewCell")
            }
            cell.mainPageView.onCellTapped = { [weak self] forecast, index in
                self?.onCellDidTap?(forecast, index)
            }
            cell.configure(with: forecast)
            
            return cell
        }
    }

    private func makeSnapshot() {
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(forecastData)
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    // MARK: Current location data methods
    
    private func fetchData(withLat latitude: Double, andLon longitude: Double) {
        
        NetworkManager.shared.fetchOneCallData(
            withLatitude: latitude,
            longitude: longitude
        ) { [weak self] forecastData in
            guard let self = self else { return }
            self.forecastData.append(forecastData)
        }
    }
    
    private func fetchDataForUserLocation() {
        LocationManager.shared.getUserLocation { [weak self] latitude, longitude in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.fetchData(withLat: latitude, andLon: longitude)
            }
        }
    }
}
