//
//  MetaWeatherApi.swift
//  MetaWeatherAPI
//
//  Created by john ledesma on 8/5/18.
//  Copyright © 2018 john ledesma. All rights reserved.
//

import Foundation


import Foundation

// Given more time I would create better cases that handle error handling. also using a linter would help with introducing less bugs


class MetaWeatherApi {
    
    // singleton pattern 
    static let shared = MetaWeatherApi()
    
    private  let baseUrl = "https://www.metaweather.com"
    
    // func gets the users location
    // uses lati and long coordinates to get the users location
    // uses a clouser with @escaping to be excuted later
    // create constanst that takes base url and lati and long
    // create a request with the urlString we created if that doesn't work hand over the completion to grab location return that.
    // create a task to get and parse json else grab from coordinates
    func getLocationsFromCoordinates(latitude: Double, longitude: Double, completion: @escaping (_ success: Bool, _ locations: [Location]) -> Void) {
        let urlString = "\(baseUrl)/api/location/search/?lattlong=\(latitude),\(longitude)"
        guard let request = URL(string:urlString) else { completion(false, []); return }
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil,
                let json = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers),
                let results = json as? [[String: Any]] else {
                    completion(false, [])
                    return
            }
     // grab locations from our clousure
     // iterate thru the location results
            var locations = [Location]()
            for locationResult in results {
                guard let distance = locationResult["distance"] as? Int,
                    let title = locationResult["title"] as? String,
                    let locationType = locationResult["location_type"] as? String,
                    let worldId = locationResult["woeid"] as? Int,
                    let coordinates = locationResult["latt_long"] as? String else { continue }
       // append the results you want to an Array
                let location = Location(distance: distance, title: title, locationType: locationType, woied: worldId, coordinates: coordinates)
                locations.append(location)
            }
            // complete the clousure
            completion(true, locations)
        }
        // resume with your business
        task.resume()
    }
    
    func getLocationsFromSearch(string: String, completion: @escaping (_ success: Bool, _ locations: [Location]) -> Void) {
        let urlString = "\(baseUrl)/api/location/search/?query=\(string)"
        guard let request = URL(string:urlString) else { completion(false, []); return }
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil,
                let json = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers),
                let results = json as? [[String: Any]] else { //error handling
                    completion(false, [])
                    return
            }
            
            var locations = [Location]()
            for locationResult in results {
                print(locationResult)
                guard let title = locationResult["title"] as? String,
                    let locationType = locationResult["location_type"] as? String,
                    let worldId = locationResult["woeid"] as? Int,
                    let coordinates = locationResult["latt_long"] as? String else { continue }
                
                let location = Location(distance: nil, title: title, locationType: locationType, woied: worldId, coordinates: coordinates)
                locations.append(location)
            }
            
            completion(true, locations)
        }
        task.resume()
    }
    
    func getForecast(worldId: Int, completion: @escaping (_ success: Bool, _ forecastDetails: [ForecastDetail]) -> Void) {
        let urlString = "\(baseUrl)/api/location/\(worldId)"
        guard let request = URL(string:urlString) else { completion(false, []); return }
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil,
                let json = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers),
                let results = json as? [String: Any] else { //error handling
                    completion(false, [])
                    return
            }
            
            if let consolidatedWeatherResult = results["consolidated_weather"] as? [[String: Any]] {
                var forcastDetails = [ForecastDetail]()
                for forecastDetailResult in consolidatedWeatherResult {
                    guard let weatherStateName = forecastDetailResult["weather_state_name"] as? String,
                        let weatherStateAbbreviation = forecastDetailResult["weather_state_abbr"] as? String,
                        let date = forecastDetailResult["applicable_date"] as? String,
                        let currentTemp = forecastDetailResult["the_temp"] as? Double,
                        let minTemp = forecastDetailResult["min_temp"] as? Double,
                        let maxTemp = forecastDetailResult["max_temp"] as? Double else { continue }
                    
                    let forecastDetail = ForecastDetail(weatherStateName: weatherStateName, weatherStateAbbreviation: weatherStateAbbreviation, date: date, currentTemp: currentTemp, minTemp: minTemp, maxTemp: maxTemp)
                    forcastDetails.append(forecastDetail)
                }
                
                completion(true, forcastDetails)
                
            } else {
                completion(false, [])
            }
        }
        task.resume()
    }
    
    
}
