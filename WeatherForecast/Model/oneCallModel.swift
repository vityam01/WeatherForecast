//
//  oneCallModel.swift
//  WeatherForecast
//
//  Created by Vitya Mandryk on 01.09.2023.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// MARK: - Welcome
struct OneCallModel: Codable {
    var lat: Double?
    var lon: Double?
    var timezone: String?
    var timezoneOffset: Int?
    var current: Current?
    var minutely: [Minutely]?
    var alerts: [Alert]?
    
    enum CodingKeys: String, CodingKey {
        case lat
        case lon
        case timezone
        case timezoneOffset = "timezone_offset"
        case current
        case minutely
        case alerts
    }
}

// MARK: - Alert
struct Alert: Codable {
    var senderName: String
    var event: String?
    var start: Int?
    var end: Int?
    var alertDescription: String?
    
    enum CodingKeys: String, CodingKey {
        case senderName = "sender_name"
        case event
        case start
        case end
        case alertDescription = "description"
    }
}

// MARK: - Current
struct Current: Codable {
    var dt: Double?
    var sunrise: Int?
    var sunset: Int?
    var temp: Double?
    var feelsLike: Double?
    var pressure: Int?
    var humidity: Int?
    var dewPoint: Double?
    var uvi: Double?
    var clouds: Int?
    var visibility: Int?
    var windSpeed: Double?
    var windDeg: Int?
    var weather: [Weather]?
    
    enum CodingKeys: String, CodingKey {
        case dt
        case sunrise
        case sunset
        case temp
        case feelsLike = "feels_like"
        case pressure
        case humidity
        case dewPoint = "dew_point"
        case uvi
        case clouds
        case visibility
        case windSpeed = "wind_speed"
        case windDeg = "wind_deg"
        case weather
    }
}

// MARK: - Weather
struct Weather: Codable {
    var id: Int?
    var main: String?
    var weatherDescription: String?
    var icon: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case main
        case weatherDescription = "description"
        case icon
    }
}

// MARK: - Minutely
struct Minutely: Codable {
    var dt: Double?
    var precipitation: Double?
}

