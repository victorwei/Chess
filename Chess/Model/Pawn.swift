//
//  Pawn.swift
//  Chess
//
//  Created by Victor Wei on 10/12/17.
//  Copyright © 2017 vDub. All rights reserved.
//

import Foundation
import UIKit

class Pawn: Pieces {
    
    convenience init(color: Pieces.Side) {
        self.init()
        if color == .white {
            image = UIImage(named: "pawn_white")
        } else {
            image = UIImage(named: "pawn_black")
        }
        
        self.title = PiecesType.Pawn
    }
    
}
