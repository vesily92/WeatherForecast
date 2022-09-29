//
//  SearchViewCOntroller.swift
//  WeatherForecast
//
//  Created by Василий Пронин on 16.09.2022.
//

import UIKit
import CoreLocation
import CoreData

class SearchViewController: UIViewController, UpdatableWithForecastData {
    
    private enum SearchSection: Int {
        case main
    }
            
    var onSearchResultTapped: ((ForecastData, Bool) -> Void)?
    var onForecastDataChanged: (([ForecastData]) -> Void)?
    
    var forecastData: [ForecastData] = [] {
        didSet { onForecastDataChanged?(forecastData) }
    }
    private var collectionView: UICollectionView!
    private let searchVC = UISearchController(searchResultsController: ResultsViewController())
    private var searchDataSource: UICollectionViewDiffableDataSource<SearchSection, ForecastData>!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .darkGray

        setupNavBar()
        setupSearchBar()
        setupCollectionView()
        createDataSource()
        
        makeSnapshot()
        
        NotificationCenter.default.addObserver(
            forName: .appendData,
            object: nil,
            queue: .main
        ) { notification in
            guard let object = notification.object as? [NotificationKeys: ForecastData] else {
                return
            }
            guard let data = object[NotificationKeys.data] else { return }
            self.forecastData.append(data)
            self.searchVC.searchBar.text = ""
            
            var snapshot = self.searchDataSource.snapshot()
            snapshot.appendItems([data])
            self.searchDataSource.apply(snapshot, animatingDifferences: true)
        }
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        collectionView.isEditing = editing
    }
    
    private func setupNavBar() {
        navigationItem.rightBarButtonItem = editButtonItem
        
        navigationItem.rightBarButtonItem?.tintColor = .white
        navigationItem.hidesSearchBarWhenScrolling = false
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.barStyle = .black
        title = "Weather"
    }
    
    private func setupSearchBar() {
        searchVC.searchBar.placeholder = "Search for city"
        searchVC.searchResultsUpdater = self
        searchVC.searchBar.tintColor = .white
        searchVC.obscuresBackgroundDuringPresentation = true
        searchVC.definesPresentationContext = true
        navigationItem.searchController = searchVC
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            var configuration = UICollectionLayoutListConfiguration(appearance: .sidebar)
            configuration.backgroundColor = .clear
            configuration.trailingSwipeActionsConfigurationProvider = { [weak self] indexPath in
                return self?.trailingSwipeActionsConfiguration(for: indexPath)
            }
            let section = NSCollectionLayoutSection.list(
                using: configuration,
                layoutEnvironment: layoutEnvironment
            )
            section.interGroupSpacing = 10
            return section
        }
        collectionView = UICollectionView(
            frame: view.bounds,
            collectionViewLayout: layout
        )
        collectionView.delegate = self
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(collectionView)
    }
    
    private func createDataSource() {
        let searchCellRegistration = UICollectionView.CellRegistration<SearchCollectionViewCell, ForecastData> { [weak self] cell, indexPath, forecast in
            guard let self = self else { return }
            
            var backgroundConfig = UIBackgroundConfiguration.listPlainCell()
            backgroundConfig.backgroundColorTransformer = UIConfigurationColorTransformer { [weak cell] _ in
                if let state = cell?.configurationState {
                    if state.isSelected || state.isHighlighted {
                        return .clear
                    }
                }
                return .clear
            }
            
            if indexPath.item != 0 {
                let accessories: [UICellAccessory] = [
                    .delete(displayed: .whenEditing) { [weak self] in
                        self?.deleteItem(forecast)
                    },
                    .reorder(
                        displayed: .whenEditing,
                        options: .init(tintColor: .white)
                    )
                ]
                cell.accessories = accessories
            }
            cell.backgroundConfiguration = backgroundConfig
            cell.configure(with: forecast, indexPath: indexPath)
        }
        
        searchDataSource = UICollectionViewDiffableDataSource(
            collectionView: collectionView
        ) { collectionView, indexPath, forecast in
            return collectionView.dequeueConfiguredReusableCell(
                using: searchCellRegistration,
                for: indexPath,
                item: forecast
            )
        }
        searchDataSource.reorderingHandlers.canReorderItem = { forecast -> Bool in
            true
        }
        searchDataSource.reorderingHandlers.didReorder = { [weak self] transaction in
            transaction.sectionTransactions.forEach { sectionTransaction in
                guard let self = self else { return }
                var forecastData = self.forecastData
                forecastData = sectionTransaction.finalSnapshot.items
                self.forecastData = forecastData
            }
        }
    }
    
    private func makeSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<SearchSection, ForecastData>()

        snapshot.appendSections([.main])
        snapshot.appendItems(forecastData, toSection: .main)
        searchDataSource.applySnapshotUsingReloadData(snapshot)
    }
    
    private func deleteItem(_ forecastData: ForecastData) {
        if let index = self.forecastData.firstIndex(where: { $0.id == forecastData.id }) {
            self.forecastData.remove(at: index)
        }
        
        var snapshot = searchDataSource.snapshot()
        snapshot.deleteItems([forecastData])
        searchDataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func trailingSwipeActionsConfiguration(for indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if indexPath.item != 0 {
            guard let forecast = searchDataSource.itemIdentifier(for: indexPath) else {
                return nil
            }
            let configuration = UISwipeActionsConfiguration(
                actions: [deleteAction(forecast)]
            )
            return configuration
        }
        return nil
    }
    
    private func deleteAction(_ forecastData: ForecastData) -> UIContextualAction {
        let deleteAction = UIContextualAction(
            style: .destructive,
            title: nil
        ) { [weak self] _, _, completionHandler in
            guard let self = self else { return }
            self.deleteItem(forecastData)
            completionHandler(true)
        }
        deleteAction.image = UIImage(systemName: "trash")
        return deleteAction
    }
    
    private func checkIf(array: [ForecastData], doesNotContain element: ForecastData) -> Bool {
        var verifiedArray = array
        verifiedArray.removeFirst()
        var boolean = true
        verifiedArray.forEach { city in
            if city.lat == element.lat && city.lon == element.lon {
                boolean = false
            }
        }
        return boolean
    }
}

