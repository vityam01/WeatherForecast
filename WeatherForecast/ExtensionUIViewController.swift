//
//  ExtensionUIViewController.swift
//  WeatherForecast
//
//  Created by Elena on 04.02.2021.
//

import UIKit

extension UIViewController {
    func oneButtonAlert (title: String, message: String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

