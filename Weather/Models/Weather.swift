//
//  Weather.swift
//  Weather
//
//  Created by Anıl Göktaş on 29.10.2018.
//  Copyright © 2018 Anıl Göktaş. All rights reserved.
//

import Foundation
import CoreLocation
import SwiftyJSON

final class Weather {
    
    // MARK: - Properties
    
    // TODO: - Wind info can also be added
    var title = ""
    var descriptionString = ""
    var iconName = ""
    var temperature = 0
    var locationName = ""
    
    var iconURL: URL? {
        let iconURLString = ServiceManager.URLString.icon(named: iconName)
        return URL(string: iconURLString)
    }
    
    // MARK: - Life Cycle
    
    init() {
        title = "Loading..."
        descriptionString = "Please wait"
        locationName = " "
    }
    
    fileprivate func update(with json: JSON) {
        locationName = json["name"].stringValue
        temperature = json["main"]["temp"].intValue
        
        guard let weatherElement = json["weather"].arrayValue.first else {
            print("weather array doesn't contain any info")
            return
        }
        
        title = weatherElement["main"].stringValue
        descriptionString = weatherElement["description"].stringValue
        iconName = weatherElement["icon"].stringValue
    }
    
}

// MARK: - Configurable

extension Weather {
    
    func configure(for location: CLLocation) {
        ServiceManager.weatherRequest(for: location).responseJSON { (response) in
            DispatchQueue.global(qos: .background).async {
                guard let value = response.result.value, response.result.error == nil else {
                    print(response.result.error?.localizedDescription ?? "Weather configure error")
                    return
                }
                
                let weatherJSON = JSON(value)
                self.update(with: weatherJSON)
                
                // Notify update.
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: .WeatherDidUpdate, object: nil)
                }
            }
        }
    }
    
}

// MARK: - Notification.Name

extension Notification.Name {
    static let WeatherDidUpdate = Notification.Name(rawValue: "WeatherDidUpdate")
}
