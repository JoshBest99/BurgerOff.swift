//
//  SignUp.swift
//  BurgerOff
//
//  Created by Joshua Best on 02/04/2019.
//  Copyright © 2019 JoshInc. All rights reserved.
//

import UIKit
import Firebase
import KVLoading
import SwiftKeychainWrapper

class SignUp: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var addPhotoBtn: RoundedButton!
    
    private let picker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        picker.delegate = self
        
    }
    
    private func registerUser(email: String, password: String){
        
        KVLoading.show()
    
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!, completion:{ (user, error) in
            
            if error != nil {
                KVLoading.hide()
                self.showAlert(title: "Error", message: "Unsuccessful \(error!.localizedDescription)")
            } else {
                self.uploadImageToFirebase()
            }
            
        })
    }
    
    private func uploadImageToFirebase(){
        let filename = UUID.init().uuidString
        let ref = FirebaseService.shared.IMAGES_URL.child(filename)
        guard let image = profileImageView.image?.jpegData(compressionQuality: 1) else { return }
        
        ref.putData(image, metadata: nil, completion: {(metadata, error) in
            if error != nil{
                KVLoading.hide()
                self.showAlert(title: "Error", message: "Unsuccessful \(error!.localizedDescription)")
            } else {
                guard let imageUrl = metadata?.downloadURL()?.absoluteString else { return }
                self.saveUserToDatabase(profileImageURL: imageUrl)
            }
        })
    }
    
    private func saveUserToDatabase(profileImageURL : String){
        
        let user = User(uid: FirebaseService.shared.USER_ID, username: usernameTextField.text!, profileImageUrl: profileImageURL,burgerImageUrl: "", team: nil)
        
        let ref = FirebaseService.shared.USER_URL.child(FirebaseService.shared.USER_ID)
        
        do{
            try ref.updateChildValues(user.asDictionary(), withCompletionBlock: { (error, ref) in
                if error != nil {
                    KVLoading.hide()
                    self.showAlert(title: "Error", message: "Unsuccessful \(error!.localizedDescription)")
                } else {
                    KVLoading.hide()
                    KeychainWrapper.standard.set(self.emailTextField.text!, forKey: "email")
                    KeychainWrapper.standard.set(self.passwordTextField.text!, forKey: "password")
                    self.dismiss(animated: true, completion: nil)
                    //self.performSegue(withIdentifier: "home", sender: self)
                }
            })
        } catch {
            KVLoading.hide()
            self.showAlert(title: "Error", message: error as! String)
        }
        
    }
    
    
    @IBAction func signUpBtnPressed(_ sender: UIButton) {
        if usernameTextField.text!.isEmpty || passwordTextField.text!.isEmpty || emailTextField.text!.isEmpty || profileImageView.image == nil{
            self.showAlert(title: "Missing Information", message: "Please make sure you have added a username, email and password and a profile picture.")
        } else {
            registerUser(email: emailTextField.text!, password: passwordTextField.text!)
        }
    }
    
    @IBAction func profileImageBtnPressed(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            self.showCameraAlert(picker: picker)
        }
    }
    
    @IBAction func backBtnPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension SignUp : UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            addPhotoBtn.isHidden = true
            profileImageView.image = image
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
