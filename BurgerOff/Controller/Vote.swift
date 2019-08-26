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
    
    var team : Team!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Voting for: \(team.name!)"
        
        print("Team ID: \(team.uid)")
        print("My ID: \(FirebaseService.shared.USER_ID)")
        
    }
    
    private func submitRatings(pattyRating : Int, overallRating: Int, appearanceRating: Int, completed : @escaping () -> ()){
        let updatedRatings = Score(pattyTaste: "\(pattyRating + Int(team!.score!.pattyTaste)!)", burgerTaste: "\(overallRating + Int(team!.score!.burgerTaste)!)", appearance: "\(appearanceRating + Int(team!.score!.appearance)!)")
        
        let teamRef = FirebaseService.shared.TEAM_URL.child(team.uid!)
        let currentUserRef = FirebaseService.shared.USER_URL.child(FirebaseService.shared.USER_ID).child("ratings").child("ratedScores").child(team.name!)
        
        do{
            try teamRef.child("score").updateChildValues(updatedRatings.asDictionary(), withCompletionBlock: { (error, ref) in
                if error != nil {
                    self.showAlert(title: "Error", message: "Unsuccessful \(error!.localizedDescription)")
                }
            })
            
            teamRef.child("voteesUids").setValue(team.voteesUids + FirebaseService.shared.USER_ID)
            
            do {
                
                let userScoreDict = try Score( pattyTaste: "\(pattyRating)/50", burgerTaste: "\(overallRating)/40", appearance: "\(appearanceRating)/10").asDictionary()
                
                currentUserRef.setValue(userScoreDict)
                
            } catch {}
            
            incrementVotesMade()
            completed()
            
        } catch {
            self.showAlert(title: "Error", message: error.localizedDescription)
        }
    }
    
    private func incrementVotesMade(){
        let votesRef = FirebaseService.shared.BASE_URL.child("votesmade")
        
        votesRef.observeSingleEvent(of: .value) { snapshot in
            
            guard let object = snapshot.value as? [String : Any] else { return }
            
            do{
                let data = try JSONSerialization.data(withJSONObject: object, options: .prettyPrinted)
                let score = try JSONDecoder().decode(Int.self, from: data)
                votesRef.setValue(score + 1)
            } catch {
                print(error)
                self.showAlert(title: "Error", message: error.localizedDescription)
                KVLoading.hide()
            }
        }
    }
    
    private func getUpdatedUserValues(completed : @escaping () -> ()){
        
        let ref = FirebaseService.shared.TEAM_URL.child(team.uid!).child("/score")
        
        ref.observeSingleEvent(of: .value) { snapshot in
            
            print(snapshot)
            guard let object = snapshot.value as? [String : Any] else { return }

            do{
                let data = try JSONSerialization.data(withJSONObject: object, options: .prettyPrinted)
                let score = try JSONDecoder().decode(Score.self, from: data)
                self.team.score = score
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
