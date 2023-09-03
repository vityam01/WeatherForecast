//
//  LocationDetailViewController.swift
//  WeatherForecast
//
//  Created by Vitya Mandryk on 01.09.2023.
//

import UIKit
import CoreLocation



class LocationDetailViewController: UIViewController {
    
    //MARK: @IBOutlets
    @IBOutlet private weak var table: UITableView!
    @IBOutlet private weak var scrollViewTable: UICollectionView!
    @IBOutlet private weak var cityLable: UILabel!
    @IBOutlet private weak var conditionLabel: UILabel!
    @IBOutlet private weak var temperatureLabel: UILabel!
    @IBOutlet private weak var timeAndDataLabel: UILabel!
    @IBOutlet private weak var backgroundWeatherPicture: UIImageView!
    
    
    //MARK: Variables
    var locationManager: CLLocationManager!
    var locationIndex = 0
    weak var pageController: PageViewController?
    private var weatherService: WeatherService!
    private var appTool = APPHelper()
    
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.delegate = self
        table.dataSource = self
        scrollViewTable.delegate = self
        scrollViewTable.dataSource = self
        
        if locationIndex == 0 {
            getLocation()
        }
        
        requestWeatherForLocation()
    }
    
    
    //MARK: viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        requestWeatherForLocation()
    }
    
    //MARK: viewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    
    //MARK: prepare(for segue)
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "ShowList" {
            let destination = segue.destination as! OpenWeatherController
            if let pageViewController =  UIApplication.shared.windows.first?.rootViewController as? PageViewController{
            
                destination.weatherLocations = pageViewController.weatherLocations
            }
        } else if segue.identifier == "ShowMapFinder" {
            if let locationSelectionVC = segue.destination as? LocationSelectionViewController {
                locationSelectionVC.delegate = self
            }
        }
    }
    
    
    //MARK: Private methods
    private func updateSelectedLocationWithCoordinate(_ coordinate: CLLocationCoordinate2D) {
        guard let pageViewController = UIApplication.shared.windows.first!.rootViewController as? PageViewController else {
            return
        }
        // Update the selected location with the new coordinate
        let selectedLocation = pageViewController.weatherLocations[locationIndex]
        selectedLocation.latitude = coordinate.latitude
        selectedLocation.longitude = coordinate.longitude
        // Call requestWeatherForLocation() to fetch weather for the updated coordinate
        // and update the UI accordingly
        requestWeatherForLocation()
        // Dismiss the LocationSelectionViewController
        dismiss(animated: true, completion: nil)
    }
    
    private func requestWeatherForLocation() {
        
        guard let pageViewController = pageController else {
            assertionFailure("Page controller needed")
            return
            
        }
        let weatherLocation = pageViewController.weatherLocations[locationIndex]
        weatherService = WeatherService(name: weatherLocation.name, tempC: weatherLocation.tempC, locationTime:weatherLocation.locationTime, latitude: weatherLocation.latitude, longitude: weatherLocation.longitude)
        
        weatherService.getData { [weak self] completed in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.appTool.dateFormatter.timeZone = TimeZone(identifier: self.weatherService.timezone)
                let usableDate = Date(timeIntervalSince1970: self.weatherService.currentTime)
                self.timeAndDataLabel.text = self.appTool.dateFormatter.string(from: usableDate)
                self.conditionLabel.text = self.weatherService.description
                self.temperatureLabel.text = self.weatherService.temperature.description + "°"
                self.cityLable.text = self.weatherService.locationName
                self.table.reloadData()
                self.scrollViewTable.reloadData()
                guard let weatherS = self.weatherService.dailyWeatherData.first else { return }
                
                guard let icon = weatherS.dailyWeatherState else {return}
                switch icon {
                case .clear:
                    self.backgroundWeatherPicture.image = #imageLiteral(resourceName: "84821251-blue-sky-with-very-few-clouds")
                case .rain:
                    self.backgroundWeatherPicture.image = #imageLiteral(resourceName: "rain-israel-1597x900")
                case .clouds:
                    self.backgroundWeatherPicture.image = #imageLiteral(resourceName: "cloud+dark+blue")
                case .drizzle:
                    self.backgroundWeatherPicture.image = #imageLiteral(resourceName: "rain-israel-1597x900")
                case .fog:
                    self.backgroundWeatherPicture.image = #imageLiteral(resourceName: "ft1.jfif")
                case .thunderstorm:
                    self.backgroundWeatherPicture.image = #imageLiteral(resourceName: "thunderstorm-and-lightning")
                case .mist:
                    self.backgroundWeatherPicture.image = #imageLiteral(resourceName: "ft1.jfif")
                case .snow:
                    self.backgroundWeatherPicture.image = #imageLiteral(resourceName: "Snow")
                }
            }
        }
    }

    //MARK: @IBActions
    @IBAction func unwindFromOpenWeatherController (segue: UIStoryboardSegue) {
        let source = segue.source as! OpenWeatherController
        locationIndex = source.selectedLocationIndex
        
        let pageViewController = UIApplication.shared.windows.first!.rootViewController as! PageViewController
        
        pageViewController.weatherLocations = source.weatherLocations
        pageViewController.setViewControllers([pageViewController.createLocationDetailViewController(forPage: locationIndex)], direction: .forward, animated: false, completion: nil)
    }
    
    @IBAction func pageControllTapped(_ sender: UIPageControl) {
        let pageViewController = UIApplication.shared.windows.first!.rootViewController as! PageViewController
        
        var direction: UIPageViewController.NavigationDirection = .forward
        if sender.currentPage < locationIndex {
            direction = .reverse
        }
        
        pageViewController.setViewControllers([pageViewController.createLocationDetailViewController(forPage: sender.currentPage)], direction: direction, animated: true, completion: nil)
        
    }
}

