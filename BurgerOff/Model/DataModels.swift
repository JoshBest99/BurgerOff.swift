//
//  Ratings.swift
//  BurgerOff
//
//  Created by Joshua Best on 04/04/2019.
//  Copyright © 2019 JoshInc. All rights reserved.
//

import Foundation

typealias DownloadComplete = () -> ()

struct User: Codable {
    
    var uid: String
    var username: String
    var profileImageUrl: String
    var burgerImageUrl: String = ""
    var team: Team?
    
}

struct Score: Codable {
    
    var pattyTaste: String
    var burgerTaste: String
    var appearance: String
    
}

struct Team : Codable {
    
    var name: String?
    var uid: String?
    var score: Score?
    var members: [User]?
    var voteesUids: String
    
}

extension Encodable {
    func asDictionary() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            throw NSError()
        }
        return dictionary
    }
}


