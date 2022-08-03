//
//  DetailCityPresenter.swift
//  Infoteh
//
//  Created by admin on 02.08.2022.
//

import Foundation
import UIKit
import MapKit

protocol DetailCityPresenterDelegate: AnyObject {
    func presentCityWeather(cityWeatherData: CityWeatherModel)
}

typealias DetailPresenterDelegate = DetailCityPresenterDelegate & CityDetailViewController

class DetailCityPresenter {
    
    private let api = "https://api.openweathermap.org/data/2.5/weather"
    private let apiKey = "c0ff0af889953630efae57dcaaa30aa1"
    
    // MARK: - Constants
    struct Constants {
        static fileprivate let latitudinalMeters: Double = 10000
        static fileprivate let longitudinalMeters: Double = 10000
        static fileprivate let maxCenterCoordinateDistance: Double = 200000
    }
    
    weak var delegate: DetailPresenterDelegate?
    
    
    public func getCityWeather(lat: String, lon: String) {
        guard let url = URL(string: api + "?lat=" + lat + "&lon=" + lon + "&appid=" + apiKey) else { return }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            
            do {
                let decoder = JSONDecoder()
                let weatherData = try decoder.decode(CityWeatherModel.self, from: data)
                self.delegate?.presentCityWeather(cityWeatherData: weatherData)
            } catch {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    
    public func setMapCoordinates(latitude: Double, longitude: Double) {
        let oahuCenter = CLLocation(latitude: latitude, longitude: longitude)
        let region = MKCoordinateRegion(
            center: oahuCenter.coordinate,
            latitudinalMeters: Constants.latitudinalMeters,
            longitudinalMeters: Constants.longitudinalMeters)
        delegate?.mapView.setCameraBoundary(
            MKMapView.CameraBoundary(coordinateRegion: region),
            animated: true)
        
        let zoomRange = MKMapView.CameraZoomRange(maxCenterCoordinateDistance: Constants.maxCenterCoordinateDistance)
        delegate?.mapView.setCameraZoomRange(zoomRange, animated: true)
    }
    
    public func setViewDelegate(delegate: DetailPresenterDelegate) {
        self.delegate = delegate
    }
}
