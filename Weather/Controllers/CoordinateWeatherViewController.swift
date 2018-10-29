//
//  CoordinateWeatherViewController.swift
//  Weather
//
//  Created by Anıl Göktaş on 29.10.2018.
//  Copyright © 2018 Anıl Göktaş. All rights reserved.
//

import UIKit
import CoreLocation

final class CoordinateWeatherViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    // MARK: - Properties
    
    var locationCoordinate: CLLocationCoordinate2D! { didSet { didSetLocationCoordinate() } }
    private var weather = Weather()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }
    
    deinit {
        // Cancel data request if not completed yet.
        weather.dataRequest?.cancel()
    }
    
}

// MARK: - IBActions

extension CoordinateWeatherViewController {
    
    
}

// MARK: - Configurable

extension CoordinateWeatherViewController: Configurable {
    
    func configureObservers() {
        NotificationCenter.default.addObserver(self, selector: .weatherDidUpdate, name: .WeatherDidUpdate, object: nil)
    }
    
    private func didSetLocationCoordinate() {
        weather.configure(coordinate: locationCoordinate)
    }
    
    @objc func weatherDidUpdate() {
        dump(weather)
    }
    
}

// MARK: - Selector

private extension Selector {
    static let weatherDidUpdate = #selector(CoordinateWeatherViewController.weatherDidUpdate)
}
