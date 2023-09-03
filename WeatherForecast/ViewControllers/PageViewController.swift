//
//  PageViewController.swift
//  WeatherForecast
//
//  Created by Vitya Mandryk on 01.09.2023.
//

import UIKit

class PageViewController: UIPageViewController {
    
    var weatherLocations: [WeatherLocation] = []
    
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        self.dataSource = self
        
        loadData()
        setViewControllers([createLocationDetailViewController(forPage: 0)], direction: .forward, animated: false, completion: nil)
    }
    
    private func loadData() {
        guard let locationsEncoded = UserDefaults.standard.value(forKey: "WeatherLocationsListKey") as? Data else {
            print("ERROR!: Could not load weatherLocations Data from UserDefaults. This would always be the case the first time an app installed^ so if thats the case, ignore this error.")
            //TODO: Get User Location for the first element in weatherLocations
            weatherLocations.append(WeatherLocation(name: "CURRENT LOCATION", tempC: "", locationTime: "", latitude: 20.20, longitude: 20.20))
            return
        }
        let decoder = JSONDecoder()
        if let weatherLocations = try? decoder.decode(Array.self, from: locationsEncoded) as [WeatherLocation] {
            self.weatherLocations = weatherLocations
        } else {
            
            print("ERROR: Couldnt decode data read from UserDefaults")
        
        }
        if weatherLocations.isEmpty {
            weatherLocations.append(WeatherLocation(name: "", tempC: "", locationTime: "", latitude: 20.20, longitude: 20.20))
        }
    }
    
    func createLocationDetailViewController (forPage page: Int) -> LocationDetailViewController {
        let detailViewController = storyboard?.instantiateViewController(identifier: "LocationDetailViewController") as! LocationDetailViewController
        detailViewController.pageController = self
        detailViewController.locationIndex = page
        return detailViewController
    }
}


//MARK: UIPageViewControllerDelegate, UIPageViewControllerDataSource
extension PageViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let currentViewController = viewController as? LocationDetailViewController {
            if currentViewController.locationIndex > 0 {
                return createLocationDetailViewController(forPage: currentViewController.locationIndex - 1)
            }
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let currentViewController = viewController as? LocationDetailViewController {
            if currentViewController.locationIndex < weatherLocations.count - 1 {
                return createLocationDetailViewController(forPage: currentViewController.locationIndex + 1)
            }
        }
        return nil
    }
}
