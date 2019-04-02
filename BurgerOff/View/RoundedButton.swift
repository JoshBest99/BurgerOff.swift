//
//  RoundedButton.swift
//  BurgerOff
//
//  Created by Joshua Best on 02/04/2019.
//  Copyright © 2019 JoshInc. All rights reserved.
//

import UIKit

class RoundedButton: UIButton {

    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = layer.bounds.width / 2
    }

}
