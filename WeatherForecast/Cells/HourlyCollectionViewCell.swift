//
//  HourlyCollectionViewCell.swift
//  WeatherForecast
//
//  Created by Vitya Mandryk on 01.09.2023.
//

import UIKit

class HourlyCollectionViewCell: UICollectionViewCell {
    
    //MARK: @IBOutlets
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var dayTimeLabel: UILabel!
    
    var appTool = APPHelper()
    
    var hourlyWeather: HourlyWeather! {
            didSet {
                temperatureLabel.text = "\(hourlyWeather.hourlyTemperature)°"
                weatherIcon.image = appTool.imageForWeatherCondition(hourlyWeather.hourlyIcon)
                dayTimeLabel.text = hourlyWeather.hour
            }
        }
    

}

