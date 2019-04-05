//
//  CircleImageView.swift
//  BurgerOff
//
//  Created by Joshua Best on 05/04/2019.
//  Copyright © 2019 JoshInc. All rights reserved.
//

import Foundation

class CircleImageView : UIButton {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = layer.bounds.width / 2
    }
    
}
