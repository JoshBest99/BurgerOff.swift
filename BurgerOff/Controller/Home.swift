//
//  Home.swift
//  BurgerOff
//
//  Created by Joshua Best on 04/04/2019.
//  Copyright © 2019 JoshInc. All rights reserved.
//

import UIKit
import Firebase
import KVLoading
import SwiftKeychainWrapper


class Home: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private var teams = [Team]()
    private var selectedTeam : Team!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //FirebaseService.shared.setUSER_ID(userid: Auth.auth().currentUser!.uid)
    
        tableView.delegate = self
        tableView.dataSource = self

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        KVLoading.show()
        getUserList{
            KVLoading.hide()
        }
    }
    
    private func getUserList(completed : @escaping DownloadComplete){
        FirebaseService.shared.TEAM_URL.observeSingleEvent(of: .value, with: { snapshot in
            
            guard let object = snapshot.children.allObjects as? [DataSnapshot] else { return }
           
            let dict = object.compactMap { $0.value as? [String : Any] }
            
            do{
                
                let data = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
                let teamsObject = try JSONDecoder().decode([Team].self, from: data)
                self.teams = teamsObject
            
            } catch {
                self.showAlert(title: "Error", message: error.localizedDescription)
                completed()
            }
                
            self.tableView.reloadData()
                
            completed()
            
        })
    }
    
    @IBAction func refreshBtnPressed(_ sender: UIButton) {
        
        KVLoading.show()
        getUserList{
            KVLoading.hide()
        }
        
    }
    
    @IBAction func profileBtnPressed(_ sender: UIButton) {
        
        self.performSegue(withIdentifier: "profile", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            
        if let navController = segue.destination as? UINavigationController {
            if let voteVC = navController.viewControllers.first as? Vote{
                voteVC.team = selectedTeam
            }
        }
        
    }
}

extension Home : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teams.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "usercell", for: indexPath) as! UserCell
        
        let team = teams[indexPath.row]
        cell.configureCell(team: team)
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedTeam = teams[indexPath.row]
        
        if isMyTeam(){
            self.showAlert(title: "You can't do that", message: "You cannot vote for yourself")
        } else if selectedTeam.voteesUids.contains(FirebaseService.shared.USER_ID){
            self.showAlert(title: "You can't do that", message: "You cannot vote for \(selectedTeam.name!) twice")
        } else {
            self.performSegue(withIdentifier: "vote", sender: self)
        }
        
    }
    
    func isMyTeam() -> Bool {
        
        for user in selectedTeam.members! {
            if user.uid.contains(FirebaseService.shared.USER_ID){
                return true
            }
        }
        
        return false
    }
    
    
}
