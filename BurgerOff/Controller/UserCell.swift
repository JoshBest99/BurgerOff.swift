//
//  UserCell.swift
//  BurgerOff
//
//  Created by Joshua Best on 04/04/2019.
//  Copyright © 2019 JoshInc. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {

    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var profileImageView: RoundedImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configureCell(user: User){
        nameLbl.text = user.username
        profileImageView.loadImageUsingCacheWithUrlString(user.profileImageUrl)
        
//        if user.ratings!.ratedUids.contains(FirebaseService.shared.USER_ID) || user.uid == FirebaseService.shared.USER_ID{
//            nameLbl.textColor = UIColor.green
//        } else {
//            nameLbl.textColor = UIColor.red
//        }
    }
    
}
