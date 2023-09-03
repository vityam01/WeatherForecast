//
//  OpenWeatherController.swift
//  WeatherForecast
//
//  Created by Vitya Mandryk on 01.09.2023.
//

import Foundation
import UIKit
import GooglePlaces

class OpenWeatherController: UIViewController {
    
    //MARK: @IBOutlets
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var editBarButton: UIBarButtonItem!
    @IBOutlet private weak var searchBarButton: UIBarButtonItem!
    
    //MARK: Varaibles
    var weatherLocations: [WeatherLocation] = []
    var selectedLocationIndex = 0
    private var appTool = APPHelper()
    private var networkService = NetworkOpenWeatherManager.shared

    
    
    //MARK: viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        selectedLocationIndex = tableView.indexPathForSelectedRow!.row
        saveData()
    }
    
    
    private func saveData (){
        let encoder = JSONEncoder ()
        if let encoded = try? encoder.encode(weatherLocations) {
            UserDefaults.standard.setValue(encoded, forKey: "WeatherLocationsListKey")
        } else {
            print ("ERROR: Saving encoded didnt work!")
        }
    }
    
    @IBAction private func searchButtonPressed(_ sender: UIBarButtonItem) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        // Display the autocomplete view controller.
        present(autocompleteController, animated: true, completion: nil)
    }

    @IBAction private func editButtonPressed(_ sender: UIBarButtonItem) {
        if tableView.isEditing {
            tableView.setEditing(false, animated: true)
            sender.title = "Edit"
            searchBarButton.isEnabled = true
        } else {
            tableView.setEditing(true, animated: true)
            sender.title = "Done"
            searchBarButton.isEnabled = false
        }
    }
}


// MARK: UITableViewDelegate, UITableViewDataSource
extension OpenWeatherController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherLocations.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cityCell", for: indexPath) as! CitySelectionTableViewCell
        cell.configure(cityName: weatherLocations[indexPath.row].name,
                        localTime: weatherLocations[indexPath.row].locationTime,
                        tempC: "\(weatherLocations[indexPath.row].tempC)")
        
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            weatherLocations.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let itemToMove = weatherLocations[sourceIndexPath.row]
        weatherLocations.remove(at: sourceIndexPath.row)
        weatherLocations.insert(itemToMove, at: destinationIndexPath.row)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return (indexPath.row != 0 ? true : false)
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return (indexPath.row != 0 ? true : false)
    }
    func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        return (proposedDestinationIndexPath.row == 0 ? sourceIndexPath : proposedDestinationIndexPath)
    }
}


//MARK: GMSAutocompleteViewControllerDelegate
extension OpenWeatherController: GMSAutocompleteViewControllerDelegate {
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        networkService.getWeather2(city: place.name!, lat: place.coordinate.latitude, lon: place.coordinate.longitude) {
            responseModel in
            
            let tempC = responseModel?.current?.temp
            let localTime = responseModel?.current?.dt
            let timeZone = responseModel?.timezone
            
            guard localTime != nil , timeZone != nil, tempC != nil else{return}
            
            self.appTool.dateFormatter.timeZone = TimeZone(identifier: timeZone!)
            let usableDate = Date(timeIntervalSince1970: (responseModel?.current?.dt)!)
            let locationTime = self.appTool.dateFormatter.string(from: usableDate)
            
            let newLocation = WeatherLocation(name: place.name ?? "unknown place",
                                              tempC: "\(Int(tempC!))ºC",
                                              locationTime: "\(locationTime )",
                                              latitude: place.coordinate.latitude,
                                              longitude: place.coordinate.longitude)
            
            self.weatherLocations.append(newLocation)
            self.tableView.reloadData()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error: ", error.localizedDescription)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
}

