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
import Alamofire

final class Weather {
    
    // MARK: - Properties
    
    // TODO: - Wind info can also be added
    var title = ""
    var descriptionString = ""
    var iconName = ""
    var temperature = 0
    var locationName = ""
    var dataRequest: DataRequest?
    
    var iconURL: URL? {
        let iconURLString = ServiceManager.URLString.icon(named: iconName)
        return URL(string: iconURLString)
    }
    
    // MARK: - Life Cycle
    
    private func update(with json: JSON) throws {
        locationName = json["name"].stringValue
        temperature = json["main"]["temp"].intValue
        
        guard let weatherElement = json["weather"].arrayValue.first else {
            throw ConfigureError.doNotHaveInfo
        }
        
        title = weatherElement["main"].stringValue
        descriptionString = weatherElement["description"].stringValue
        iconName = weatherElement["icon"].stringValue
    }
    
}

// MARK: - Configurable

extension Weather {
    
    enum ConfigureError: LocalizedError {
        case doNotHaveInfo
    }
    
    func configure(coordinate: CLLocationCoordinate2D, completion: @escaping (_ success: Bool, _ error: Error?) -> Void) {
        // Retain data request in order to cancel it in the future if required.
        dataRequest = ServiceManager.weatherRequest(coordinate: coordinate).responseJSON { (response) in
            // Do json conversions on background queue.
            DispatchQueue.global(qos: .background).async { [weak self] in
                // Check whether self still exists and response is valid.
                guard let `self` = self, let value = response.result.value, response.result.error == nil else {
                    DispatchQueue.main.async { completion(false, response.result.error) }
                    return
                }
                
                self.dataRequest = nil
                let weatherJSON = JSON(value)
                
                // Update with json.
                do {
                    try self.update(with: weatherJSON)
                    DispatchQueue.main.async { completion(true, nil) }
                } catch {
                    DispatchQueue.main.async { completion(false, error) }
                }
            }
        }
    }
    
}
