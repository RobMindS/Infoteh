//
//  CityDetailViewController.swift
//  Infoteh
//
//  Created by admin on 19.07.2022.
//

import UIKit
import MapKit

class CityDetailViewController: UIViewController, DetailCityPresenterDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var weatherView: UIView!
    @IBOutlet weak var currentWeatherLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var degreeLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    
    let mf = MeasurementFormatter()
    
    private var headerTopConstraint: NSLayoutConstraint!
    private var headerHeightConstraint: NSLayoutConstraint!
    
    var city: CityModel?
    
    private var presenter = DetailCityPresenter()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setViews()
        arrangeConstraints()
        presenter.setViewDelegate(delegate: self)
        getCityWeatherData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide the navigation bar on the this view controller
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setMapCoordinates()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Show the navigation bar on other view controllers
        self.navigationController?.navigationBar.isHidden = false
    }
    
    func setViews() {
        mapView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height / 3)
        mapView.clipsToBounds = true
        mapView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.delegate = self
        scrollView.alwaysBounceVertical = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        weatherView.layer.cornerRadius = 10
    }
    
    
    func arrangeConstraints() {
        headerTopConstraint = mapView.topAnchor
            .constraint(equalTo: view.topAnchor)
        headerHeightConstraint = mapView.heightAnchor
            .constraint(equalToConstant: self.view.frame.height / 3)
        let headerContainerViewConstraints: [NSLayoutConstraint] = [
            headerTopConstraint,
            mapView.widthAnchor
                .constraint(equalTo: scrollView.widthAnchor, multiplier: 1.0),
            headerHeightConstraint
        ]
        NSLayoutConstraint.activate(headerContainerViewConstraints)
    }
    
    func getCityWeatherData() {
        guard let data = city else { return }
        self.cityNameLabel.text = data.name
        presenter.getCityWeather(lat: String(data.coord.lat), lon: String(data.coord.lon))
    }
    
    func convertTemp(temp: Double, from inputTempType: UnitTemperature, to outputTempType: UnitTemperature) -> String {
        mf.numberFormatter.maximumFractionDigits = 0
        mf.unitOptions = .providedUnit
        let input = Measurement(value: temp, unit: inputTempType)
        let output = input.converted(to: outputTempType)
        return mf.string(from: output)
    }
    
    func setMapCoordinates() {
        guard let data = city else { return }
        presenter.setMapCoordinates(latitude: data.coord.lat, longitude: data.coord.lon)
    }
    
    
    // MARK: Presenter Delegate
    func presentCityWeather(cityWeatherData: CityWeatherModel) {
        DispatchQueue.main.async {
            let date = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .long
            self.dateLabel.text = dateFormatter.string(from: date)
            self.currentWeatherLabel.text = "Current Weather"
            let icon: String = cityWeatherData.weather.first?.icon ?? ""
            self.iconImageView.downloaded(from: "https://openweathermap.org/img/w/\(icon).png")
            self.degreeLabel.text = "\(self.convertTemp(temp: cityWeatherData.main.temp, from: .kelvin, to: .celsius))"
            let description: String = cityWeatherData.weather.first?.description ?? ""
            self.descriptionLabel.text = description
            self.tempLabel.text = "min/max temp:  \(self.convertTemp(temp: cityWeatherData.main.tempMin, from: .kelvin, to: .celsius)) / \(self.convertTemp(temp: cityWeatherData.main.tempMax, from: .kelvin, to: .celsius))"
            self.windSpeedLabel.text = "\(cityWeatherData.wind.speed) m/s"
            self.humidityLabel.text = "\(cityWeatherData.main.humidity) %"
        }
    }
    
}


private extension MKMapView {
    func centerToLocation(
        _ location: CLLocation,
        regionRadius: CLLocationDistance = 1000
    ) {
        let coordinateRegion = MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: regionRadius,
            longitudinalMeters: regionRadius)
        setRegion(coordinateRegion, animated: true)
    }
}



extension CityDetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 0.0 {
            // Scrolling down: Scale
            headerHeightConstraint?.constant =
            (self.view.frame.height / 3) - scrollView.contentOffset.y
        } else {
            // Scrolling up: Parallax
            let parallaxFactor: CGFloat = 0.25
            let offsetY = scrollView.contentOffset.y * parallaxFactor
            let minOffsetY: CGFloat = 8.0
            let availableOffset = min(offsetY, minOffsetY)
            let contentRectOffsetY = availableOffset / self.view.frame.height / 3
            headerTopConstraint?.constant = view.frame.origin.y
            headerHeightConstraint?.constant =
            (self.view.frame.height / 3) - scrollView.contentOffset.y
            mapView.layer.contentsRect =
            CGRect(x: 0, y: -contentRectOffsetY, width: 1, height: 1)
        }
    }
}
