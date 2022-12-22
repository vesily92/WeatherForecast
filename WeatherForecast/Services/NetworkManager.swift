//
//  NetworkManager.swift
//  WeatherForecast
//
//  Created by Василий Пронин on 07.02.2022.
//

import Foundation

class NetworkManager {
    
    static let shared = NetworkManager()
            
    private init() {}
    
    func fetchOneCallData(withLatitude latitude: Double, longitude: Double, andCompletion completion: @escaping (ForecastData) -> Void) {
        let urlString = "https://api.openweathermap.org/data/2.5/onecall?lat=\(latitude)&lon=\(longitude)&exclude=minutely&appid=\(apiKey)&units=metric&lang=en"
        
        guard let url = URL(string: urlString) else { return }
        
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { data, response, error in
            guard let data = data, let response = response else {
                print(error?.localizedDescription ?? "No error description")
                return
            }
            
            guard url == response.url else { return }
//            print(String(data: data, encoding: .utf8)!)
            do {
                let forecastData = try JSONDecoder().decode(ForecastData.self, from: data)
                DispatchQueue.main.async {
                    completion(forecastData)
                }
            } catch let error {
                print(String(describing: error))
            }
        }
        task.resume()
    }
    
    func fetchCoordinates(with query: String, completion: @escaping ([GeocodingData]) -> Void) {
        let urlString = "https://api.openweathermap.org/geo/1.0/direct?q=\(query)&limit=\(5)&appid=\(apiKey)"
        
        guard let url = URL(string: urlString) else { return }
        
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { data, response, error in
            guard let data = data, let response = response else {
                print(error?.localizedDescription ?? "No error description")
                return
            }
            
            guard url == response.url else { return }
//            print(String(data: data, encoding: .utf8)!)
            do {
                let locations = try JSONDecoder().decode([GeocodingData].self, from: data)
                DispatchQueue.main.async {
                    completion(locations)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
}
