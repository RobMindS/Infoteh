//
//  JsonService.swift
//  Infoteh
//
//  Created by admin on 19.07.2022.
//

import Foundation

class JsonService {
    
    func loadJson(path: String, completionHandler: @escaping ([СityModel]?) -> Void) {
        
        guard let path = Bundle.main.path(forResource: "city_list", ofType: "json") else { return }
        let url = URL(fileURLWithPath: path)
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let cityList = try decoder.decode([СityModel].self, from: data)
            completionHandler(cityList)
        } catch {
            print("error: \(error)")
        }
    }
}
