//
//  TeamOptions.swift
//  BurgerOff
//
//  Created by Joshua Best on 26/08/2019.
//  Copyright © 2019 JoshInc. All rights reserved.
//

import UIKit

class TeamOptions: UIViewController {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var yesBtn: RoundedButton!
    @IBOutlet weak var noBtn: RoundedButton!
    @IBOutlet weak var createBtn: RoundedButton!
    @IBOutlet weak var joinBtn: RoundedButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    private func teamOptionViews(){
        createBtn.isHidden = false
        joinBtn.isHidden = false
        yesBtn.isHidden = true
        noBtn.isHidden = true
        
        titleLbl.text = "Do you want to create or join a team?"
        
        //incrementVotesNeeded()
    }
    
    private func incrementVotesNeeded(){
        let votesRef = FirebaseService.shared.BASE_URL.child("votesneeded")
        
        votesRef.observeSingleEvent(of: .value) { snapshot in
            
            guard let object = snapshot.value as? Int else { return }
            
            do{
                let data = try JSONSerialization.data(withJSONObject: object, options: .prettyPrinted)
                let score = try JSONDecoder().decode(Int.self, from: data)
                votesRef.setValue(score + 1)
                
            } catch {
                print(error)
                self.showAlert(title: "Error", message: error.localizedDescription)
            }
        }
    }
    
    private func joinNoTeam(){
        let team = Team(name: "No Team", uid: nil, score: nil, members: nil, voteesUids: "")
        
        let teamRef = FirebaseService.shared.USER_URL.child(FirebaseService.shared.USER_ID).child("team")
        
        do {
            try teamRef.updateChildValues(team.asDictionary(), withCompletionBlock: { (error, ref) in
                if error != nil {
                    self.showAlert(title: "Error", message: "Unsuccessful \(error!.localizedDescription)")
                } else {
                    self.dismiss(animated: true, completion: nil)
                }
            })
        } catch {}
        
    }
    
    @IBAction func yesBtnPressed(_ sender: Any) {
        teamOptionViews()
    }
    
    @IBAction func noBtnPressed(_ sender: Any) {
        joinNoTeam()
    }
    
    @IBAction func createBtnPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "createteam", sender: self)
    }
    
    @IBAction func joinBtnPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "jointeam", sender: self)
    }
}
