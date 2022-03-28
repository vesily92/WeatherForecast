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
    
    enum SectionType {

        case current
        case hourly
        case daily
    }
 
    static let shared = NetworkManager()

    private init() {}
    
    func fetchData(_ sectionType: SectionType, with completion: @escaping (AnyHashable) -> Void) {
        let urlString = "https://api.openweathermap.org/data/2.5/onecall?lat=59.9311&lon=30.3609&exclude=minutely&appid=\(apiKey)&units=metric"
        guard let url = URL(string: urlString) else {
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                print(error?.localizedDescription ?? "No error description")
                return
            }
            
            do {
                let data = try JSONDecoder().decode(ForecastData.self, from: data)
                switch sectionType {
                case .current:
                    DispatchQueue.main.async {
                        completion(data.current)
                    }
                case .hourly:
                    DispatchQueue.main.async {
                        completion(data.hourly)
                    }
                case .daily:
                    DispatchQueue.main.async {
                        completion(data.daily)
                    }
                }
            } catch let error {
                print(error)
            }
        }.resume()
    }

    func fetchCurrentData(with completion: @escaping (Current) -> Void) {
        let urlString = "https://api.openweathermap.org/data/2.5/onecall?lat=59.9311&lon=30.3609&exclude=minutely&appid=\(apiKey)&units=metric"
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
                    completion(forecastData.current)
                }
            } catch let error {
                print(error)
            }
        }.resume()
    }
    
    func fetchHourlyData(with completion: @escaping ([Hourly]) -> Void) {
        let urlString = "https://api.openweathermap.org/data/2.5/onecall?lat=59.9311&lon=30.3609&exclude=minutely&appid=\(apiKey)&units=metric"
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
                    completion(forecastData.hourly)
                }
            } catch let error {
                print(error)
            }
        }.resume()
    }
    
    func fetchDailyData(with completion: @escaping ([Daily]) -> Void) {
        let urlString = "https://api.openweathermap.org/data/2.5/onecall?lat=59.9311&lon=30.3609&exclude=minutely&appid=\(apiKey)&units=metric"
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
                    completion(forecastData.daily)
                }
            } catch let error {
                print(error)
            }
        }.resume()
    }
}
