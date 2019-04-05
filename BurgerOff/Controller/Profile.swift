//
//  Profile.swift
//  BurgerOff
//
//  Created by Joshua Best on 05/04/2019.
//  Copyright © 2019 JoshInc. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import KVLoading
import Firebase

class Profile: UIViewController {
    
    @IBOutlet weak var burgerImageView: RoundedImageView!
    
    private let picker = UIImagePickerController()
    var user: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        picker.delegate = self
        
        KVLoading.show()
        getUserValues {
            if self.user.burgerImageUrl != ""{
                self.burgerImageView.loadImageUsingCacheWithUrlString(self.user.burgerImageUrl)
            }
        }
        
    }
    
    private func getUserValues(completed : @escaping () -> ()){
        
        let ref = FirebaseService.shared.USER_URL.child(FirebaseService.shared.USER_ID)
        
        ref.observeSingleEvent(of: .value) { snapshot in
            
            print(snapshot)
            guard let object = snapshot.value as? [String : Any] else { return }
            
            do{
                let data = try JSONSerialization.data(withJSONObject: object, options: .prettyPrinted)
                let userObject = try JSONDecoder().decode(User.self, from: data)
                self.user = userObject
                completed()
            } catch {
                print(error)
                self.showAlert(title: "Error", message: error.localizedDescription)
                KVLoading.hide()
            }
        }
    }
    
    private func uploadBurgerImageToFirebase(){
        KVLoading.show()
        let filename = "BurgerImage\(FirebaseService.shared.USER_ID)\(UUID.init().uuidString)"
        let ref = FirebaseService.shared.IMAGES_URL.child(filename)
        guard let image = burgerImageView.image?.jpegData(compressionQuality: 1) else { return }
        
        ref.putData(image, metadata: nil, completion: {(metadata, error) in
            if error != nil{
                KVLoading.hide()
                self.showAlert(title: "Error", message: "Unsuccessful \(error!.localizedDescription)")
            } else {
                guard let imageUrl = metadata?.downloadURL()?.absoluteString else { return }
                self.saveImageUrlToDatabase(url: imageUrl)
            }
        })
    }
    
    private func saveImageUrlToDatabase(url: String){
        
        let ref = FirebaseService.shared.USER_URL.child(user.uid)
        
        ref.updateChildValues(["burgerImageUrl" : url], withCompletionBlock: { (error, ref) in
            if error != nil {
                KVLoading.hide()
                self.showAlert(title: "Error", message: "Unsuccessful \(error!.localizedDescription)")
            } else {
                KVLoading.hide()
            }
        })
    }
    
    @IBAction func editImageBtnPressed(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            self.showCameraAlert(picker: picker)
        }
    }
    
    @IBAction func logoutBtnPressed(_ sender: RoundedButton) {
        KeychainWrapper.standard.removeAllKeys()
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func backBtnPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension Profile : UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            burgerImageView.image = image
            uploadBurgerImageToFirebase()
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
