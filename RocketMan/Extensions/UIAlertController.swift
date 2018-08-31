//
//  UIAlertController.swift
//  RocketMan
//
//  Created by Dennis Vera on 8/31/18.
//  Copyright © 2018 Dennis Vera. All rights reserved.
//

import UIKit

extension UIViewController {
    
    // MARK: - Alerts
    
    func showAlert(with title: String, and message: String) {
        // Initialize Alert Controller
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // Configure Alert Controller
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        // Present Alert Controller
        present(alertController, animated: true, completion: nil)
    }
    
}
