//
//  ForecastDetail.swift
//  MetaWeatherAPI
//
//  Created by john ledesma on 8/5/18.
//  Copyright © 2018 john ledesma. All rights reserved.
//

import Foundation

class ForecastDetail {
    
    private var _weatherStateName: String!
    private var _weatherStateAbbreviation: String!
    private var _date: String!
    private var _currentTemp: Double!
    private var _minTemp: Double!
    private var _maxTemp: Double!
    
    init(weatherStateName: String, weatherStateAbbreviation: String, date: String, currentTemp: Double, minTemp: Double, maxTemp: Double) {
        _weatherStateName = weatherStateName
        _weatherStateAbbreviation = weatherStateAbbreviation
        _date = date
        _currentTemp = currentTemp
        _minTemp = minTemp
        _maxTemp = maxTemp
    }
    
    func getWeatherStateName() -> String {
        return _weatherStateName
    }
    
    func getWeatherStateAbbreviation() -> String {
        return _weatherStateAbbreviation
    }
    
    func getDate() -> String {
        return _date
    }
    
    func getCurrentTemp() -> Double {
        return _currentTemp
    }
    
    func getMinTemp() -> Double {
        return _minTemp
    }
    
    func getMaxTemp() -> Double {
        return _maxTemp
    }
    
}
