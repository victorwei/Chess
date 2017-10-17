//
//  Bishop.swift
//  Chess
//
//  Created by Victor Wei on 10/12/17.
//  Copyright © 2017 vDub. All rights reserved.
//

import Foundation
import UIKit

class Bishop: Pieces {
    
    convenience init(frame: CGRect, color: Pieces.Side) {
        self.init(frame: frame)
        if color == .white {
            image = UIImage(named: "bishop_white")
        } else {
            image = UIImage(named: "bishop_black")
        }
        title = PiecesType.Bishop
        imageView.image = image
        
    }
}
