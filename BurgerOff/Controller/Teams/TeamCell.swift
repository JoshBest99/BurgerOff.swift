//
//  TeamCell.swift
//  BurgerOff
//
//  Created by Joshua Best on 26/08/2019.
//  Copyright © 2019 JoshInc. All rights reserved.
//

import UIKit

class TeamCell: UITableViewCell {

    @IBOutlet weak var nameLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureCell(team: Team) {
        nameLbl.text = team.name
    }

}
