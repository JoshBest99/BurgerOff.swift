//
//  FirebaseService.swift
//  BurgerOff
//
//  Created by Joshua Best on 04/04/2019.
//  Copyright © 2019 JoshInc. All rights reserved.
//

import Foundation
import Firebase

class FirebaseService {
    
    static let shared = FirebaseService()
    
    private let _baseURL = Database.database().reference()
    private let _storageURL = Storage.storage().reference()
    private let _userURL = Database.database().reference().child("users")
    private let _teamURL = Database.database().reference().child("teams")
    private let _imagesURL = Storage.storage().reference().child("images")
    private var _uid = Auth.auth().currentUser?.uid
    
    var BASE_URL : DatabaseReference {
        return _baseURL
    }
    
    var STORAGE_URL : StorageReference {
        return _storageURL
    }
    
    var USER_URL : DatabaseReference {
        return _userURL
    }
    
    var TEAM_URL : DatabaseReference {
        return _teamURL
    }
    
    var IMAGES_URL : StorageReference {
        return _imagesURL
    }
    
    var USER_ID : String {
        return _uid ?? ""
    }
    
    func setUSER_ID(userid: String){
        self._uid = userid
    }
    
}
