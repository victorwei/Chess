//
//  King.swift
//  Chess
//
//  Created by Victor Wei on 10/12/17.
//  Copyright © 2017 vDub. All rights reserved.
//

import Foundation
import UIKit

class King: Pieces {
    
    convenience init(color: Pieces.Side) {
        self.init()
        if color == .white {
            image = UIImage(named: "king_white")
        } else {
            image = UIImage(named: "king_black")
        }
        self.title = PiecesType.King
        
    }
    
}
