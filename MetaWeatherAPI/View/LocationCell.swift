//
//  LocationCell.swift
//  MetaWeatherAPI
//
//  Created by john ledesma on 8/5/18.
//  Copyright © 2018 john ledesma. All rights reserved.
//

import UIKit

class LocationCell: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        textLabel?.text?.removeAll()
        detailTextLabel?.text?.removeAll()
    }
    
    func configureCell(with location: Location) {
        textLabel?.text = location.getTitle()
        detailTextLabel?.text = "\(location.getLocationType()) \(location.getWorldId())"
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

extension UITableViewCell {
    
    static var cellIdentifier: String {
        return String(describing: self)
    }
    
}
