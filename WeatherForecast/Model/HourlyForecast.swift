//
//  HourlyForecast.swift
//  WeatherForecast
//
//  Created by Vitya Mandryk on 01.09.2023.
//

import Foundation


struct HourlyWeather: Codable {
    var hour: String
    var hourlyIcon: String
    var hourlyTemperature: Int
    
    enum HourlyWeathersState: String, Codable {
        case clear = "Clear"
        case rain = "Rain"
        case thunderstorm = "Thunderstorm"
        case drizzle = "Drizzle"
        case fog = "Fog"
        case mist = "Mist"
        case snow = "Snow"
        case clouds = "Clouds"
    }
}
