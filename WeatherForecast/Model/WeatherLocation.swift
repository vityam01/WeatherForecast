//
//  WeatherLocation.swift
//  WeatherForecast
//
//  Created by Vitya Mandryk on 01.09.2023.
//

import Foundation

class WeatherLocation: Codable {
    var name: String
    var tempC: String
    var locationTime: String
    var latitude: Double
    var longitude: Double
    
    
    init(name: String, tempC: String, locationTime: String, latitude: Double, longitude: Double) {
        self.name = name
        self.tempC = tempC
        self.locationTime = locationTime
        self.latitude = latitude
        self.longitude = longitude
    }
    
}

