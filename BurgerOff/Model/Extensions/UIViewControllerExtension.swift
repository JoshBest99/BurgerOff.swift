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
    
    func showCameraAlert(picker : UIImagePickerController){
    
        let alertController = UIAlertController(title: "Profile Picture", message: "", preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: "Choose from library", style: .default, handler: { _ in
            picker.sourceType = .photoLibrary
            self.present(picker, animated: true, completion: nil)
        }))
        
        alertController.addAction(UIAlertAction(title: "Take a picture", style: .default, handler: { _ in
            picker.sourceType = .camera
            self.present(picker, animated: true, completion: nil)
        }))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
}
