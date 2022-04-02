//
//  Bundle + Decodable.swift
//  WeatherForecast
//
//  Created by Василий Пронин on 11.02.2022.
//

import Foundation

extension Bundle {
    func decode<T: Decodable>(_ type: T.Type, from file: String) -> T? {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Failed to locate \(file) in bundle.")
        }
        
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load \(file) from bundle.")
        }
        
        let decoder = JSONDecoder()
        
        do {
            let loadedData = try decoder.decode(T.self, from: data)
            return loadedData
            
        } catch {
            return nil
        }
        //        } catch DecodingError.keyNotFound(let key, let context) {
        //            fatalError("could not find key \(key) in JSON: \(context.debugDescription)")
        //        } catch DecodingError.valueNotFound(let type, let context) {
        //            fatalError("could not find type \(type) in JSON: \(context.debugDescription)")
        //        } catch DecodingError.typeMismatch(let type, let context) {
        //            fatalError("type mismatch for type \(type) in JSON: \(context.debugDescription)")
        //        } catch DecodingError.dataCorrupted(let context) {
        //            fatalError("data found to be corrupted in JSON: \(context.debugDescription)")
        //        } catch let error as NSError {
        //            fatalError("Error in read(from:ofType:) domain= \(error.domain), description= \(error.localizedDescription)")
        //        }
        //    }
    }
}
