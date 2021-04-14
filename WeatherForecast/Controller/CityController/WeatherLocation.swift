//
//  WeatherLocation.swift
//  WeatherForecast
//
//  Created by Elena on 27.01.2021.
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

