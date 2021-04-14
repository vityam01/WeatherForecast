//
//  DailyTableViewCell.swift
//  WeatherForecast
//
//  Created by Vitya Mandryk on 01.02.2021.
//

import UIKit

class DailyTableViewCell: UITableViewCell {
    
    @IBOutlet weak var dateLabelcell: UILabel!
    @IBOutlet weak var imageCell: UIImageView!
    @IBOutlet weak var minTemperatureCell: UILabel!
    @IBOutlet weak var maxTemperatureCell: UILabel!
    
    var dailyWeather: DailyWeather!{
        didSet {
            dateLabelcell.text = dailyWeather.dailyWeekDay
            minTemperatureCell.text = String(dailyWeather.dailyMinTemperature)
            maxTemperatureCell.text = String(dailyWeather.dailyMaxTemperature)
            setImage(weatherCondition: dailyWeather.dailyWeatherDescription)
        }
    }
    func setImage(weatherCondition: String) {
        if weatherCondition == "Clear"{
            imageCell.image = #imageLiteral(resourceName: "ios11-weather-sunny-icon")
        }
        else if weatherCondition == "Thunderstorm"{
            imageCell.image = #imageLiteral(resourceName: "ios11-weather-thunderstorm-icon")
        }
        else if weatherCondition == "Rain"{
            imageCell.image = #imageLiteral(resourceName: "ios11-weather-heavy-rain-icon")
        }
        else if weatherCondition == "Drizzle"{
            imageCell.image = #imageLiteral(resourceName: "ios11-weather-rain-icon")
        }
        else if weatherCondition == "Clouds"{
            imageCell.image = #imageLiteral(resourceName: "ios11-weather-cloudy-icon")
        }
        else if weatherCondition == "Fog"{
            imageCell.image = #imageLiteral(resourceName: "ios11-weather-fog-icon")
        }
        else if weatherCondition == "Mist"{
            imageCell.image = #imageLiteral(resourceName: "ios11-weather-fog-icon")
        }
        else if weatherCondition == "Snow"{
            imageCell.image = #imageLiteral(resourceName: "ios11-weather-snow-icon")
        }
    }
    
}


