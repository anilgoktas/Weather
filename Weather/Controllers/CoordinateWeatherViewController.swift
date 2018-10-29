//
//  CoordinateWeatherViewController.swift
//  Weather
//
//  Created by Anıl Göktaş on 29.10.2018.
//  Copyright © 2018 Anıl Göktaş. All rights reserved.
//

import UIKit
import CoreLocation
import Kingfisher

final class CoordinateWeatherViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet fileprivate weak var locationLabel: UILabel!
    @IBOutlet fileprivate weak var titleLabel: UILabel!
    @IBOutlet fileprivate weak var imageView: UIImageView!
    @IBOutlet fileprivate weak var descriptionLabel: UILabel!
    @IBOutlet fileprivate weak var temperatureLabel: UILabel!
    
    // MARK: - Properties
    
    var locationCoordinate: CLLocationCoordinate2D! { didSet { didSetLocationCoordinate() } }
    private var weather = Weather()
    private var currentState = State.loading { didSet { didSetCurrentState() } }
    
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
    
    private enum State {
        case loading
        case error
        case success
    }
    
    func configureView() {
        didSetCurrentState()
    }
    
    private func didSetCurrentState() {
        switch currentState {
        case .loading:
            titleLabel.text = "Loading..."
            descriptionLabel.text = "Please wait."
            locationLabel.text = " "
        case .error:
            titleLabel.text = "Something went wrong."
            locationLabel.text = " "
            descriptionLabel.text = "Please try again."
            temperatureLabel.text = " "
            // retry button.
        case .success:
            locationLabel.text = weather.locationName
            titleLabel.text = weather.title
            descriptionLabel.text = weather.descriptionString.capitalized
            temperatureLabel.text = String(weather.temperature)
            imageView.kf.setImage(with: weather.iconURL)
        }
    }
    
    private func didSetLocationCoordinate() {
        weather.configure(coordinate: locationCoordinate) { [weak self] (success, error) in
            // Check whether self exists.
            guard let `self` = self else { return }
            
            self.currentState = success ? .success : .error
        }
    }
    
}
