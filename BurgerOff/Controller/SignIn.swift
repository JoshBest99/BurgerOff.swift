//
//  ViewController.swift
//  BurgerOff
//
//  Created by Joshua Best on 02/04/2019.
//  Copyright © 2019 JoshInc. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper
import KVLoading

class SignIn: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if KeychainWrapper.standard.string(forKey: "email") != nil
            && KeychainWrapper.standard.string(forKey: "password") != nil{
            self.performSegue(withIdentifier: "home", sender: self)
        }
    }
    
    private func signInUser(email: String, password: String){
        KVLoading.show()
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            
            KVLoading.hide()
            
            if error == nil {
                KeychainWrapper.standard.set(self.emailTextField.text!, forKey: "email")
                KeychainWrapper.standard.set(self.passwordTextField.text!, forKey: "password")
                self.performSegue(withIdentifier: "home", sender: self)
            } else {
                self.showAlert(title: "Error", message: "Unsuccessful \(error!.localizedDescription)")
            }
            
        }
    }
    
    @IBAction func signInBtnPressed(_ sender: UIButton) {
        if emailTextField.text != nil && passwordTextField.text != nil {
            signInUser(email: emailTextField.text!, password: passwordTextField.text!)
        } else {
            self.showAlert(title: "Missing Information", message: "Please make sure you have added an email and password")
        }
    }
}

