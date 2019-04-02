//
//  SignUp.swift
//  BurgerOff
//
//  Created by Joshua Best on 02/04/2019.
//  Copyright © 2019 JoshInc. All rights reserved.
//

import UIKit
import Firebase

class SignUp: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var profileImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    private func registerUser(email: String, password: String){
    
    }
    
    @IBAction func signUpBtnPressed(_ sender: UIButton) {
        if usernameTextField.text!.isEmpty || passwordTextField.text!.isEmpty || emailTextField.text!.isEmpty{
            self.showAlert(title: "Missing Information", message: "Please make sure you have added a username, email and password.")
        }
    }
    
    @IBAction func profileImageBtnPressed(_ sender: UIButton) {
    }
    
    @IBAction func backBtnPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
