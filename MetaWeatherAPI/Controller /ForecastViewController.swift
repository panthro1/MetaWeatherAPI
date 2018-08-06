//
//  ForecastViewController.swift
//  MetaWeatherAPI
//
//  Created by john ledesma on 8/5/18.
//  Copyright © 2018 john ledesma. All rights reserved.
//

import UIKit

class ForecastViewController: UIViewController {
    
    var location: Location!
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: CGRect(), collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .gray
        return cv
    }()
    let cellIdentifier = "ForecastCell"
    
    var forecastDetails = [ForecastDetail]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        title = location.getTitle()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ForecastCell.self, forCellWithReuseIdentifier: cellIdentifier)
        
        setupView()
        
        MetaWeatherService.shared.getForecast(worldId: location.getWorldId()) { (success, forecastDetail) in
            if success {
                self.forecastDetails = forecastDetail
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    fileprivate func setupView() {
        let margins = view.safeAreaLayoutGuide
        
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: margins.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: margins.bottomAnchor)
            ])
    }
    
}

extension ForecastViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? ForecastCell {
            let forecastDetail = forecastDetails[indexPath.row]
            cell.configureCell(detail: forecastDetail)
            return cell
        } else {
            return ForecastCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return forecastDetails.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewHeight = collectionView.bounds.size.height
        let collectionViewWidth = collectionView.bounds.size.width
        let cellHeight = collectionViewHeight * 0.2
        return CGSize(width: collectionViewWidth, height: cellHeight)
    }
    
}

