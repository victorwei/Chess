//
//  Queen.swift
//  Chess
//
//  Created by Victor Wei on 10/12/17.
//  Copyright © 2017 vDub. All rights reserved.
//

import Foundation
import UIKit

class Queen: Pieces {
 
    convenience init(color: Pieces.Side) {
        self.init()
        if color == .white {
            image = UIImage(named: "queen_white")
        } else {
            image = UIImage(named: "queen_black")
        }
        
        self.title = PiecesType.Queen
    }
}
