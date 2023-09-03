//
//  WeatherService.swift
//  WeatherForecast
//
//  Created by Vitya Mandryk on 01.09.2023.
//

import Foundation

class WeatherService: WeatherLocation {
    
    struct Result: Codable {
        var timezone: String
        var current: Current
        var daily: [Daily]
        var hourly: [Hourly]
    }
    
    struct Current: Codable {
        var dt: TimeInterval
        var temp: Double
        var weather: [Weather]
    }
    
    struct Weather: Codable {
        var main: String
    }
    struct Hourly: Codable {
        var dt: TimeInterval
        var temp: Double
        var weather: [Weather]
    }
    struct Daily: Codable {
        var dt: TimeInterval
        var temp: Temp
        var weather: [Weather]
    }
    
    struct Temp: Codable {
        var max: Double
        var min: Double
    }
    enum ServiceServerError: Error {
        case request
        case error(Error)
    }
    var timezone = ""
    var currentTime = 0.0
    var temperature = 0
    var description = ""
    var locationName = ""
    var dailyWeatherData: [DailyWeather] = []
    var hourlyWeatherData: [HourlyWeather] = []
    let appHelper = APPHelper()
    
    func getData(completed: @escaping (Swift.Result<Result,Error>) -> ()) {
        let urlString = "https://api.openweathermap.org/data/2.5/onecall?lat=\(latitude)&lon=\(longitude)&exclude=minutely&units=metric&appid=\(APIKeys.openWeatherKey)"
        //Create URL
        guard let url = URL(string: urlString) else {
            print("ERROR: could not create a url from \(urlString)")
            completed(.failure(ServiceServerError.request))
            return
        }
        
        
        //Create URL Session
        let session = URLSession.shared
        
        //Get data with .dataTas method
        let task = session.dataTask(with: url) { [weak self] (data, response, error) in
            guard let self = self else {
                // self is nil, which means this instance has been deallocated
                return
            }

            if let error = error {
                print("ERROR: \(error.localizedDescription)")
                completed(.failure(ServiceServerError.error(error)))
                return
            }
            //Deal with Data
            do {
                let result = try JSONDecoder().decode(Result.self, from: data!)
                self.timezone = result.timezone
                self.currentTime = result.current.dt
                self.locationName = result.timezone.description
                self.temperature = Int(result.current.temp.rounded())
                self.description = result.current.weather[0].main
                //MARK: func for daily weather
                for index in 0..<result.daily.count {
                    let weekdayDay = Date(timeIntervalSince1970: result.daily[index].dt)
                    self.appHelper.dateFormatter.timeZone = TimeZone(identifier: result.timezone)
                    let dailyWeekday = self.appHelper.dateFormatter.string(from: weekdayDay)
                    let dailyDescription = result.daily[index].weather[0].main
                    let dailyMax = Int(result.daily[index].temp.max.rounded())
                    let dailyMin = Int(result.daily[index].temp.min.rounded())
                    var dailyWeather = DailyWeather(dailyWeekDay: dailyWeekday, dailyWeatherDescription: dailyDescription, dailyMaxTemperature: dailyMax, dailyMinTemperature: dailyMin)
                    dailyWeather.dailyWeatherState = DailyWeather.DailyWeatherState(rawValue: dailyDescription)
                    self.dailyWeatherData.append(dailyWeather)
                }
                //MARK: func for hourly weather
                let lastHour = min(24, result.hourly.count)
                if lastHour > 0 {
                    for index in 1...lastHour {
                        let hourlyDate = Date(timeIntervalSince1970: result.hourly[index].dt)
                        self.appHelper.hourFormatter.timeZone = TimeZone(identifier: result.timezone)
                        let hour = self.appHelper.hourFormatter.string(from: hourlyDate)
                        let hourlyIcon = result.hourly[index].weather[0].main
                        let hourlyTemperature = Int(result.hourly[index].temp.rounded())
                        let hourlyWeather = HourlyWeather(hour: hour, hourlyIcon: hourlyIcon, hourlyTemperature: hourlyTemperature)
                        self.hourlyWeatherData.append(hourlyWeather)
                    }
                }
                print ("***\(self.timezone)")
                completed(.success(result))
            } catch {
                print("JSON ERROR \(error.localizedDescription)")
                completed(.failure(error))
            }
        }
        task.resume()

    }
}
