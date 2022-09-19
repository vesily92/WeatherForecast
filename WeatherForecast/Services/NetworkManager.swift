//
//  NetworkManager.swift
//  WeatherForecast
//
//  Created by Василий Пронин on 07.02.2022.
//

import Foundation
import CoreLocation

class NetworkManager {
    
    enum RequestType {
        case cityName(city: String)
        case coordinates(latitude: CLLocationDegrees, longitude: CLLocationDegrees)
    }
    
    enum DataType {
        case alertsData
        case hourlyData
        case dailyData
    }

    static let shared = NetworkManager()
    
    var onCompletion: ((CurrentWeather) -> Void)?
    
    private init() {}
    
    func fetchOneCallData(withLatitude latitude: CLLocationDegrees, longitude: CLLocationDegrees, andCompletion completion: @escaping (ForecastData) -> Void) {
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
    
    func fetchCurrentWeatherData(forRequestType requestType: RequestType) {
        var urlString = ""
        switch requestType {
        case .cityName(let city):
            urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(apiKey)&units=metric"
        case .coordinates(let latitude, let longitude):
            urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)&units=metric"
        }
        performRequest(withURLString: urlString)
    }
    
    fileprivate func performRequest(withURLString urlString: String) {
        guard let url = URL(string: urlString) else { return }
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { data, response, error in
            guard let data = data else {
                print(error?.localizedDescription ?? "No error description")
                return
            }
            if let currentWeather = self.parseJSON(withData: data) {
                self.onCompletion?(currentWeather)
            }
        }
        task.resume()
    }
    
    fileprivate func parseJSON(withData data: Data) -> CurrentWeather? {
        let decoder = JSONDecoder()
        do {
            let currentWeatherData = try decoder.decode(CurrentWeatherData.self, from: data)
            guard let currentWeather = CurrentWeather(model: currentWeatherData) else {
                return nil
            }
            return currentWeather
        } catch let error as NSError {
            print(String(describing: error))
        }
        return nil
    }
}
