//
//  HourlyCollectionViewCell.swift
//  WeatherForecast
//
//  Created by Vitya Mandryk on 02.02.2021.
//

import UIKit

class HourlyCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var dayTimeLabel: UILabel!
    
    var hourlyWeather: HourlyWeather!{
        didSet {
            temperatureLabel.text = "\(hourlyWeather.hourlyTemperature)°"
            setImage(weatherCondition: hourlyWeather.hourlyIcon)
            dayTimeLabel.text = hourlyWeather.hour
        }
    }
    
    func setImage(weatherCondition: String) {
        if weatherCondition == "Clear"{
            weatherIcon.image = #imageLiteral(resourceName: "ios11-weather-sunny-icon")
        }
        else if weatherCondition == "Thunderstorm"{
            weatherIcon.image = #imageLiteral(resourceName: "ios11-weather-thunderstorm-icon")
        }
        else if weatherCondition == "Rain"{
            weatherIcon.image = #imageLiteral(resourceName: "ios11-weather-heavy-rain-icon")
        }
        else if weatherCondition == "Drizzle"{
            weatherIcon.image = #imageLiteral(resourceName: "ios11-weather-rain-icon")
        }
        else if weatherCondition == "Clouds"{
            weatherIcon.image = #imageLiteral(resourceName: "ios11-weather-cloudy-icon")
        }
        else if weatherCondition == "Fog"{
            weatherIcon.image = #imageLiteral(resourceName: "ios11-weather-fog-icon")
        }
        else if weatherCondition == "Mist"{
            weatherIcon.image = #imageLiteral(resourceName: "ios11-weather-fog-icon")
        }
        else if weatherCondition == "Snow"{
            weatherIcon.image = #imageLiteral(resourceName: "ios11-weather-snow-icon")
        }
    }
}

