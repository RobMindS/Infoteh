//
//  CityPresenter.swift
//  Infoteh
//
//  Created by admin on 02.08.2022.
//

import Foundation
import UIKit

protocol CityPresenterDelegate: AnyObject {
    func presentCities(cities: [CityModel])
    func openCityDetailVC(city: CityModel)
}

typealias PresenterDelegate = CityPresenterDelegate & UIViewController

class CityPresenter {
    
    weak var delegate: PresenterDelegate?
    
    public func getCities() {
        guard let path = Bundle.main.path(forResource: "city_list", ofType: "json") else { return }
        let url = URL(fileURLWithPath: path)
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let cityList = try decoder.decode([CityModel].self, from: data)
            self.delegate?.presentCities(cities: cityList)
        } catch {
            print("error: \(error)")
        }
    }
    
    public func setViewDelegate(delegate: PresenterDelegate) {
        self.delegate = delegate
    }
    
    public func didTapCity(city: CityModel) {
        delegate?.openCityDetailVC(city: city)
    }
}
