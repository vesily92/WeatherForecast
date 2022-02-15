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
    
//    enum RequestType {
//        case cityName(city: String)
//        case coordinates(latitude: CLLocationDegrees, longitude: CLLocationDegrees)
////        case oneCall(latitude: CLLocationDegrees, longitude: CLLocationDegrees, exclude: [Exclude])
//    }
    
    
    static let shared = NetworkManager()
    
    var onCompletion: ((CurrentWeather) -> Void)?
    
    private init() {}
    
//    func fetchCurrentWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
//        let urlString = "https://api.openweathermap.org/data/2.5/onecall?lat=\(latitude)&lon=\(longitude)&exclude=minutely,hourly,daily,alerts&appid=\(apiKey)&units=metric"
//
//        guard let url = URL(string: urlString) else { return }
//
//        URLSession.shared.dataTask(with: url) { data, response, error in
//            guard let data = data else {
//                print(error?.localizedDescription ?? "No error description")
//                return
//            }
//            if let currentWeather = self.parseJSON(withData: data) {
//                self.onCompletion?(currentWeather)
//            }
//
//        }
//    }
//
//    func parseCurrent(withData data: Data) -> CurrentWeather? {
//        do {
//            let currentWeatherData = try JSONDecoder().decode(CurrentWeatherData.self, from: data)
//            guard let currentWeather = CurrentWeather(currentWeatherData: currentWeatherData) else {
//                return nil
//
//            }
//            return currentWeather
//
//        } catch let error as NSError {
//            print(error.localizedDescription)
//        }
//        return nil
//    }
    
    enum RequestType {
        case current
        case hourly
        case daily
    }
    
    func fetchForecast() {
        
    }
    
    func fetchHourly(latitude: CLLocationDegrees, longitude: CLLocationDegrees, completion: @escaping(Result<Daily, NetworkError>) -> Void) {
        let urlString = "https://api.openweathermap.org/data/2.5/onecall?lat=\(latitude)&lon=\(longitude)&exclude=minutely,hourly,daily,alerts&appid=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                completion(.failure(.noData))
                print(error?.localizedDescription ?? "No error description")
                return
            }
            
            do {
                let current = try JSONDecoder().decode(Daily.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(current))
                }
            
            } catch DecodingError.keyNotFound(let key, let context) {
                Swift.print("could not find key \(key) in JSON: \(context.debugDescription)")
            } catch DecodingError.valueNotFound(let type, let context) {
                Swift.print("could not find type \(type) in JSON: \(context.debugDescription)")
            } catch DecodingError.typeMismatch(let type, let context) {
                Swift.print("type mismatch for type \(type) in JSON: \(context.debugDescription)")
            } catch DecodingError.dataCorrupted(let context) {
                Swift.print("data found to be corrupted in JSON: \(context.debugDescription)")
            } catch let error as NSError {
                NSLog("Error in read(from:ofType:) domain= \(error.domain), description= \(error.localizedDescription)")
            }
        }.resume()
    }
    
    
    
    func fetchDaily() {
        
    }
    
//    func fetchForecasts(forForecastType forecastType: ForecastType) {
//        var urlString = ""
//
//        switch forecastType {
//        case .current(let latitude, let longitude, let type):
//            urlString = "https://api.openweathermap.org/data/2.5/onecall?lat=\(latitude)&lon=\(longitude)&exclude=minutely,hourly,daily,alerts&appid=\(apiKey)&units=metric"
//
//
//        case .hourly(let latitude, let longitude, let type):
//            urlString = "https://api.openweathermap.org/data/2.5/onecall?lat=\(latitude)&lon=\(longitude)&exclude=current,minutely,daily,alerts&appid=\(apiKey)&units=metric"
//
//        case .daily(let latitude, let longitude, let type):
//            urlString = "https://api.openweathermap.org/data/2.5/onecall?lat=\(latitude)&lon=\(longitude)&exclude=current,minutely,hourly,alerts&appid=\(apiKey)&units=metric"
//
//        }
//
//    }
    
    
//    func decode<T: Decodable>(_ type: T.Type, from file: String) -> T {
//        guard let url = self.url(forResource: file, withExtension: nil) else {
//            fatalError("Failed to locate \(file) in bundle.")
//        }
//
//        guard let data = try? Data(contentsOf: url) else {
//            fatalError("Failed to load \(file) from bundle.")
//        }
//
//        let decoder = JSONDecoder()
//
//        guard let loaded = try? decoder.decode(T.self, from: data) else {
//            fatalError("Failed to decode \(file) from bundle.")
//        }
//
//        return loaded
//    }
    
    
//    func fetchCurrentWeather(forRequest request: RequestType) {
//        var urlString = ""
//
//        switch request {
//        case .cityName(let city):
//            urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(apiKey)&units=metric"
//        case .coordinates(let latitude, let longitude):
//            urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)&units=metric"
//        }
//
//        performRequest(withURLString: urlString)
//    }
    
    
    
//    fileprivate func performRequest(withURLString urlString: String) {
//        guard let url = URL(string: urlString) else { return }
//
//        URLSession.shared.dataTask(with: url) { data, response, error in
//            guard let data = data else {
//                print(error?.localizedDescription ?? "No error description")
//                return
//            }
//
//            if let currentWeather = self.parseJSON(withData: data) {
//                self.onCompletion?(currentWeather)
//            }
//
//        }.resume()
//    }
//
//    fileprivate func parseJSON(withData data: Data) -> CurrentWeather? {
//        do {
//            let currentWeatherData = try JSONDecoder().decode(CurrentWeatherData.self, from: data)
//            guard let currentWeather = CurrentWeather(currentWeatherData: currentWeatherData) else {
//                return nil
//            }
//            return currentWeather
//
//        } catch let error as NSError {
//            print(error.localizedDescription)
//        }
//        return nil
//    }
    
    
    
    
    
    
    
    
    
    
    
    
    
}

//class ImageManager {
//    static let shared = ImageManager()
//    
//    var onCompletion: ((CurrentWeather) -> Void)?
//    
//    private init() {}
//    
//    func fetchImage(fromURL url: String?, withCode code: CurrentWeather?) -> Data? {
//        guard let imageCode = code else { return nil }
//        let url = "http://openweathermap.org/img/wn/\(imageCode.systemNameString)@2x.png"
//        guard let imageURL = URL(string: url) else { return nil }
//        return try? Data(contentsOf: imageURL)
//    }
//}
