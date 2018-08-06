//
//  Location.swift
//  MetaWeatherAPI
//
//  Created by john ledesma on 8/5/18.
//  Copyright © 2018 john ledesma. All rights reserved.
//

import Foundation

class Location {
    
    private var _distance: Int?
    private var _title: String!
    private var _locationType: String!
    private var _woied: Int!
    private var _coordinates: String!
    
    init(distance: Int?, title: String, locationType: String, woied: Int, coordinates: String) {
        _distance = distance
        _title = title
        _locationType = locationType
        _woied = woied
        _coordinates = coordinates
    }
    
    func getDistance() -> Int? {
        return _distance
    }
    
    func getTitle() -> String {
        return _title
    }
    
    func getLocationType() -> String {
        return _locationType
    }
    
    func getWorldId() -> Int {
        return _woied
    }
    
    func getCoordinates() -> String {
        return _coordinates
    }
    
}
