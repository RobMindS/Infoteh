//
//  WebService.swift
//  Infoteh
//
//  Created by admin on 21.07.2022.
//

import Foundation


class WebService {
    
    let api = "https://api.openweathermap.org/data/2.5/weather"
    let apiKey = "c0ff0af889953630efae57dcaaa30aa1"
        
    
    func getCityWeather(lat: String, lon: String, completionHandler: @escaping (CityWeatherModel?) -> Void) {
        let url = URL(string: api + "?lat=" + lat + "&lon=" + lon + "&appid=" + apiKey)!
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            
            do {
                let decoder = JSONDecoder()
                let weatherData = try decoder.decode(CityWeatherModel.self, from: data)
                completionHandler(weatherData)
            } catch {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
}
