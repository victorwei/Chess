//
//  Knight.swift
//  Chess
//
//  Created by Victor Wei on 10/12/17.
//  Copyright © 2017 vDub. All rights reserved.
//

import Foundation
import UIKit

class Knight: Pieces {
    
    convenience init(color: Pieces.Side) {
        self.init()
        if color == .white {
            image = UIImage(named: "knight_white")
        } else {
            image = UIImage(named: "knight_black")
        }
        self.title = PiecesType.Knight
    }
}
