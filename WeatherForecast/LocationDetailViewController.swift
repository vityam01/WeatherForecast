//
//  LocationDetailViewController.swift
//  WeatherForecast
//
//  Created by Elena on 03.02.2021.
//
// контролер
//import Foundation
import UIKit
import CoreLocation

private let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "EEEE, MMM d, h:mm aaa"
    return dateFormatter
}()

class LocationDetailViewController: UIViewController {
    
    
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var scrollViewTable: UICollectionView!
    @IBOutlet weak var cityLable: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var timeAndDataLabel: UILabel!
    @IBOutlet weak var backgroundWeatherPicture: UIImageView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    weak var pageController: PageViewController?
    var locationManager: CLLocationManager!
    var locationIndex = 0
    var weatherService: WeatherService!
    
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "ShowList" {
            let destination = segue.destination as! OpenWeatherController
            if let pageViewController =  UIApplication.shared.windows.first?.rootViewController as? PageViewController{
            
                destination.weatherLocations = pageViewController.weatherLocations
            }
        }
    }
    
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
    
    func requestWeatherForLocation() {
        
        guard let pageViewController = pageController else {
            assertionFailure("Page controller needed")
            return
            
        }
        let weatherLocation = pageViewController.weatherLocations[locationIndex]
        weatherService = WeatherService(name: weatherLocation.name, tempC: weatherLocation.tempC, locationTime: weatherLocation.locationTime, latitude: weatherLocation.latitude, longitude: weatherLocation.longitude)
        
        pageControl.numberOfPages = pageViewController.weatherLocations.count
        pageControl.currentPage = locationIndex
        
        
        weatherService.getData {
            completed in
            DispatchQueue.main.async {
                dateFormatter.timeZone = TimeZone(identifier: self.weatherService.timezone)
                let usableDate = Date(timeIntervalSince1970: self.weatherService.currentTime)
                self.timeAndDataLabel.text = dateFormatter.string(from: usableDate)
                self.conditionLabel.text = self.weatherService.description
                self.temperatureLabel.text = self.weatherService.temperature.description + "°"
                self.cityLable.text = self.weatherService.name
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
}
extension LocationDetailViewController: UITableViewDataSource, UITableViewDelegate{
    //MARK: create table for daily weatherForecast
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
extension LocationDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    //MARK: create table for daily weatherForecast
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return weatherService.hourlyWeatherData.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let hourlyCell = scrollViewTable.dequeueReusableCell(withReuseIdentifier: "HourlyCell", for: indexPath) as! HourlyCollectionViewCell
        hourlyCell.hourlyWeather = weatherService.hourlyWeatherData[indexPath.row]
        return hourlyCell
    }
}
extension LocationDetailViewController: CLLocationManagerDelegate {
    
    func getLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("👮👮 Cheking Authentication Status")
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
        print ("🗺 Updating location is \(currentLocation.coordinate.latitude), \(currentLocation.coordinate.longitude)")
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

