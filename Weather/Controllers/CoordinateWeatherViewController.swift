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
    
    @IBOutlet private weak var locationLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var temperatureLabel: UILabel!
    
    // MARK: - Properties
    
    /// Presenter View Controller must assign this property in order to setup.
    var locationCoordinate: CLLocationCoordinate2D! { didSet { didSetLocationCoordinate() } }
    private var weather = Weather()
    private var currentState = State.loading { didSet { didSetCurrentState() } }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }
    
    deinit {
        // Cancel data request if it's not completed yet.
        weather.dataRequest?.cancel()
    }
    
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
            // Loading state.
            titleLabel.text = "Loading..."
            descriptionLabel.text = "Please wait."
            locationLabel.text = " "
            navigationItem.setRightBarButton(nil, animated: true)
        case .error:
            // Error state.
            titleLabel.text = "Something went wrong."
            locationLabel.text = " "
            descriptionLabel.text = "Please try again."
            temperatureLabel.text = "..."
            navigationItem.setRightBarButton(retryRightBarButtonItem(), animated: true)
        case .success:
            // Success state.
            locationLabel.text = weather.locationName
            titleLabel.text = weather.title
            descriptionLabel.text = weather.descriptionString.capitalized
            temperatureLabel.text = String(weather.temperature)
            imageView.kf.setImage(with: weather.iconURL)
            navigationItem.setRightBarButton(nil, animated: true)
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

// MARK: - Retry

extension CoordinateWeatherViewController {
    
    // Factory method for assigning right bar button item.
    private func retryRightBarButtonItem() -> UIBarButtonItem {
        return UIBarButtonItem(title: "Retry", style: .plain, target: self, action: .retry)
    }
    
    @objc func retry() {
        didSetLocationCoordinate()
    }
    
}

// MARK: - Selector

private extension Selector {
    static let retry = #selector(CoordinateWeatherViewController.retry)
}
