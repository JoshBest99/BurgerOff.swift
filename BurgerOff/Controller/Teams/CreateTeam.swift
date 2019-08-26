//
//  CreateTeam.swift
//  
//
//  Created by Joshua Best on 26/08/2019.
//

import UIKit

class CreateTeam: UIViewController {

    @IBOutlet weak var teamNameText: UITextField!
    
    var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    private func createTeam(user: User) {
        
        users.append(user)
        
        let team = Team(name: teamNameText.text!, uid: UUID.init().uuidString, score: Score(pattyTaste: "0", burgerTaste: "0", appearance: "0"), members: users, voteesUids: "")
        let ref = FirebaseService.shared.TEAM_URL.child(team.uid!)
        
        do {
            try ref.updateChildValues(team.asDictionary(), withCompletionBlock: { (error, ref) in
                if error != nil {
                    self.showAlert(title: "Error", message: "Unsuccessful \(error!.localizedDescription)")
                } else {
                    self.updateTeam(team: team)
                }
            })
        } catch {}
    }
    
    private func updateTeam(team : Team){
        
        let ref = FirebaseService.shared.USER_URL.child(FirebaseService.shared.USER_ID).child("team")
        
        do {
            try ref.updateChildValues(team.asDictionary(), withCompletionBlock: { (error, ref) in
                if error != nil {
                    self.showAlert(title: "Error", message: "Unsuccessful \(error!.localizedDescription)")
                } else {
                    self.performSegue(withIdentifier: "home", sender: self)
                }
            })
        }catch {}
        
    }
    
    private func getCurrentUser(){
        let ref = FirebaseService.shared.USER_URL.child(FirebaseService.shared.USER_ID)
        
        ref.observeSingleEvent(of: .value) { snapshot in
            
            print(snapshot)
            guard let object = snapshot.value as? [String : Any] else { return }
            
            do{
                let data = try JSONSerialization.data(withJSONObject: object, options: .prettyPrinted)
                let user = try JSONDecoder().decode(User.self, from: data)
                print("username \(user.username)")
                print("userid \(user.uid)")
                self.createTeam(user: user)
            } catch {
                print(error)
                self.showAlert(title: "Error", message: error.localizedDescription)
            }
        }
        
    }
    
    @IBAction func createBtnPressed(_ sender: Any) {
        getCurrentUser()
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
