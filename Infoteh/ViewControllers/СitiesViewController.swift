//
//  СitiesViewController.swift
//  Infoteh
//
//  Created by admin on 19.07.2022.
//

import UIKit

class СitiesViewController: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchButton: UIBarButtonItem!
    var searchBar: UISearchBar!
    var btnCancelSearch: UIBarButtonItem!
    
    let jsonService = JsonService()
    var cities: [СityModel] = []
    var filterCities: [СityModel] = []

    //Constants
    struct Constants {
        static let cityJsonListPath: String = "city_list"
        static let cellHeight: CGFloat = 100
        static let searchBarHeight: CGFloat = 40
        static let imageUrlForPaired: String = "https://infotech.gov.ua/storage/img/Temp3.png"
        static let imageUrlForUnpaired: String = "https://infotech.gov.ua/storage/img/Temp1.png"
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getCities()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        hideKeyboardWhenTappedAround()
    }
    
    
    //MARK: Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
            
        case "cityDetail":
            guard let detailVC = segue.destination as? CityDetailViewController else { return }
            if let data = sender as? СityModel {
                detailVC.city = data
            }
            
        default:
            break
        }
    }
    
    
    func getCities() {
        jsonService.loadJson(path: Constants.cityJsonListPath, completionHandler: { result in
            DispatchQueue.main.async {
                guard let cityList = result else { return }
                self.cities = cityList
                self.filterCities = cityList
                self.tableView.reloadData()
            }
        })
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
        self.cities = self.filterCities.filter{$0.name.lowercased().hasPrefix(searchText.lowercased()) }
        self.tableView.reloadData()
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
}



extension СitiesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row % 2 == 0 {
            guard let pairedCell = tableView.dequeueReusableCell(withIdentifier: "pairedCell", for: indexPath) as? PairedTableViewCell else { return UITableViewCell() }
            pairedCell.pictureImageView.downloaded(from: Constants.imageUrlForPaired)
            pairedCell.cityNameLabel.text = cities[indexPath.row].name
            return pairedCell
        } else {
            guard let unpairedCell = tableView.dequeueReusableCell(withIdentifier: "unpairedCell", for: indexPath) as? UnpairedTableViewCell else { return UITableViewCell() }
            unpairedCell.pictureImageView.downloaded(from: Constants.imageUrlForUnpaired)
            unpairedCell.cityNameLabel.text = cities[indexPath.row].name
            return unpairedCell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "cityDetail", sender: cities[indexPath.row])
    }
    
}
