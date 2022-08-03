//
//  СitiesViewController.swift
//  Infoteh
//
//  Created by admin on 19.07.2022.
//

import UIKit

class СitiesViewController: UIViewController, UISearchBarDelegate, CityPresenterDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchButton: UIBarButtonItem!
    var searchBar: UISearchBar!
    var btnCancelSearch: UIBarButtonItem!
    
    private var cities = [CityModel]()
    private var filterCities = [CityModel]()
    
    private let presenter = CityPresenter()
    
    // MARK: - Constants
    struct Constants {
        static let cellHeight: CGFloat = 100
        static let searchBarHeight: CGFloat = 40
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTableView()
        presenter.setViewDelegate(delegate: self)
        presenter.getCities()
        hideKeyboardWhenTappedAround()
    }
    
    
    func setTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(UINib(nibName: "CityTableViewCell", bundle: nil), forCellReuseIdentifier: "CityTableViewCell")
    }
    
    
    @IBAction func searchButtonAction(_ sender: UIBarButtonItem) {
        searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: Constants.searchBarHeight))
        searchBar.placeholder = "Search movie"
        searchBar.searchBarStyle = .default
        searchBar.showsCancelButton = true
        searchBar.keyboardType = .alphabet
        searchBar.delegate = self
        
        self.navigationItem.titleView = self.searchBar
        self.searchButton.isEnabled = false
        searchBar.becomeFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        self.cities = self.filterCities
        self.tableView.reloadData()
        self.navigationItem.titleView = nil
        self.navigationController?.navigationItem.rightBarButtonItem = self.searchButton
        self.searchButton.isEnabled = true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        DispatchQueue.main.async {
            self.cities = self.filterCities.filter{$0.name.lowercased().hasPrefix(searchText.lowercased()) }
            self.tableView.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(_:)))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
        
        if let nav = self.navigationController {
            nav.view.endEditing(true)
        }
    }
    
    
    // MARK: Presenter Delegate
    func presentCities(cities: [CityModel]) {
        self.cities = cities
        self.filterCities = cities
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func openCityDetailVC(city: CityModel) {
        let cityDetailVC = CityDetailViewController.instantiateFromAppStoryboard(appStoryboard: .CityDetailStoryboard)
        cityDetailVC.city = city
        self.navigationController?.pushViewController(cityDetailVC, animated: true)
    }
    
}


// MARK: - UITableViewDataSource, - UITableViewDelegate
extension СitiesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CityTableViewCell", for: indexPath) as? CityTableViewCell else { return UITableViewCell() }
        cell.setCityData(index: indexPath.row, cityModel: cities[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.didTapCity(city: cities[indexPath.row])
    }
    
}
