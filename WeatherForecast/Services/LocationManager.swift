//
//  LocationManager.swift
//  WeatherForecast
//
//  Created by Василий Пронин on 28.07.2022.
//

import CoreLocation

struct Location {
    var cityName: String
    var latitude: CLLocationDegrees?
    var longitude: CLLocationDegrees?
}

class LocationManager: NSObject, CLLocationManagerDelegate {
//
//    enum QueryType {
//        case city(city: String)
//        case coordinates(coordinates: CLLocation)
//    }
    
    static let shared = LocationManager()
    
    let manager = CLLocationManager()
    
    var completion: ((CLLocation) -> Void)?
    
    public func getUserLocation(completion: @escaping ((CLLocation) -> Void)) {
        self.completion = completion
        manager.requestWhenInUseAuthorization()
        manager.delegate = self
        manager.startUpdatingLocation()
    }
    
    
    
    
    
    
    public func getLocations(with forecastData: [ForecastData], completion: @escaping (([Location]?) -> Void)) {
        let geocoder = CLGeocoder()
        
        var coordinates = CLLocation()
        
        forecastData.forEach { forecast in
            let locationCoordinates = CLLocation(latitude: forecast.lat, longitude: forecast.lon)
            coordinates = locationCoordinates
            
            geocoder.reverseGeocodeLocation(coordinates, preferredLocale: .init(identifier: "en")) { placemarks, error in
                guard let placemarks = placemarks, error == nil else {
                    completion([])
                    return
                }
                let models: [Location] = placemarks.compactMap { placemark in
                    var name = ""
                    if let locality = placemark.locality {
                        name += locality
                    }
                    return Location(cityName: name)
                }
                
                completion(models)
            }
        }
    }
    
    
    
    
    
    
    
    public func getLocations(with query: String, completion: @escaping (([Location]?) -> Void)) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(query, in: nil, preferredLocale: .init(identifier: "en")) { placemarks, error in
            guard let placemarks = placemarks, error == nil else {
                completion([])
                return
            }
            
            let models: [Location] = placemarks.compactMap { placemark in
                var name = ""
                
                if let cityName = placemark.locality {
                    name += cityName
                    
                    if let adminArea = placemark.administrativeArea {
                        name += ", \(adminArea)"
                    }
                    
                    if let country = placemark.country {
                        name += ", \(country)"
                    }
                }
                
                let result = Location(
                    cityName: name,
                    latitude: placemark.location?.coordinate.latitude,
                    longitude: placemark.location?.coordinate.longitude
                )
                
                return result
            }
            
            completion(models)
        }
    }
    
    public func getLocationName(with coordinates: CLLocation, completion: @escaping ((Location?) -> Void)) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(coordinates, preferredLocale: .init(identifier: "en")) { placemarks, error in
            guard let placemark = placemarks?.first, error == nil else {
                completion(nil)
                return
            }
            
            guard let locality = placemark.locality else {
                completion(nil)
                return
            }
            
            let location = Location(
                cityName: locality,
                latitude: coordinates.coordinate.latitude,
                longitude: coordinates.coordinate.longitude
            )
            
            completion(location)
        }
    }
    
    public func getLocationCoordinates(with cityName: String, completion: @escaping ((Location?) -> Void)) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(cityName) { placemarks, error in
            guard let placemark = placemarks?.first, error == nil else {
                completion(nil)
                return
            }

            guard let coordinates = placemark.location else {
                completion(nil)
                return
            }
            
            let location = Location(
                cityName: cityName,
                latitude: coordinates.coordinate.latitude,
                longitude: coordinates.coordinate.longitude
            )
            
            completion(location)
        }
    }
    
//    public func resolveLocation(for result: Location, completion: @escaping (CLLocationDegrees) -> Void) {
//        
//    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        completion?(location)
        manager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(String(describing: error))
    }
}
