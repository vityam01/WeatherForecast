//
//  NetworkOpenWeatherManager.swift
//  WeatherForecast
//
//  Created by Elena on 29.01.2021.
//

import Foundation

class NetworkOpenWeatherManager {
    
    private init() { }
    
    static let shared:NetworkOpenWeatherManager = NetworkOpenWeatherManager()
    
    func getWeather2(city: String, lat:Double, lon:Double, result: @escaping ((OneCallModel?) -> ())) {
        
        //    print(city)
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.openweathermap.org"
        urlComponents.path = "/data/2.5/onecall"
        urlComponents.queryItems = [URLQueryItem(name: "lat", value: "\(lat)"),
                                    URLQueryItem(name: "lon", value: "\(lon)"),
                                    URLQueryItem(name: "units", value: "metric"),
                                    URLQueryItem(name: "appid", value: "\(APIKeys.openWeatherKeyLena)")]
        
        guard urlComponents.url != nil else { return }
        //      print(urlComponents.url)
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = "GET"
        
        let task = URLSession(configuration: .default)
        task.dataTask(with: request) { (data, response, error) in
            if error == nil {
                
                let decoder = JSONDecoder()
                var responseModel: OneCallModel?
                if data != nil {
                    do{
                        responseModel = try decoder.decode(OneCallModel.self, from:data!)
                    }
                    catch {
                        print(error)
                    }
                }
                DispatchQueue.main.async {
                    result(responseModel)
                }
                
            } else {
                print(error as Any)
            }
        } .resume()
    }
}
