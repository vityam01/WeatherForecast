//
//  OpenWeatherController.swift
//  WeatherForecast
//
//  Created by Elena on 29.01.2021.
//

import Foundation
import UIKit
import GooglePlaces

private let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HH:mm aaa"
    return dateFormatter
}()

class OpenWeatherController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var editBarButton: UIBarButtonItem!
    @IBOutlet weak var searchBarButton: UIBarButtonItem!
    
    
    var weatherLocations: [WeatherLocation] = []
    var networkService = NetworkOpenWeatherManager.shared
    var selectedLocationIndex = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
    }
    
    func saveData (){
        let encoder = JSONEncoder ()
        if let encoded = try? encoder.encode(weatherLocations) {
            UserDefaults.standard.setValue(encoded, forKey: "WeatherLocationsListKey")
        } else {
            print ("ERROR: Saving encoded didnt work!")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        selectedLocationIndex = tableView.indexPathForSelectedRow!.row
        saveData()
    }
    
    // Кнопка Search открывает поиск по наименованию регионов, мест
    @IBAction func searchButtonPressed(_ sender: UIBarButtonItem) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        // Display the autocomplete view controller.
        present(autocompleteController, animated: true, completion: nil)
    }
    // Кнопка EDIT удалить или переместить местами в списке
    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {
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
// Добавление тейбл вью
extension OpenWeatherController: UITableViewDelegate, UITableViewDataSource {
    
    //определяет к-во строк в секции
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return weatherLocations.count
    }
    // определяет объекты в Cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cityCell", for: indexPath) as! CitySelectionTableViewCell
        cell.cityNameLabel.text = weatherLocations[indexPath.row].name
        cell.localTimeLabel.text = weatherLocations[indexPath.row].locationTime
        cell.tempCLabel.text = weatherLocations[indexPath.row].tempC
        
        return cell
    }
    // удаление строк в тейбл вью
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            weatherLocations.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    // перемещение строк в тейбл вью
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let itemToMove = weatherLocations[sourceIndexPath.row]
        weatherLocations.remove(at: sourceIndexPath.row)
        weatherLocations.insert(itemToMove, at: destinationIndexPath.row)
    }
    //MARK: - tableView methods to freeze the first cell
    
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

extension OpenWeatherController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        networkService.getWeather2(city: place.name!, lat: place.coordinate.latitude, lon: place.coordinate.longitude) {
            responseModel in
            
            let tempC = responseModel?.current?.temp
            let localTime = responseModel?.current?.dt
            let timeZone = responseModel?.timezone
            
            guard localTime != nil , timeZone != nil, tempC != nil else{return}
            
            dateFormatter.timeZone = TimeZone(identifier: timeZone!)
            let usableDate = Date(timeIntervalSince1970: (responseModel?.current?.dt)!)
            let locationTime = dateFormatter.string(from: usableDate)
            
            let newLocation = WeatherLocation(name: place.name ?? "unknown place",
                                              tempC: "\(Int(tempC!))ºC",
                                              locationTime: "\(locationTime)",
                                              latitude: place.coordinate.latitude,
                                              longitude: place.coordinate.longitude)
            
            self.weatherLocations.append(newLocation)
            self.tableView.reloadData()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
}

