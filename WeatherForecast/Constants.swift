//
//  Constants.swift
//  WeatherForecast
//
//  Created by Vitya Mandryk on 01.09.2023.
//

import Foundation
import UIKit


class APPHelper {
    
    let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter
    }()
    
    let hourFormatter: DateFormatter = {
        let hourFormatter = DateFormatter()
        hourFormatter.dateFormat = "HH:mm"
        return hourFormatter
    }()
    
    
    func imageForWeatherCondition(_ condition: String) -> UIImage {
        switch condition {
        case "Clear":
            return #imageLiteral(resourceName: "ios11-weather-sunny-icon")
        case "Thunderstorm":
            return #imageLiteral(resourceName: "ios11-weather-thunderstorm-icon")
        case "Rain":
            return #imageLiteral(resourceName: "ios11-weather-heavy-rain-icon")
        case "Drizzle":
            return #imageLiteral(resourceName: "ios11-weather-rain-icon")
        case "Clouds":
            return #imageLiteral(resourceName: "ios11-weather-cloudy-icon")
        case "Fog":
            return #imageLiteral(resourceName: "ios11-weather-fog-icon")
        case "Mist":
            return #imageLiteral(resourceName: "ios11-weather-fog-icon")
        case "Snow":
            return #imageLiteral(resourceName: "ios11-weather-snow-icon")
        default:
            // Return a default image if the condition doesn't match any case
            return #imageLiteral(resourceName: "default-weather-icon")
        }
    }
    
}
