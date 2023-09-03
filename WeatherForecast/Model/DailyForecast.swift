//
//  ForecastSetup.swift
//  WeatherForecast
//
//  Created by Vitya Mandryk on 01.09.2023.
//
import Foundation


struct  DailyWeather: Codable {
    var dailyWeekDay: String
    var dailyWeatherDescription: String
    var dailyWeatherState: DailyWeatherState?
    var dailyMaxTemperature: Int
    var dailyMinTemperature: Int
    
    enum DailyWeatherState: String, Codable {
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









