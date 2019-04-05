//
//  Vote.swift
//  BurgerOff
//
//  Created by Joshua Best on 05/04/2019.
//  Copyright © 2019 JoshInc. All rights reserved.
//

import UIKit
import KVLoading
import Firebase

class Vote: UIViewController {
    
    @IBOutlet weak var pattyLabel: UILabel!
    @IBOutlet weak var pattySlider: UISlider!
    
    @IBOutlet weak var overallLabel: UILabel!
    @IBOutlet weak var overallSlider: UISlider!
    
    @IBOutlet weak var appearanceLabel: UILabel!
    @IBOutlet weak var appearanceSlider: UISlider!
    
    var user : User!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Voting for: \(user.username)"
        
    }
    
    private func submitRatings(pattyRating : Int, overallRating: Int, appearanceRating: Int, completed : @escaping () -> ()){
        let updatedRatings = Ratings(pattyTaste: pattyRating + user.ratings.pattyTaste, burgerTaste: overallRating + user.ratings.burgerTaste, appearance: appearanceRating + user.ratings.appearance, ratedUids: user.ratings.ratedUids + FirebaseService.shared.USER_ID)
        let ref = FirebaseService.shared.USER_URL.child(user.uid).child("ratings")
        
        do{
            try ref.updateChildValues(updatedRatings.asDictionary(), withCompletionBlock: { (error, ref) in
                if error != nil {
                    self.showAlert(title: "Error", message: "Unsuccessful \(error!.localizedDescription)")
                }
            })
            
            completed()
            
        } catch {
            self.showAlert(title: "Error", message: error.localizedDescription)
        }
    }
    
    private func getUpdatedUserValues(completed : @escaping () -> ()){
        
        let ref = FirebaseService.shared.USER_URL.child(user.uid).child("ratings")
        
        ref.observeSingleEvent(of: .value) { snapshot in
            
            print(snapshot)
            guard let object = snapshot.value as? [String : Any] else { return }

            do{
                let data = try JSONSerialization.data(withJSONObject: object, options: .prettyPrinted)
                let ratings = try JSONDecoder().decode(Ratings.self, from: data)
                self.user.ratings = ratings
                completed()
            } catch {
                print(error)
                self.showAlert(title: "Error", message: error.localizedDescription)
                KVLoading.hide()
            }
        }
    }
    
    @IBAction func pattySliderValueChanged(_ sender: Any) {
        let pattyRating = Int(pattySlider.value)
        pattyLabel.text = "Patty Quality: \(pattyRating)"
    }
    
    @IBAction func overallSliderValueChanged(_ sender: Any) {
        let overallRating = Int(overallSlider.value)
        overallLabel.text = "Overall Burger Taste: \(overallRating)"
    }
    
    @IBAction func appearanceSliderValueChanged(_ sender: Any) {
        let appearanceRating = Int(appearanceSlider.value)
        appearanceLabel.text = "Appearance: \(appearanceRating)"
    }
    
    @IBAction func submitBtnPressed(_ sender: UIButton) {
        KVLoading.show()
        self.getUpdatedUserValues {
            self.submitRatings(pattyRating: Int(self.pattySlider.value), overallRating: Int(self.overallSlider.value), appearanceRating: Int(self.appearanceSlider.value)){
                KVLoading.hide()
                self.dismiss(animated: true, completion: nil)
            }
        }
        
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
