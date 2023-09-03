//
//  CitySelectionTableViewCell.swift
//  WeatherForecast
//
//  Created by Vitya Mandryk on 01.09.2023.
//

import UIKit

class CitySelectionTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var tempCLabel: UILabel!
    @IBOutlet private weak var localTimeLabel: UILabel!
    @IBOutlet private weak var cityNameLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(cityName: String, localTime: String, tempC: String) {
        self.cityNameLabel.text = cityName
        self.localTimeLabel.text = localTime
        self.tempCLabel.text = tempC
    }
}
