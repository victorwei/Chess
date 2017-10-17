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
    
    convenience init(frame: CGRect, color: Pieces.Side) {
        self.init(frame: frame)
        if color == .white {
            image = UIImage(named: "pawn_white")
            imageView.image = image
        } else {
            image = UIImage(named: "pawn_black")
            imageView.image = image
        }
        
        self.title = PiecesType.Pawn
        imageView.image = image
    }
    
}
