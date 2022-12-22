//
//  ResultsViewController.swift
//  WeatherForecast
//
//  Created by Василий Пронин on 02.08.2022.
//

import UIKit

protocol ResultsViewControllerDelegate: AnyObject {
    func didTapLocation(withLat lat: Double, lon: Double, andData data: GeocodingData)
}

class ResultsViewController: UIViewController {
    
    weak var delegate: ResultsViewControllerDelegate?
        
    var geocodingData: [GeocodingData] = []
    
    private var tableView: UITableView!
    private lazy var zeroStateView = ZeroStateView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupUI()
    }

    public func update(with data: [GeocodingData], and query: String) {
        if data.isEmpty {
            zeroStateView.configure(with: query)
            tableView.isHidden = true
            zeroStateView.isHidden = false
        } else {
            self.geocodingData = data
            tableView.isHidden = false
            zeroStateView.isHidden = true
        }
        tableView.reloadData()
    }
    
    private func setupUI() {
        let points = view.bounds.height / 3
        view.backgroundColor = .black
        
        zeroStateView.isHidden = true
        zeroStateView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(zeroStateView)
                
        
        NSLayoutConstraint.activate([
            zeroStateView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            zeroStateView.topAnchor.constraint(equalTo: view.topAnchor, constant: points)
        ])
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
        geocodingData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.contentView.backgroundColor = .black
        cell.backgroundColor = .black
        
        var content = cell.defaultContentConfiguration()
        content.textProperties.color = .white
        content.textProperties.numberOfLines = 0
        content.text = geocodingData[indexPath.row].fullName
        cell.contentConfiguration = content
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let lat = geocodingData[indexPath.row].lat
        let lon = geocodingData[indexPath.row].lon
        let data = geocodingData[indexPath.row]
        
        DispatchQueue.main.async {
            self.delegate?.didTapLocation(withLat: lat, lon: lon, andData: data)
        }
    }
}
