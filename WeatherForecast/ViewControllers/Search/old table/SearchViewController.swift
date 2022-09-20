//
//  SearchViewController.swift
//  WeatherForecast
//
//  Created by Василий Пронин on 28.07.2022.
//

import UIKit
import CoreLocation

//protocol SearchViewControllerDelegate: AnyObject {
//    func didTapCity(with indexPath: IndexPath)
//}

class SearchViewController: UIViewController, UpdatableWithForecastData {
//    var onCitySelected: (([ForecastData]) -> Void)?
//
//    var onSearchTapped: (() -> Void)?
//
    var onForecastDataChanged: (([ForecastData]) -> Void)?
//
    
    
    
    
    
    
//    weak var delegate: SearchViewControllerDelegate?

    weak var coordinator: Coordinator?
    
//    var forecastData: [ForecastData] = []
    var forecastData: [ForecastData] = [] {
        didSet { onForecastDataChanged?(forecastData) }
    }
    var observer: NSObjectProtocol?
    
    private let notificationCenter = NotificationCenter.default
    
    private let searchVC = UISearchController(searchResultsController: ResultsViewController())
    private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(
            SearchViewCell.self,
            forCellReuseIdentifier: SearchViewCell.reuseIdentifier
        )
        return tableView
    }()
    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        tableView.frame = view.bounds
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .darkGray
        
        setupNavBar()
        setupSearchBar()
        setupTableView()
        
        setupObserver()
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: animated)
    }
    
    private func setupObserver() {

        observer = NotificationCenter.default.addObserver(
            forName: .appendData,
            object: nil,
            queue: .main
        ) { notification in
            guard let object = notification.object as? [String: ForecastData] else {
                return
            }
            guard let data = object["data"] else { return }
            self.forecastData.append(data)
            self.searchVC.searchBar.text = ""
            self.tableView.reloadData()
        }
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
//        searchVC.searchBar.showsCancelButton = false
        navigationItem.searchController = searchVC
    }

    private func setupTableView() {
        tableView.frame = view.bounds
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .darkGray
        tableView.rowHeight = 106
        view.addSubview(tableView)
    }
    
    private func checkIf(array: [ForecastData], doesNotContain element: ForecastData) -> Bool {
        var verifiableArray = array
        verifiableArray.removeFirst()
        
        var boolean = true
        
        verifiableArray.forEach { city in
            if city.lat == element.lat && city.lon == element.lon {
                boolean = false
            }
        }
        return boolean
    }
}

extension SearchViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        forecastData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchViewCell.reuseIdentifier, for: indexPath) as? SearchViewCell else {
            fatalError()
        }
//        if let forecastData = forecastData {
            cell.configure(with: forecastData[indexPath.row])
//        }
        cell.backgroundColor = .darkGray
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        indexPath.row == 0 ? false : true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        guard let forecastData = forecastData else { return }
        tableView.beginUpdates()
        forecastData.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
        tableView.endUpdates()
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let currentRow = forecastData.remove(at: sourceIndexPath.row)
        forecastData.insert(currentRow, at: destinationIndexPath.row)
    }
}

extension SearchViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NotificationCenter.default.post(
            name: .scrollToItem,
            object: ["indexPath": indexPath]
        )
        dismiss(animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        if indexPath.row != 0 {
            let deleteAction = UIContextualAction(
                style: .destructive,
                title: ""
            ) { (action, sourceView, completionHandler) in
                let forecast = self.forecastData[indexPath.row]
                self.swipeDeleteAction(forecast, indexPath: indexPath)
                completionHandler(true)
            }
            
            let image = UIImage(systemName: "trash.fill")
            image?.withTintColor(.white)
            
            deleteAction.image = image
            
            let swipeActionsConfiguration = UISwipeActionsConfiguration(
                actions: [deleteAction]
            )
            return swipeActionsConfiguration
//        }
//        return nil
    }

    func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        if proposedDestinationIndexPath.row == 0 {
            return IndexPath(row: proposedDestinationIndexPath.row + 1, section: 0)
        }
        return proposedDestinationIndexPath
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        .delete
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        false
    }
}

extension SearchViewController {
    
    private func swipeDeleteAction(_ forecastData: ForecastData, indexPath: IndexPath) {
        NotificationCenter.default.post(
            name: .removeData,
            object: ["data": forecastData]
        )
        self.forecastData.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
        tableView.reloadData()
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
        print("SearchVC didTapLocation method started")
//        print(searchVC.searchBar.resignFirstResponder())
//        searchVC.searchBar.resignFirstResponder()
        searchVC.dismiss(animated: true)
        print("SearchVC didTapLocation dismiss")
        NetworkManager.shared.fetchOneCallData(withLatitude: coordinates.coordinate.latitude, longitude: coordinates.coordinate.longitude) { [weak self] forecastData in
            print("SearchVC didTapLocation NetworkManager")
            guard let self = self else { return }
            print("SearchVC didTapLocation NetworkManager guard passed")
            let isNew = self.checkIf(
                array: self.forecastData,
                doesNotContain: forecastData
            )
            self.coordinator?.showResult(with: forecastData, isNew: isNew)
//            self.coordinator?.showResult(with: forecastData)
            print("SearchVC didTapLocation NetworkManager coordinator called")
        }
    }
}
