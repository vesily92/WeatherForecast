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
        case oneCall(latitude: CLLocationDegrees, longitude: CLLocationDegrees, exclude: [Exclude])
    }
    
    enum Exclude: String {
        case current = "current"
        case minutely = "minutely"
        case hourly = "hourly"
        case daily = "daily"
        case alerts = "alerts"
    }
    
    static let shared = NetworkManager()
    
    var onCompletion: ((CurrentWeather) -> Void)?
    
    private init() {}
    
    func fetchWeather(forRequest request: RequestType) {
        var urlString = ""
        
        switch request {
        case .cityName(let city):
            urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(apiKey)&units=metric"
        case .coordinates(let latitude, let longitude):
            urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)&units=metric"
        case .oneCall(latitude: let latitude, longitude: let longitude, exclude: let exclude):
            urlString = "https://api.openweathermap.org/data/2.5/onecall?lat=\(latitude)&lon=\(longitude)&exclude=\(exclude)&appid=\(apiKey)&units=metric"
        }
        
        performRequest(withURLString: urlString)
    }
    
    fileprivate func performRequest(withURLString urlString: String) {
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                print(error?.localizedDescription ?? "No error description")
                return
            }
            
            if let currentWeather = self.parseJSON(withData: data) {
                self.onCompletion?(currentWeather)
            }

        }.resume()
    }
    
    fileprivate func parseJSON(withData data: Data) -> CurrentWeather? {
        do {
            let currentWeatherData = try JSONDecoder().decode(CurrentWeatherData.self, from: data)
            guard let currentWeather = CurrentWeather(currentWeatherData: currentWeatherData) else {
                return nil
            }
            return currentWeather
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        return nil
    }
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
