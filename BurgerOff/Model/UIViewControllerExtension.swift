//
//  UIViewControllerExtension.swift
//  BurgerOff
//
//  Created by Joshua Best on 02/04/2019.
//  Copyright © 2019 JoshInc. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func showAlert(title: String, message: String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
}
