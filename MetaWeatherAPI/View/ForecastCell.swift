//
//  ForecastCell.swift
//  MetaWeatherAPI
//
//  Created by john ledesma on 8/5/18.
//  Copyright © 2018 john ledesma. All rights reserved.
//

import UIKit

class ForecastCell: UICollectionViewCell {
    
    let dayLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.adjustsFontSizeToFitWidth = true
        return lbl
    }()
    
    let weatherImage: UIImageView = { //not enough time to get image
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        return iv
    }()
    
    let weatherStateLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.adjustsFontSizeToFitWidth = true
        return lbl
    }()
    
    let currentTempLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textAlignment = .center
        lbl.adjustsFontSizeToFitWidth = true
        return lbl
    }()
    
    let minTempLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.adjustsFontSizeToFitWidth = true
        return lbl
    }()
    
    let maxTempLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.adjustsFontSizeToFitWidth = true
        return lbl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    func configureCell(detail: ForecastDetail) {
        dayLabel.text = detail.getDate()
        weatherStateLabel.text = detail.getWeatherStateName()
        currentTempLabel.text = "Current: \(detail.getCurrentTemp())\u{00B0} C"
        minTempLabel.text = "Max: \(detail.getMinTemp())\u{00B0} C"
        maxTempLabel.text = "Min: \(detail.getMaxTemp())\u{00B0} C"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupView() {
        let margins = contentView.layoutMarginsGuide
        
        backgroundColor = .white
        
        let weatherStateStackView = UIStackView(arrangedSubviews: [dayLabel, weatherImage, weatherStateLabel])
        weatherStateStackView.translatesAutoresizingMaskIntoConstraints = false
        weatherStateStackView.axis = .vertical
        weatherStateStackView.spacing = 3
        weatherStateStackView.distribution = .fillProportionally
        
        let tempRangeStackView = UIStackView(arrangedSubviews: [maxTempLabel, minTempLabel])
        tempRangeStackView.translatesAutoresizingMaskIntoConstraints = false
        tempRangeStackView.axis = .horizontal
        tempRangeStackView.spacing = 3
        tempRangeStackView.distribution = .fillEqually
        
        let tempDetailStackView = UIStackView(arrangedSubviews: [currentTempLabel, tempRangeStackView])
        tempDetailStackView.translatesAutoresizingMaskIntoConstraints = false
        tempDetailStackView.axis = .vertical
        tempDetailStackView.spacing = 3
        tempDetailStackView.distribution = .fillProportionally
        
        let mainStackView = UIStackView(arrangedSubviews: [weatherStateStackView, tempDetailStackView])
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.axis = .horizontal
        mainStackView.spacing = 3
        mainStackView.distribution = .fillEqually
        
        contentView.addSubview(mainStackView)
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: margins.topAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: margins.bottomAnchor)
            ])
        
    }
    
}
