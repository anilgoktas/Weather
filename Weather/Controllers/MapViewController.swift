//
//  MapViewController.swift
//  Weather
//
//  Created by Anıl Göktaş on 29.10.2018.
//  Copyright © 2018 Anıl Göktaş. All rights reserved.
//

import UIKit
import MapKit

final class MapViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var mapView: MKMapView!
    
    // MARK: - Properties
    
    var locationManager = CLLocationManager()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }
    
}

// MARK: - IBActions

extension MapViewController {
    
    @IBAction func showCurrentLocation(_ sender: Any) {
        if let location = locationManager.location {
            mapView.setCenter(location.coordinate, animated: true)
        } else {
            print("Current location is nil.")
        }
    }
    
    @IBAction func showLocationWeather(_ sender: UITapGestureRecognizer) {
        // Configure coordinates from tap point on map view.
        let tapPoint = sender.location(in: mapView)
        let coordinate = mapView.convert(tapPoint, toCoordinateFrom: mapView)
        
        // Perform segue to coordinate weather.
        performSegue(withIdentifier: SegueIdentifier.CoordinateWeather, sender: coordinate)
    }
    
}

// MARK: - Configurable

extension MapViewController: Configurable {
    
    func configureModel() {
        configureLocationManager()
    }
    
}

// MARK: - SegueHandler

extension MapViewController: SegueHandler {
    
    enum SegueIdentifier: String {
        case CoordinateWeather
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if
        segue.identifier == SegueIdentifier.CoordinateWeather.rawValue,
        let coordinateWeatherViewController = segue.destination as? CoordinateWeatherViewController,
        let locationCoordinate = sender as? CLLocationCoordinate2D
        {
            coordinateWeatherViewController.locationCoordinate = locationCoordinate
        }
    }
    
}

// MARK: - LocationUsableType

extension MapViewController: LocationUsableType, CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        configureLocationManager()
        
        if status == .authorizedWhenInUse {
            mapView.showsUserLocation = true
            showCurrentLocation(status)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // We can center map view when user moves.
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
        alertWeCantLocateYou()
    }
    
}

// MARK: - AlertPresentable

extension MapViewController: AlertPresentable {
    
    fileprivate func alertWeCantLocateYou() {
        alert(title: "Location Error", message: "We couldn't determine your location, please check your connection.", cancelButtonTitle: "OK")
    }
    
}
