//
//  SearchHistoryManager.swift
//  MetaWeatherAPI
//
//  Created by john ledesma on 8/5/18.
//  Copyright © 2018 john ledesma. All rights reserved.
//

import Foundation

class SearchHistoryManager {
   
    static let shared = SearchHistoryManager()
    
    //Create filePath to get URL
    // Create manager to locate the file we want
    // Returns the shared file manager object for the process. default
    // Returns an array of URLs for the specified common directory in the requested domains.
    // if all fails its nil
    private var filePath: URL? {
        let manager = FileManager.default
        guard let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        return url
    }
    
    let fileName = "History"
    
    //Returns a URL constructed by appending the filePath path component to self.
    func addToSearchHistory(searchItem: SearchHistoryItem) {
        guard let fullPath = filePath?.appendingPathComponent(fileName) else { return }
        
        if var list = NSKeyedUnarchiver.unarchiveObject(withFile: fullPath.path) as? [SearchHistoryItem] {
            list.append(searchItem)
            NSKeyedArchiver.archiveRootObject(list, toFile: fullPath.path)
        } else {
            let list = [searchItem]
            NSKeyedArchiver.archiveRootObject(list, toFile: fullPath.path)
        }
    }
    
    func getSearchHistory() -> [SearchHistoryItem] {
        let searchHistory = [SearchHistoryItem]()
        
        guard let fullPath = filePath?.appendingPathComponent(fileName) else { return searchHistory }
        
        if let list = NSKeyedUnarchiver.unarchiveObject(withFile: fullPath.path) as? [SearchHistoryItem] {
            return list
        }
        
        return searchHistory
    }
    
}
