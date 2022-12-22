//
//  LocationManager.swift
//  WeatherForecast
//
//  Created by Василий Пронин on 28.07.2022.
//

import CoreLocation

struct Location: Hashable {
    var cityName: String?
    var latitude: CLLocationDegrees?
    var longitude: CLLocationDegrees?
}

class LocationManager: NSObject, CLLocationManagerDelegate {
    
    static let shared = LocationManager()
    
    let manager = CLLocationManager()
    var completion: ((Double, Double) -> Void)?
    
    private override init() {}
    
    func getUserLocation(completion: @escaping ((Double, Double) -> Void)) {
        self.completion = completion
        manager.requestWhenInUseAuthorization()
        manager.delegate = self
        manager.startUpdatingLocation()
    }
    
//    func getLocations(from forecastData: [ForecastData], completion: @escaping (([Location]?) -> Void)) {
//        var locations: [Location] = []
//        var data = forecastData
//        data.removeFirst()
//        data.forEach { forecast in
//            let location = Location(
//                latitude: forecast.lat,
//                longitude: forecast.lon
//            )
//            locations.append(location)
//        }
//        completion(locations)
//    }

//    func getLocations(with query: String, completion: @escaping (([Location]?) -> Void)) {
//        let geocoder = CLGeocoder()
//        geocoder.geocodeAddressString(query, in: nil, preferredLocale: .init(identifier: "en")) { placemarks, error in
//            guard let placemarks = placemarks, error == nil else {
//                completion([])
//                return
//            }
//
//            let models: [Location] = placemarks.compactMap { placemark in
//                var name = ""
//
//                if let cityName = placemark.locality {
//                    name += cityName
//
//                    if let adminArea = placemark.administrativeArea {
//                        name += ", \(adminArea)"
//                    }
//
//                    if let country = placemark.country {
//                        name += ", \(country)"
//                    }
//                }
//
//                let result = Location(
//                    cityName: name,
//                    latitude: placemark.location?.coordinate.latitude,
//                    longitude: placemark.location?.coordinate.longitude
//                )
//
//                return result
//            }
//
//            completion(models)
//        }
//    }
    
//    func getLocationName(with coordinates: CLLocation, completion: @escaping ((Location?) -> Void)) {
//        let geocoder = CLGeocoder()
//        geocoder.reverseGeocodeLocation(coordinates, preferredLocale: .init(identifier: "en")) { placemarks, error in
//            guard let placemark = placemarks?.first, error == nil else {
//                completion(nil)
//                return
//            }
//            
//            guard let locality = placemark.locality else {
//                completion(nil)
//                return
//            }
//            
//            let location = Location(
//                cityName: locality,
//                latitude: coordinates.coordinate.latitude,
//                longitude: coordinates.coordinate.longitude
//            )
//            
//            completion(location)
//        }
//    }
    
    func getLocationName(withLat latitude: Double, andLon longitude: Double, completion: @escaping ((Location?) -> Void)) {
        let geocoder = CLGeocoder()
        let coordinates = CLLocation(latitude: latitude, longitude: longitude)
        
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
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        completion?(latitude, longitude)
        manager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(String(describing: error))
    }
}
