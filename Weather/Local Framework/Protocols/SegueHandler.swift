//
//  SegueHandler.swift
//  Weather
//
//  Created by Anıl Göktaş on 29.10.2018.
//  Copyright © 2018 Anıl Göktaş. All rights reserved.
//

import UIKit

protocol SegueHandler {
    associatedtype SegueIdentifier: RawRepresentable
}

extension SegueHandler where Self: UIViewController, SegueIdentifier.RawValue == String {
    
    func performSegue(withIdentifier segueIdentifier: SegueIdentifier, sender: Any? = nil) {
        performSegue(withIdentifier: segueIdentifier.rawValue, sender: sender)
    }
    
    func segueIdentifier(for segue: UIStoryboardSegue) -> SegueIdentifier {
        guard
            let identifier = segue.identifier,
            let segueIdentifier = SegueIdentifier(rawValue: identifier)
        else { fatalError("Invalid segue identifier \(String(describing: segue.identifier)).") }
        
        return segueIdentifier
    }
    
}
