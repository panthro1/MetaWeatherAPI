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

// MARK: - Properties
    
    let searchController: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.placeholder = "Search"
        searchBar.barStyle = .default
        searchBar.searchBarStyle = .default
        searchBar.returnKeyType = .search
        return searchBar
    }()
    
    let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    var showSearchHistory = false
    var searchHistory = [SearchHistoryItem]()
    
    let locationManager = CLLocationManager()
    
    var geoLocations = [Location]()
    var searchLocations = [Location]()
    
    var gpsCoordinate: (latt: Double, long: Double)? {
        didSet {
            getLocationsFromCoordinates()
        }
    }
    
// MARK: - WeatherViewController lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        configureLocationManager()
        setupTableView()
        setupView()
        refreshSearchHistory()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
// MARK: - WeatherViewController setup methods
    
    private func setupNavBar() {
        navigationItem.title = "Weather"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]
        navigationController?.navigationBar.barTintColor = UIColor.cyan
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.delegate = self
    }
    
    private func configureLocationManager() {
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(LocationCell.self, forCellReuseIdentifier: LocationCell.cellIdentifier)
    }
    
    fileprivate func setupView() {
        let margins = view.safeAreaLayoutGuide

        view.addSubview(searchController)
        NSLayoutConstraint.activate([
            searchController.topAnchor.constraint(equalTo: margins.topAnchor, constant: 5),
            searchController.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            searchController.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            searchController.heightAnchor.constraint(equalToConstant: 35)
            ])
        
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: searchController.bottomAnchor, constant: 5),
            tableView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: margins.bottomAnchor)
            ])
        
    }

}

// Mark: searchController methods

extension WeatherViewController: UISearchBarDelegate {
    
    fileprivate func searchBarIsEmpty() -> Bool {
        return searchController.text?.isEmpty ?? true
    }
    
    fileprivate func refreshSearchHistory() {
        searchHistory = SearchHistoryManager.shared.getSearchHistory()
    }
    
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
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        let date = formatter.string(from: Date())
        
        let searchitem = SearchHistoryItem(searchString: searchString, date: date)
        SearchHistoryManager.shared.addToSearchHistory(searchItem: searchitem)
        
        refreshSearchHistory()
        
        getLocationsFromSearch(searchString: searchString)
    }
    
}

 // MARK: - locationManager methods

extension WeatherViewController: CLLocationManagerDelegate {
    
    fileprivate func getLocationsFromCoordinates() {
        guard let latt = gpsCoordinate?.latt, let long = gpsCoordinate?.long else { return }
        MetaWeatherApi.shared.getLocationsFromCoordinates(latitude: latt, longitude: long) { (success, locations) in
            if success {
                self.geoLocations = locations
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    fileprivate func getLocationsFromSearch(searchString: String) {
        MetaWeatherApi.shared.getLocationsFromSearch(string: searchString) { (success, locations) in
            if success {
                self.searchLocations = locations
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let LocationValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        if gpsCoordinate?.latt != LocationValue.latitude || gpsCoordinate?.long != LocationValue.longitude { //different coordinate
            let coordinate = (latt: LocationValue.latitude, long: LocationValue.longitude)
            gpsCoordinate = coordinate
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse:
            manager.startUpdatingLocation()
        case .authorizedAlways:
            manager.startUpdatingLocation()
        case .restricted, .denied:
            let alert = UIAlertController(title: "Location Services Disabled", message: "Please enable Location Services in Settings", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            
            present(alert, animated: true, completion: nil)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error)")
    }
    
}

// MARK: - WeatherViewController UITableViewDelegate & UITableViewDataSource

extension WeatherViewController: UITableViewDelegate, UITableViewDataSource {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        view.endEditing(true) //dismiss keyboard
        showSearchHistory = false
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if showSearchHistory {
            return searchHistory.count
        }
        return searchBarIsEmpty() ? geoLocations.count : searchLocations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if showSearchHistory { //shortcut to show search history. If I had more time I would implement as I did with gps entries.
            let searchItem = searchHistory[indexPath.row]
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "SearchHistory")
            cell.textLabel?.text = searchItem.getSearchString()
            cell.detailTextLabel?.text = searchItem.getDate()
            return cell
        }
        
        let location = searchBarIsEmpty() ? geoLocations[indexPath.row] : searchLocations[indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: LocationCell.cellIdentifier, for: indexPath) as? LocationCell {
            cell.configureCell(with: location)
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
        
        let location = searchBarIsEmpty() ? geoLocations[indexPath.row] : searchLocations[indexPath.row]
        let vc = ForecastViewController()
        vc.location = location
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

