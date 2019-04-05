//
//  Ratings.swift
//  BurgerOff
//
//  Created by Joshua Best on 04/04/2019.
//  Copyright © 2019 JoshInc. All rights reserved.
//

import Foundation

typealias DownloadComplete = () -> ()

struct Ratings: Codable{
    
    var pattyTaste: Int
    var burgerTaste: Int
    var appearance: Int
    var ratedUids: String
    
}

struct User: Codable {
    
    var uid: String
    var username: String
    var profileImageUrl: String
    var burgerImageUrl: String = ""
    var ratings: Ratings
    
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


