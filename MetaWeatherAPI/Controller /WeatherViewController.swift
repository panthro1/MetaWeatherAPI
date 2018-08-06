//
//  ViewController.swift
//  MetaWeatherAPI
//
//  Created by john ledesma on 8/5/18.
//  Copyright © 2018 john ledesma. All rights reserved.
//

import UIKit
import CoreLocation



class WeatherViewController: UIViewController {
    
    let searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.translatesAutoresizingMaskIntoConstraints = false
        sb.placeholder = "Search"
        sb.barStyle = .blackOpaque
        sb.searchBarStyle = .minimal
        sb.returnKeyType = .search
        return sb
    }()
    
    var showSearchHistory = false
    var searchHistory = [SearchHistoryItem]()
    
    fileprivate func searchBarIsEmpty() -> Bool {
        return searchBar.text?.isEmpty ?? true
    }
    
    let tableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    let cellIdentifier = "LocationCell"
    
    var gpsLocations = [Location]()
    var searchLocations = [Location]()
    
    var gpsCoordinate: (latt: Double, long: Double)? {
        didSet {
            getLocationsFromCoordinates()
        }
    }
    
    fileprivate func getLocationsFromCoordinates() {
        guard let latt = gpsCoordinate?.latt, let long = gpsCoordinate?.long else { return }
        MetaWeatherService.shared.getLocationsFromCoordinates(latt: latt, long: long) { (success, locations) in
            if success {
                self.gpsLocations = locations
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "MetaWeather Challenge"
        
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(LocationCell.self, forCellReuseIdentifier: cellIdentifier)
        
        searchBar.delegate = self
        
        setupView()
        
        refreshSearchHistory()
    }
    
    fileprivate func refreshSearchHistory() {
        searchHistory = SearchHistoryManager.shared.getSearchHistory()
    }
    
    fileprivate func setupView() {
        let margins = view.safeAreaLayoutGuide
        
        view.addSubview(searchBar)
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: margins.topAnchor, constant: 5),
            searchBar.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: 35)
            ])
        
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 5),
            tableView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: margins.bottomAnchor)
            ])
        
    }
    
    fileprivate func getLocationsFromSearch(searchString: String) {
        MetaWeatherService.shared.getLocationsFromSearch(string: searchString) { (success, locations) in
            if success {
                self.searchLocations = locations
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
}

extension WeatherViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        showSearchHistory = true
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        showSearchHistory = false
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchString = searchBar.text else { return }
        showSearchHistory = false
        
        let formatter = DateFormatter() //get date string
        formatter.dateFormat = "MM/dd/yyyy HH:mm"
        let date = formatter.string(from: Date())
        
        let searchitem = SearchHistoryItem(searchString: searchString, date: date)
        SearchHistoryManager.shared.addToSearchHistory(searchItem: searchitem)
        
        refreshSearchHistory()
        
        getLocationsFromSearch(searchString: searchString)
    }
    
}

extension WeatherViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        if gpsCoordinate?.latt != locValue.latitude || gpsCoordinate?.long != locValue.longitude { //different coordinate
            let coordinate = (latt: locValue.latitude, long: locValue.longitude)
            gpsCoordinate = coordinate
        }
    }
    
}

extension WeatherViewController: UITableViewDelegate, UITableViewDataSource {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        view.endEditing(true) //dismiss keyboard
        showSearchHistory = false
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if showSearchHistory {
            return searchHistory.count
        }
        return searchBarIsEmpty() ? gpsLocations.count : searchLocations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if showSearchHistory { //shortcut to show search history. If I had more time I would implement as I did with gps entries.
            let searchItem = searchHistory[indexPath.row]
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "SearchHistory")
            cell.textLabel?.text = searchItem.getSearchString()
            cell.detailTextLabel?.text = searchItem.getDate()
            return cell
        }
        
        let location = searchBarIsEmpty() ? gpsLocations[indexPath.row] : searchLocations[indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? LocationCell {
            cell.configureCell(location: location)
            return cell
        } else {
            return LocationCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if showSearchHistory {
            let searchHistoryItem = searchHistory[indexPath.row]
            showSearchHistory = false
            getLocationsFromSearch(searchString: searchHistoryItem.getSearchString())
            return
        }
        
        let location = searchBarIsEmpty() ? gpsLocations[indexPath.row] : searchLocations[indexPath.row]
        print(location.getWorldId())
        let vc = ForecastViewController()
        vc.location = location
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

