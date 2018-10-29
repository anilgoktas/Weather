//
//  LocationUsableType.swift
//  Weather
//
//  Created by Anıl Göktaş on 29.10.2018.
//  Copyright © 2018 Anıl Göktaş. All rights reserved.
//

import UIKit
import CoreLocation
import arek

protocol LocationUsableType: CLLocationManagerDelegate {
    var locationManager: CLLocationManager { get set }
    
    func configureLocationManager()
    func didAuthorizedLocation(status: CLAuthorizationStatus)
}

extension LocationUsableType where Self: UIViewController {
    
    func configureLocationManager() {
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            requestWhenInUseAuthorization()
            
        case .authorizedAlways, .authorizedWhenInUse:
            configureManager()
            
        case .restricted, .denied:
            showAlert()
        }
    }
    
    fileprivate func requestWhenInUseAuthorization() {
        ArekLocationWhenInUse().askForPermission { [weak self] (status) in
            switch status {
            case .authorized:
                self?.didAuthorizedLocation(status: .authorizedWhenInUse)
                self?.configureManager()
            default: break
            }
        }
    }
    
    fileprivate func configureManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.distanceFilter = 10.0
        locationManager.startUpdatingLocation()
    }
    
    fileprivate func showAlert() {
        let alertController = UIAlertController(title: "Location Disabled", message: "Please share your location with us, so we can inform you about weather.", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let openAction = UIAlertAction(title: "Settings", style: .default) { (action) in
            if let url = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        alertController.addAction(openAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
}
