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
    
    private var users = [User]()
    private var selectedUser : User!
    
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
        FirebaseService.shared.USER_URL.observeSingleEvent(of: .value, with: { snapshot in
            
            guard let object = snapshot.children.allObjects as? [DataSnapshot] else { return }
           
            let dict = object.compactMap { $0.value as? [String : Any] }
            
            do{
                
                let data = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
                let usersObject = try JSONDecoder().decode([User].self, from: data)
                self.users = usersObject
            
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
                voteVC.user = selectedUser
            }
        }
        
    }
}

extension Home : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "usercell", for: indexPath) as! UserCell
        
        let user = users[indexPath.row]
        cell.configureCell(user: user)
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedUser = users[indexPath.row]
        
        if selectedUser.uid == FirebaseService.shared.USER_ID{
            self.showAlert(title: "You can't do that", message: "You cannot vote for yourself")
        } else if selectedUser.ratings.ratedUids.contains(FirebaseService.shared.USER_ID){
            self.showAlert(title: "You can't do that", message: "You cannot vote for \(selectedUser.username) twice")
        } else {
            self.performSegue(withIdentifier: "vote", sender: self)
        }
        
    }
    
    
}