extension SearchViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        NotificationCenter.default.post(
            name: .scrollToItem,
            object: [NotificationKeys.indexPath: indexPath]
        )
        dismiss(animated: true)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, targetIndexPathForMoveOfItemFromOriginalIndexPath originalIndexPath: IndexPath, atCurrentIndexPath currentIndexPath: IndexPath, toProposedIndexPath proposedIndexPath: IndexPath) -> IndexPath {
        if proposedIndexPath.item == 0 {
            return IndexPath(item: proposedIndexPath.item + 1, section: 0)
        } else {
            return proposedIndexPath
        }
    }
}

extension SearchViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchVC.searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty,
              let resultsVC = searchController.searchResultsController as? ResultsViewController else {
            return
        }
        resultsVC.delegate = self
        
        LocationManager.shared.getLocations(with: query) { locations in
            guard let locations = locations else { return }
            DispatchQueue.main.async {
                resultsVC.update(with: locations)
            }
        }
    }
}

extension SearchViewController: ResultsViewControllerDelegate {
    
    func didTapLocation(with coordinates: CLLocation) {
        searchVC.dismiss(animated: true)
        NetworkManager.shared.fetchOneCallData(withLatitude: coordinates.coordinate.latitude, longitude: coordinates.coordinate.longitude) { [weak self] forecastData in
            guard let self = self else { return }
            let isNew = self.checkIf(
                array: self.forecastData,
                doesNotContain: forecastData
            )
            self.onSearchResultTapped?(forecastData, isNew)
        }
    }
}
