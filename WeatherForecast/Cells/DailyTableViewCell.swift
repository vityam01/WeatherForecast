//
//  DailyTableViewCell.swift
//  WeatherForecast
//
//  Created by Vitya Mandryk on 01.09.2023.
//

import UIKit

class DailyTableViewCell: UITableViewCell {
    
    //MARK: @IBOutlets
    @IBOutlet weak var dateLabelcell: UILabel!
    @IBOutlet weak var imageCell: UIImageView!
    @IBOutlet weak var minTemperatureCell: UILabel!
    @IBOutlet weak var maxTemperatureCell: UILabel!
    
    var appTool = APPHelper()
    
    var dailyWeather: DailyWeather!{
        didSet {
            dateLabelcell.text = dailyWeather.dailyWeekDay
            minTemperatureCell.text =  "\(dailyWeather.dailyMinTemperature) \n" + "min\n"
            maxTemperatureCell.text =  "\(dailyWeather.dailyMaxTemperature) \n" + "max\n"
            imageCell.image = appTool.imageForWeatherCondition(dailyWeather.dailyWeatherDescription)
        }
    }
}


