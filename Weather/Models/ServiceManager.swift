//
//  ServiceManager.swift
//  Weather
//
//  Created by Anıl Göktaş on 29.10.2018.
//  Copyright © 2018 Anıl Göktaş. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation

final class ServiceManager: NSObject {
    
    // MARK: - Properties
    
    enum URLString {
        static let weather = "http://api.openweathermap.org/data/2.5/weather"
        static let icon = "http://openweathermap.org/img/w/"
        
        static func weather(for location: CLLocation) -> String {
            // TODO: - Language option is also available, see https://openweathermap.org/current#multi
            return URLString.weather
                + "?lat=\(location.coordinate.latitude)"
                + "&lon=\(location.coordinate.longitude)"
                + "&units=metric"
                + "&APPID=\(Constants.OpenWeatherMap.apiKey)"
        }
        
        static func icon(named: String) -> String {
            return URLString.icon + named + ".png"
        }
    }
    
    // MARK: - DataRequests
    
    class func weatherRequest(for location: CLLocation) -> DataRequest {
        let urlString = URLString.weather(for: location)
        return Alamofire.request(urlString, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil)
    }
    
}
