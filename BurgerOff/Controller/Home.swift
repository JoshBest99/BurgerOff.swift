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

class Home: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self

        KVLoading.show()
        getUserList{
            KVLoading.hide()
        }
    }
    
    private func getUserList(completed : @escaping () -> ()){
        FirebaseService.shared.USER_URL.observeSingleEvent(of: .value, with: { snapshot in
            
            guard let object = snapshot.children.allObjects as? [DataSnapshot] else { return }
           
            let dict = object.compactMap { $0.value as? [String : Any] }
            
            do{
                let data = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
                let usersObject = try JSONDecoder().decode([User].self, from: data)
                self.users = usersObject
            } catch {}
                
            self.tableView.reloadData()
                
            completed()
            
        })
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
    
    
}
