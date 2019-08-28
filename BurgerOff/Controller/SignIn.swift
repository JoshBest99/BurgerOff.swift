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
            
            let email = KeychainWrapper.standard.string(forKey: "email")
            let password = KeychainWrapper.standard.string(forKey: "password")
            if email != nil {
                if email != "" {
                    signInUser(email: email!, password: password!)
                }
            }
            //self.performSegue(withIdentifier: "home", sender: self)
        }
    }
    
    private func signInUser(email: String, password: String){
        KVLoading.show()
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            
            KVLoading.hide()
            
            if error == nil {
                KeychainWrapper.standard.set(email, forKey: "email")
                KeychainWrapper.standard.set(password, forKey: "password")
                self.getCurrentUser()
            } else {
                self.showAlert(title: "Error", message: "Unsuccessful \(error!.localizedDescription)")
            }
            
        }
    }
    
    private func getCurrentUser(){
        let ref = FirebaseService.shared.USER_URL.child(FirebaseService.shared.USER_ID)
        
        ref.observeSingleEvent(of: .value) { snapshot in
            
            print(snapshot)
            guard let object = snapshot.value as? [String : Any] else { return }
            
            do{
                let data = try JSONSerialization.data(withJSONObject: object, options: .prettyPrinted)
                let user = try JSONDecoder().decode(User.self, from: data)
                if user.team != nil {
                    self.performSegue(withIdentifier: "home", sender: self)
                } else {
                    self.performSegue(withIdentifier: "teamoptions", sender: self)
                }
                
            } catch {
                print(error)
                self.showAlert(title: "Error", message: error.localizedDescription)
                KVLoading.hide()
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

