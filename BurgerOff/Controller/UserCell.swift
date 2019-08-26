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
    @IBOutlet weak var profileImageViewTwo: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configureCell(team: Team){
        nameLbl.text = team.name
        profileImageView.loadImageUsingCacheWithUrlString(team.members![0].profileImageUrl)
        
        if team.members!.count == 2 {
            profileImageViewTwo.loadImageUsingCacheWithUrlString(team.members![1].profileImageUrl)
        }
        
        if !canVoteForTeam(team: team){
            nameLbl.textColor = UIColor.green
        } else {
            nameLbl.textColor = UIColor.red
        }
    }
    
    func canVoteForTeam(team: Team) -> Bool {
        
        if team.voteesUids.contains(FirebaseService.shared.USER_ID){
            return false
        }
        
        for user in team.members! {
            if user.uid.contains(FirebaseService.shared.USER_ID){
                return false
            }
        }
        
        return true
    }
    
}
