//
//  ResultsViewController.swift
//  WeatherForecast
//
//  Created by Василий Пронин on 02.08.2022.
//

import UIKit
import CoreLocation

protocol ResultsViewControllerDelegate: AnyObject {
    func didTapLocation(with coordinates: CLLocation)
}

class ResultsViewController: UIViewController {
    
    weak var delegate: ResultsViewControllerDelegate?
    
    var onLocationTapped: ((CLLocation) -> Void)?
    
    var locations: [Location] = []
    
    private var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }

    public func update(with locations: [Location]) {
        self.locations = locations
        tableView.reloadData()
    }
    
    private func setupTableView() {
        tableView = UITableView()
        tableView.frame = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.backgroundColor = .black
        view.addSubview(tableView)
    }
}

extension ResultsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.contentView.backgroundColor = .black
        cell.backgroundColor = .black
        
        var content = cell.defaultContentConfiguration()
        content.textProperties.color = .white
        content.textProperties.numberOfLines = 0
        content.text = locations[indexPath.row].cityName
        
        cell.contentConfiguration = content
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let latitude = locations[indexPath.row].latitude,
              let longitude = locations[indexPath.row].longitude else { return }
        tableView.deselectRow(at: indexPath, animated: true)
        DispatchQueue.main.async {
            self.delegate?.didTapLocation(with: CLLocation(latitude: latitude, longitude: longitude))
        }
    }
}
