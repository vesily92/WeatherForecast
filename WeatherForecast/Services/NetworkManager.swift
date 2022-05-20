//
//  NetworkManager.swift
//  WeatherForecast
//
//  Created by Василий Пронин on 07.02.2022.
//

import Foundation
import CoreLocation

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
}

class NetworkManager {
    
    enum RequestType {
        case cityName(city: String)
        case coordinates(latitude: CLLocationDegrees, longitude: CLLocationDegrees)
    }
    
//    enum RequestType {
//        case oneCall
//        case currentWeather(CurrentWeather)
//
//        enum CurrentWeather {
//            case cityName(city: String)
//            case coordinates(latitude: CLLocationDegrees, longitude: CLLocationDegrees)
//        }
//    }
 
    static let shared = NetworkManager()
    
    var onCompletion: ((CurrentWeather) -> Void)?
    
    private init() {}
    
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
        
//        print(String(data: data, encoding: .utf8)!)
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
    
    func fetchOneCallData(withLatitude latitude: CLLocationDegrees, longitude: CLLocationDegrees, andCompletion completion: @escaping (ForecastData) -> Void) {
        let urlString = "https://api.openweathermap.org/data/2.5/onecall?lat=\(latitude)&lon=\(longitude)&exclude=minutely&appid=\(apiKey)&units=metric"
        
        guard let url = URL(string: urlString) else { return }
        
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { data, response, error in
            guard let data = data else {
                print(error?.localizedDescription ?? "No error description")
                return
            }
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
    
    
    func fetchForecastData(with completion: @escaping (ForecastData) -> Void) {
        let urlString = "https://api.openweathermap.org/data/2.5/onecall?lat=59.8944&lon=30.2642&exclude=minutely&appid=\(apiKey)&units=metric"
        guard let url = URL(string: urlString) else {
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                print(error?.localizedDescription ?? "No error description")
                return
            }
//            print("-------------------data: \(data)")
//            print(String(data: data, encoding: .utf8)!)
            do {
                let forecastData = try JSONDecoder().decode(ForecastData.self, from: data)
//                guard let forecast = ForecastData.CurrentData(model: forecastData) else { return }
//                print("forecast data: \(forecast)")
                DispatchQueue.main.async {
                    completion(forecastData)
                }
            } catch let error {
                print(error)
            }
        }.resume()
    }
    
//    func fetchHourly(with completion: @escaping ([HourlySectionWeather]) -> Void) {
//        let urlString = "https://api.openweathermap.org/data/2.5/onecall?lat=59.9311&lon=30.3609&exclude=minutely&appid=\(apiKey)&units=metric"
//        guard let url = URL(string: urlString) else {
//            return
//        }
//
//        URLSession.shared.dataTask(with: url) { data, response, error in
//            guard let data = data else {
//                print(error?.localizedDescription ?? "No error description")
//                return
//            }
//
//            do {
//                let forecastData = try JSONDecoder().decode(ForecastData.self, from: data)
//                guard let hourly = HourlySectionWeather(model: forecastData) else { return }
//
//                DispatchQueue.main.async {
//                    completion([hourly])
//                }
//            } catch let error {
//                print(error)
//            }
//        }.resume()
//    }

//    func fetchCurrentData(with completion: @escaping (Current) -> Void) {
//        let urlString = "https://api.openweathermap.org/data/2.5/onecall?lat=59.9311&lon=30.3609&exclude=minutely&appid=\(apiKey)&units=metric"
//        guard let url = URL(string: urlString) else {
//            return
//        }
//        URLSession.shared.dataTask(with: url) { data, response, error in
//            guard let data = data else {
//                print(error?.localizedDescription ?? "No error description")
//                return
//            }
////            print("-------------------data: \(data)")
////            print(String(data: data, encoding: .utf8)!)
//            do {
//                let forecastData = try JSONDecoder().decode(ForecastData.self, from: data)
////                guard let forecast = ForecastData.CurrentData(model: forecastData) else { return }
////                print("forecast data: \(forecast)")
//                DispatchQueue.main.async {
//                    completion(forecastData.current)
//                }
//            } catch let error {
//                print(error)
//            }
//        }.resume()
//    }
}
