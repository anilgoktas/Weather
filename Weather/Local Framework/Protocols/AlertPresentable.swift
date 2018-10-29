//
//  AlertPresentable.swift
//  Weather
//
//  Created by Anıl Göktaş on 29.10.2018.
//  Copyright © 2018 Anıl Göktaş. All rights reserved.
//

import UIKit

protocol AlertPresentable: class {
    func alert(title: String, message: String, cancelButtonTitle: String)
}

extension AlertPresentable where Self: UIViewController {
    
    func alert(title: String, message: String, cancelButtonTitle: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: cancelButtonTitle, style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func alertSomethingWentWrong() {
        alert(title: "Oops!", message: "Something went wrong, please try again.", cancelButtonTitle: "OK")
    }
    
}
