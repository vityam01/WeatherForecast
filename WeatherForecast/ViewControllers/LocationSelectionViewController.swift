//
//  LocationSelectionViewController.swift
//  WeatherForecast
//
//  Created by Vitya Mandryk on 01.09.2023.
//

import Foundation
import UIKit
import MapKit

//MARK: LocationSelectionDelegate
protocol LocationSelectionDelegate: AnyObject {
    func didSelectLocation(coordinate: CLLocationCoordinate2D)
}

//MARK: LocationSelectionViewController
class LocationSelectionViewController: UIViewController {
    
    //MARK: @IBOutlets
    @IBOutlet private weak var mapView: MKMapView!
    @IBOutlet private weak var confirmButton: UIButton!

    //MARK: Variables
    var selectedCoordinate: CLLocationCoordinate2D?
    var completionHandler: ((CLLocationCoordinate2D) -> Void)?
    weak var delegate: LocationSelectionDelegate?

    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleMapTap(_:)))
        mapView.addGestureRecognizer(tapGesture)
        
        confirmButton.isEnabled = false
    }

    //MARK: @objc func 
    @objc func handleMapTap(_ gestureRecognizer: UITapGestureRecognizer) {
        let touchPoint = gestureRecognizer.location(in: mapView)
        let coordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        
        selectedCoordinate = coordinate
        confirmButton.isEnabled = true
        
        // Remove previous annotations
        mapView.removeAnnotations(mapView.annotations)
        
        // Add a new annotation for the selected point
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
    }
    
    //MARK: @IBActions
    @IBAction func confirmButtonTapped(_ sender: UIButton) {
        guard let coordinate = selectedCoordinate else { return }
        
        delegate?.didSelectLocation(coordinate: coordinate)
        dismiss(animated: true, completion: nil)
    }
}
