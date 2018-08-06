//
//  SearchHistoryItem.swift
//  MetaWeatherAPI
//
//  Created by john ledesma on 8/5/18.
//  Copyright © 2018 john ledesma. All rights reserved.
//

import Foundation

class SearchHistoryItem: NSObject, NSCoding {
    
    private var _searchString: String
    private var _date: String
    
    struct Keys {
        static let searchString = "searchString"
        static let date = "date"
    }
    
    init(searchString: String, date: String) {
        _searchString = searchString
        _date = date
    }
    
    func getSearchString() -> String {
        return _searchString
    }
    
    func getDate() -> String {
        return _date
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let searchString = aDecoder.decodeObject(forKey: Keys.searchString) as? String,
            let date = aDecoder.decodeObject(forKey: Keys.date) as? String else { return nil }
        
        self.init(searchString: searchString, date: date)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(_searchString, forKey: Keys.searchString)
        aCoder.encode(_date, forKey: Keys.date)
    }
    
}