//MARK: UITableViewDataSource, UITableViewDelegate
extension LocationDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherService.dailyWeatherData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellIDaily", for: indexPath) as! DailyTableViewCell
        cell.dailyWeather = weatherService.dailyWeatherData[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

//MARK:  UICollectionViewDelegate, UICollectionViewDataSource
extension LocationDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return weatherService.hourlyWeatherData.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let hourlyCell = scrollViewTable.dequeueReusableCell(withReuseIdentifier: "HourlyCell", for: indexPath) as! HourlyCollectionViewCell
        hourlyCell.hourlyWeather = weatherService.hourlyWeatherData[indexPath.row]
        return hourlyCell
    }
}

//MARK: CLLocationManagerDelegate
extension LocationDetailViewController: CLLocationManagerDelegate {
    
    func getLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("Cheking Authentication Status")
        handleAuthenticalStatus(status: status)
    }
    
    func handleAuthenticalStatus(status:CLAuthorizationStatus) {
        switch status{
        
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            self.oneButtonAlert(title: "Location Services deined", message: "It may be that parental controls are restricting location use in this App")
        case .denied:
            showAlertToPrivacySettings(title: "User has not authorized location services", message: "Select 'Settings' below to enable device settings and enable location services for this app.")
        case .authorizedAlways:
            locationManager.requestLocation()
        case .authorizedWhenInUse:
            locationManager.requestLocation()
        @unknown default:
            print ("DEVELOPER ALERT: Unknown case of status in \(status)")
        }
    }
    
    func showAlertToPrivacySettings (title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else {
            print("Something went wrong getting the UIApplication.openSettingsURLString")
            return
        }
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) in
            UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(settingsAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let currentLocation = locations.last ?? CLLocation()
        print ("pdating location is \(currentLocation.coordinate.latitude), \(currentLocation.coordinate.longitude)")
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(currentLocation) { (placemarks, error) in
            var locationName = ""
            if placemarks != nil {
                //get the first placemark
                let placemark = placemarks?.last
                //assign placemark to location name
                locationName = placemark?.locality ?? "Parts unknown"
            } else {
                print ("ERROR: Retrieving place.")
                locationName = "Could not find location"
            }
            //Update WeatherLocations[0] with the current location so it can be used in requestWeatherForLocation
            let pageViewController = UIApplication.shared.windows.first!.rootViewController as! PageViewController
            pageViewController.weatherLocations[self.locationIndex].latitude = currentLocation.coordinate.latitude
            pageViewController.weatherLocations[self.locationIndex].longitude = currentLocation.coordinate.longitude
            pageViewController.weatherLocations[self.locationIndex].name = locationName
            self.requestWeatherForLocation()
        }
        
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("ERROR: \(error.localizedDescription). Failed to get device location.")
    }
    
}

//MARK: LocationSelectionDelegate
extension LocationDetailViewController: LocationSelectionDelegate {
    func didSelectLocation(coordinate: CLLocationCoordinate2D) {
        updateSelectedLocationWithCoordinate(coordinate)
    }
}
