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
    
    convenience init(frame: CGRect, color: Pieces.Side) {
        self.init(frame: frame)
        if color == .white {
            image = UIImage(named: "knight_white")
            imageView.image = image
            
        } else {
            image = UIImage(named: "knight_black")
            imageView.image = image
        }
        self.title = PiecesType.Knight
        imageView.image = image
    }
}
