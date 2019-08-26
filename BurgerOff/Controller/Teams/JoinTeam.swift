//
//  JoinTeam.swift
//  BurgerOff
//
//  Created by Joshua Best on 26/08/2019.
//  Copyright © 2019 JoshInc. All rights reserved.
//

import UIKit
import KVLoading
import Firebase

class JoinTeam: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var teams = [Team]()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        KVLoading.show()
        getTeamList{
            KVLoading.hide()
        }
    }
    
    private func getTeamList(completed : @escaping DownloadComplete){
        FirebaseService.shared.TEAM_URL.observeSingleEvent(of: .value, with: { snapshot in
            
            guard let object = snapshot.children.allObjects as? [DataSnapshot] else { return }
            
            let dict = object.compactMap { $0.value as? [String : Any] }
            
            do{
                
                let data = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
                let teamsObject = try JSONDecoder().decode([Team].self, from: data)
                
                for team in teamsObject {
                    if team.members!.count != 2 {
                        self.teams.append(team)
                    }
                }
                
            } catch {
                self.showAlert(title: "Error", message: error.localizedDescription)
            }
            
            self.tableView.reloadData()
            
            completed()
            
        })
    }
    
    private func updateTeam(user: User, selectedTeam: Team, completed : @escaping DownloadComplete) {
        
        var team = selectedTeam
        
        team.members!.append(user)
        
        let ref = FirebaseService.shared.TEAM_URL.child(selectedTeam.uid!)
        
        do {
            try ref.updateChildValues(team.asDictionary(), withCompletionBlock: { (error, ref) in
                if error == nil {
                    self.updateUser(selectedTeam: team, completed: completed)
                }
            })
        } catch {}
    }
    
    private func updateUser(selectedTeam: Team, completed : @escaping DownloadComplete){
        
        let ref = FirebaseService.shared.USER_URL.child(FirebaseService.shared.USER_ID).child("team")
        
        do {
            try ref.updateChildValues(selectedTeam.asDictionary(), withCompletionBlock: { (error, ref) in
                if error == nil{
                    completed()
                    self.performSegue(withIdentifier: "home", sender: self)
                }
            })
        }catch {}
        
    }
    
    private func getCurrentUser(selectedTeam: Team, completed : @escaping DownloadComplete){
        let ref = FirebaseService.shared.USER_URL.child(FirebaseService.shared.USER_ID)
        
        ref.observeSingleEvent(of: .value) { snapshot in
            
            print(snapshot)
            guard let object = snapshot.value as? [String : Any] else { return }
            
            do{
                let data = try JSONSerialization.data(withJSONObject: object, options: .prettyPrinted)
                let user = try JSONDecoder().decode(User.self, from: data)
                print("username \(user.username)")
                print("userid \(user.uid)")
                self.updateTeam(user: user, selectedTeam: selectedTeam, completed: completed)
            } catch {
                print(error)
            }
        }
        
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension JoinTeam : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teams.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "teamcell", for: indexPath) as! TeamCell
        
        let team = teams[indexPath.row]
        cell.configureCell(team: team)
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        KVLoading.show()
        self.getCurrentUser(selectedTeam: teams[indexPath.row]) {
            KVLoading.hide()
        }
    }
}

